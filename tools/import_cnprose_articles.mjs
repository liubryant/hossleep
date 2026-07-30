import { mkdir, writeFile, copyFile, rm } from 'node:fs/promises';
import path from 'node:path';

const baseUrl = 'https://www.cnprose.com';
const projectRoot = path.resolve(import.meta.dirname, '..');
const rawfileRoot = path.join(projectRoot, 'entry/src/main/resources/rawfile');
const storyRoot = path.join(rawfileRoot, 'StoryResources');
const coverRoot = path.join(storyRoot, 'article_covers');
const textRoot = path.join(storyRoot, 'article_texts');
const desktopRoot = '/Users/liuzheng/Desktop/当代名篇文章导出';
const desktopCoverRoot = path.join(desktopRoot, 'covers');
const desktopTextRoot = path.join(desktopRoot, 'texts');
const scenicRoot = '/Users/liuzheng/Desktop/iosnavi/beidou/beidou/Assets.xcassets';
const endpoint = `${baseUrl}/openapi/page/renderList`;
const query = {
  pageId: 'd7d04883-d342-47f2-83ae-cf5d37159cee',
  siteId: '00acabab-4bca-412c-98a8-7c3e03144f85',
  elementId: 'a3b34a12a0aea07',
  language: 'zh',
  deviceType: 'pc',
  d: '0'
};

const headers = {
  'User-Agent': 'Mozilla/5.0',
  Referer: `${baseUrl}/dangdai-mingpian`
};

