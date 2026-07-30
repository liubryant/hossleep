import { common } from '@kit.AbilityKit';
import { util } from '@kit.ArkTS';
import { STORY_ITEMS } from '../models/SleepData';
import { StoryListItem } from '../models/SleepModels';

export class StoryCatalog {
  private static stories: StoryListItem[] = STORY_ITEMS;
  private static loaded: boolean = false;
  private static articlesEnabled: boolean = false;

  static setArticlesEnabled(enabled: boolean): void {
    if (StoryCatalog.articlesEnabled === enabled) {
      return;
    }
    StoryCatalog.articlesEnabled = enabled;
    StoryCatalog.loaded = false;
    StoryCatalog.stories = STORY_ITEMS;
  }

  static async load(context: common.UIAbilityContext): Promise<StoryListItem[]> {
    if (StoryCatalog.loaded) {
      return StoryCatalog.stories;
    }
    if (!StoryCatalog.articlesEnabled) {
      StoryCatalog.stories = STORY_ITEMS;
      StoryCatalog.loaded = true;
      return StoryCatalog.stories;
    }
    try {
      const bytes = await context.resourceManager
        .getRawFileContent('StoryResources/contemporary_articles.json');
      const text = util.TextDecoder.create('utf-8').decodeToString(bytes);
      const articles = JSON.parse(text) as StoryListItem[];
      StoryCatalog.stories = [...STORY_ITEMS, ...articles];
      StoryCatalog.loaded = true;
    } catch (_) {
      StoryCatalog.stories = STORY_ITEMS;
    }
    return StoryCatalog.stories;
  }

  static async random(context: common.UIAbilityContext): Promise<StoryListItem> {
    const stories = await StoryCatalog.load(context);
    return stories[Math.floor(Math.random() * stories.length)];
  }

  static async find(context: common.UIAbilityContext, index: number): Promise<StoryListItem | undefined> {
    const stories = await StoryCatalog.load(context);
    return stories.find((story: StoryListItem): boolean => story.index === index);
  }
}
