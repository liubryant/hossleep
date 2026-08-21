import { common } from '@kit.AbilityKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import { http } from '@kit.NetworkKit';
import { MindfulnessItem } from '../models/MindfulnessData';

interface RemoteMindfulnessJson {
  id?: number;
  title?: string;
  contentType?: string;
  sizeBytes?: number;
  downloadUrl?: string;
}

export class MindfulnessCatalog {
  private static readonly BASE_URL: string = 'https://www.cjym123.cn';

  static async load(context: common.UIAbilityContext): Promise<MindfulnessItem[]> {
    const request = http.createHttp();
    try {
      const response = await request.request(`${MindfulnessCatalog.BASE_URL}/api/mindfulness`, {
        method: http.RequestMethod.GET,
        expectDataType: http.HttpDataType.STRING,
        connectTimeout: 15000,
        readTimeout: 30000
      });
      if (response.responseCode < 200 || response.responseCode >= 300) {
        throw new Error(`正念列表请求失败（${response.responseCode}）`);
      }
      const rows = JSON.parse(response.result as string) as RemoteMindfulnessJson[];
      return rows.filter((row: RemoteMindfulnessJson): boolean =>
        row.id !== undefined && row.title !== undefined && row.downloadUrl !== undefined)
        .map((row: RemoteMindfulnessJson): MindfulnessItem => MindfulnessCatalog.toItem(context, row));
    } finally {
      request.destroy();
    }
  }

  static isCached(context: common.UIAbilityContext, item: MindfulnessItem): boolean {
    if (item.isBundledAudio !== false) {
      return true;
    }
    try {
      return fs.accessSync(item.audio);
    } catch (_) {
      return false;
    }
  }

  static async download(context: common.UIAbilityContext, item: MindfulnessItem,
    onProgress: (value: number) => void): Promise<void> {
    if (item.isBundledAudio !== false || MindfulnessCatalog.isCached(context, item)) {
      onProgress(1);
      return;
    }
    const directory = item.audio.substring(0, item.audio.lastIndexOf('/'));
    try {
      fs.mkdirSync(directory);
    } catch (_) {
    }
    const request = http.createHttp();
    let displayedProgress = 0;
    const progressTimer = setInterval(() => {
      if (displayedProgress < 0.9) {
        const step = displayedProgress < 0.25 ? 0.035 : displayedProgress < 0.65 ? 0.018 : 0.008;
        displayedProgress = Math.min(0.9, displayedProgress + step);
        onProgress(displayedProgress);
      }
    }, 250);
    request.on('dataReceiveProgress', (info: http.DataReceiveProgressInfo) => {
      if (info.totalSize > 0) {
        displayedProgress = Math.max(displayedProgress, info.receiveSize / info.totalSize);
      } else if (info.receiveSize > 0) {
        displayedProgress = Math.max(displayedProgress,
          Math.min(0.88, 0.08 + info.receiveSize / (info.receiveSize + 1024 * 1024)));
      }
      onProgress(Math.max(0.01, Math.min(0.95, displayedProgress)));
    });
    try {
      onProgress(0);
      const url = item.downloadUrl && item.downloadUrl.startsWith('http')
        ? item.downloadUrl : `${MindfulnessCatalog.BASE_URL}${item.downloadUrl ?? ''}`;
      const response = await request.request(url, {
        method: http.RequestMethod.GET,
        expectDataType: http.HttpDataType.ARRAY_BUFFER,
        connectTimeout: 20000,
        readTimeout: 120000
      });
      if (response.responseCode < 200 || response.responseCode >= 300) {
        throw new Error(`正念音频下载失败（${response.responseCode}）`);
      }
      const file = fs.openSync(item.audio, fs.OpenMode.WRITE_ONLY | fs.OpenMode.CREATE | fs.OpenMode.TRUNC);
      try {
        fs.writeSync(file.fd, response.result as ArrayBuffer);
      } finally {
        fs.closeSync(file);
      }
      onProgress(1);
    } finally {
      clearInterval(progressTimer);
      request.destroy();
    }
  }

  private static toItem(context: common.UIAbilityContext, row: RemoteMindfulnessJson): MindfulnessItem {
    const id = row.id ?? 0;
    const coverIndex = id % 8 + 1;
    const extension = MindfulnessCatalog.extensionFor(row.contentType ?? 'audio/mpeg');
    return {
      id: `remote-${id}`,
      title: row.title ?? '正念冥想',
      subtitle: '云端正念 · 下载后离线播放',
      cover: `mindfulness/covers/${coverIndex}.png`,
      audio: `${context.cacheDir}/Mindfulness/remote-${id}.${extension}`,
      colors: ['#294F57', '#3B686B'],
      isBundledAudio: false,
      downloadUrl: row.downloadUrl ?? '',
      sizeBytes: row.sizeBytes ?? 0
    };
  }

  private static extensionFor(contentType: string): string {
    if (contentType.includes('mp4')) return 'm4a';
    if (contentType.includes('aac')) return 'aac';
    if (contentType.includes('wav')) return 'wav';
    if (contentType.includes('ogg')) return 'ogg';
    return 'mp3';
  }
}