function decodeHtml(value) {
  return value
    .replaceAll('&quot;', '"')
    .replaceAll('&amp;', '&')
    .replaceAll('&lt;', '<')
    .replaceAll('&gt;', '>')
    .replaceAll('&#39;', "'")
    .replaceAll('&nbsp;', ' ')
    .replace(/&#(\d+);/g, (_, code) => String.fromCodePoint(Number(code)))
    .replace(/&#x([0-9a-f]+);/gi, (_, code) => String.fromCodePoint(parseInt(code, 16)))
    .trim();
}

function parseTitle(rawTitle) {
  const normalized = rawTitle.replace(/\s+/g, ' ').trim();
  const match = normalized.match(/^(.+?)\s*《(.+?)》$/);
  if (!match) {
    return { author: '', workTitle: normalized };
  }
  return { author: match[1].trim(), workTitle: match[2].trim() };
}

function stableHash(value) {
  let result = 0;
  for (const character of value) {
    result = ((result << 5) - result + character.charCodeAt(0)) | 0;
  }
  return Math.abs(result);
}

async function fetchText(url) {
  const response = await fetch(url, { headers });
  if (!response.ok) {
    throw new Error(`${response.status} ${url}`);
  }
  return response.text();
}

async function fetchList() {
  const articles = new Map();
  const categoryHtml = await fetchText(`${baseUrl}/dangdai-mingpian`);
  const totalPages = Number(
    categoryHtml.match(/class="dynamic-pagination[^>]+data-total="(\d+)"/)?.[1] ?? '1'
  );
  const pages = await mapWithConcurrency(
    Array.from({ length: totalPages }, (_, index) => index + 1),
    10,
    async (page) => {
    const url = new URL(endpoint);
    Object.entries(query).forEach(([key, value]) => url.searchParams.set(key, value));
    url.searchParams.set('pn', String(page));
    const payload = JSON.parse(await fetchText(url));
      return payload?.data?.html ?? '';
    }
  );
  for (const html of pages) {
    const pattern = /href="(\/article-detail\/([^"]+))"[^>]*title="([^"]+)"[^>]*class="uk-link-reset"/g;
    for (const match of html.matchAll(pattern)) {
      articles.set(match[2], {
        articleId: match[2],
        rawTitle: decodeHtml(match[3]),
        sourceUrl: `${baseUrl}${match[1]}`
      });
    }
  }
  return [...articles.values()];
}

async function mapWithConcurrency(items, concurrency, operation) {
  const results = new Array(items.length);
  let nextIndex = 0;
  async function worker() {
    while (nextIndex < items.length) {
      const index = nextIndex++;
      results[index] = await operation(items[index], index);
    }
  }
  await Promise.all(Array.from(
    { length: Math.min(concurrency, items.length) },
    () => worker()
  ));
  return results;
}

function findArticleCover(html) {
  const start = html.indexOf('class="inner-detail');
  if (start < 0) {
    return '';
  }
  const end = html.indexOf('<div class="ap-content-container"', start);
  const detail = html.slice(start, end > start ? end : undefined);
  const match = detail.match(/<img[^>]+src=["']([^"']+)["']/i);
  if (!match) {
    return '';
  }
  return new URL(decodeHtml(match[1]), baseUrl).toString();
}

function extractArticleText(html) {
  const start = html.indexOf('class="inner-detail');
  if (start < 0) {
    return '';
  }
  const detailStart = html.lastIndexOf('<div', start);
  const end = html.indexOf('<div class="ap-content-container"', start);
  let detail = html.slice(detailStart >= 0 ? detailStart : start, end > start ? end : undefined);
  detail = detail
    .replace(/<script[\s\S]*?<\/script>/gi, '')
    .replace(/<style[\s\S]*?<\/style>/gi, '')
    .replace(/<br\s*\/?>/gi, '\n')
    .replace(/<\/(?:p|div|h[1-6]|li|blockquote)>/gi, '\n')
    .replace(/<[^>]+>/g, '');
  return decodeHtml(detail)
    .replace(/\u00a0/g, ' ')
    .replace(/[ \t]+/g, ' ')
    .replace(/ *\n */g, '\n')
    .replace(/\n{3,}/g, '\n\n')
    .trim();
}

async function saveRemoteCover(url, destinationBase) {
  const response = await fetch(url, { headers });
  if (!response.ok) {
    return '';
  }
  const contentType = response.headers.get('content-type') ?? '';
  const extension = contentType.includes('png') ? '.png' :
    contentType.includes('webp') ? '.webp' : '.jpg';
  const destination = `${destinationBase}${extension}`;
  await writeFile(destination, Buffer.from(await response.arrayBuffer()));
  return path.basename(destination);
}

async function main() {
  await rm(coverRoot, { recursive: true, force: true });
  await rm(textRoot, { recursive: true, force: true });
  await rm(desktopCoverRoot, { recursive: true, force: true });
  await rm(desktopTextRoot, { recursive: true, force: true });
  await mkdir(coverRoot, { recursive: true });
  await mkdir(textRoot, { recursive: true });
  await mkdir(desktopRoot, { recursive: true });
  await mkdir(desktopCoverRoot, { recursive: true });
  await mkdir(desktopTextRoot, { recursive: true });

  const scenicCovers = Array.from({ length: 24 }, (_, index) => {
    const number = String(index + 1).padStart(2, '0');
    return path.join(scenicRoot, `ScenicCover${number}.imageset`, `ScenicCover${number}.jpg`);
  });
  await Promise.all(scenicCovers.map((source, index) => {
    const number = String(index + 1).padStart(2, '0');
    return copyFile(source, path.join(coverRoot, `scenic_${number}.jpg`));
  }));
  const sourceArticles = await fetchList();
  let completed = 0;
  const skippedArticles = [];
  const manifestResults = await mapWithConcurrency(sourceArticles, 12, async (source, index) => {
    const number = String(index + 1).padStart(4, '0');
    let articleCoverUrl = '';
    let articleText = '';
    let coverName = '';
    let coverSource = '景区封面（回退）';

    try {
      const articleHtml = await fetchText(source.sourceUrl);
      articleCoverUrl = findArticleCover(articleHtml);
      articleText = extractArticleText(articleHtml);
    } catch {
      articleCoverUrl = '';
      articleText = '';
    }
    if (!articleText) {
      const { author, workTitle } = parseTitle(source.rawTitle);
      skippedArticles.push({
        title: workTitle,
        author,
        sourceUrl: source.sourceUrl,
        reason: '来源页面正文为空'
      });
      completed++;
      if (completed % 100 === 0 || completed === sourceArticles.length) {
        process.stdout.write(`Processed ${completed}/${sourceArticles.length}\n`);
      }
      return null;
    }
    if (articleCoverUrl) {
      try {
        coverName = await saveRemoteCover(
          articleCoverUrl,
          path.join(coverRoot, `article_${number}`)
        );
        if (coverName) {
          coverSource = '文章来源页';
        }
      } catch {
        coverName = '';
      }
    }

    if (!coverName) {
      const scenicNumber = String(
        (stableHash(source.articleId) % scenicCovers.length) + 1
      ).padStart(2, '0');
      coverName = `scenic_${scenicNumber}.jpg`;
    }

    const { author, workTitle } = parseTitle(source.rawTitle);
    const textName = `article_${number}.txt`;
    await writeFile(
      path.join(textRoot, textName),
      `${articleText || `《${workTitle}》\n\n文章内容暂时无法读取，请稍后重新导入。`}\n`
    );
    const item = {
      id: `cnprose-${source.articleId}`,
      index: 1001 + index,
      title: workTitle,
      author,
      durationText: '系统语音朗读',
      summary: author
        ? `${author}的散文作品《${workTitle}》，收录于中国散文网“当代名篇”栏目。`
        : `《${workTitle}》收录于中国散文网“当代名篇”栏目。`,
      sourceUrl: source.sourceUrl,
      coverFile: `StoryResources/article_covers/${coverName}`,
      textFile: `StoryResources/article_texts/${textName}`,
      coverSource,
      isBundled: false
    };
    completed++;
    if (completed % 100 === 0 || completed === sourceArticles.length) {
      process.stdout.write(`Processed ${completed}/${sourceArticles.length}\n`);
    }
    return item;
  });
  const manifest = manifestResults.filter((item) => item !== null);

  const json = `${JSON.stringify(manifest, null, 2)}\n`;
  const uniqueCoverNames = [...new Set(
    manifest.map((item) => path.basename(item.coverFile))
  )];
  await Promise.all(uniqueCoverNames.map((coverName) => {
    return copyFile(
      path.join(coverRoot, coverName),
      path.join(desktopCoverRoot, coverName)
    );
  }));
  await Promise.all(manifest.map((item) => {
    const textName = path.basename(item.textFile);
    return copyFile(
      path.join(textRoot, textName),
      path.join(desktopTextRoot, textName)
    );
  }));
  const desktopManifest = manifest.map((item) => ({
    ...item,
    coverFile: `covers/${path.basename(item.coverFile)}`,
    textFile: `texts/${path.basename(item.textFile)}`
  }));
  await writeFile(path.join(storyRoot, 'contemporary_articles.json'), json);
  await writeFile(
    path.join(desktopRoot, '当代名篇文章清单.json'),
    `${JSON.stringify(desktopManifest, null, 2)}\n`
  );
  await writeFile(
    path.join(desktopRoot, '来源页正文为空清单.json'),
    `${JSON.stringify(skippedArticles, null, 2)}\n`
  );
  await writeFile(
    path.join(desktopRoot, 'README.txt'),
    [
      '数据来源：https://www.cnprose.com/dangdai-mingpian',
      `可朗读全文文章数：${manifest.length}`,
      `来源页正文为空、未导入应用：${skippedArticles.length}`,
      '内容范围：标题、作者、来源链接、文章纯文本、原创简介和封面引用信息。',
      '封面规则：优先文章来源页图片；无文章图片时使用 iosnavi 景区封面回退。',
      '应用内点击文章后进入本地故事详情页，可使用系统语音朗读。'
    ].join('\n') + '\n'
  );

  process.stdout.write(`Imported ${manifest.length} articles.\n`);
}

await main();
