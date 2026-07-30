import { common, wantAgent, WantAgent } from '@kit.AbilityKit';
import { reminderAgentManager } from '@kit.BackgroundTasksKit';
import { image } from '@kit.ImageKit';
import { notificationManager } from '@kit.NotificationKit';
import { StoryListItem } from '../models/SleepModels';
import { StoryCatalog } from './StoryCatalog';

const BUNDLE_NAME: string = 'hm.cjym.timesleep';
const ABILITY_NAME: string = 'EntryAbility';
const REMINDER_GROUP: string = 'daily_story_recommendation';

export class StoryNotificationService {
  static async enable(context: common.UIAbilityContext): Promise<boolean> {
    try {
      if (!notificationManager.isNotificationEnabledSync()) {
        await notificationManager.requestEnableNotification(context);
      }
      if (!notificationManager.isNotificationEnabledSync()) {
        return false;
      }
      await StoryNotificationService.scheduleDailyStories(context);
      return true;
    } catch (_) {
      // 用户拒绝通知权限时不影响应用其他功能。
      return false;
    }
  }

  static async disable(): Promise<void> {
    try {
      await reminderAgentManager.cancelAllReminders();
    } catch (_) {
    }
  }

  private static async publishPreview(context: common.UIAbilityContext): Promise<void> {
    const story = await StoryCatalog.random(context);
    try {
      const agent = await StoryNotificationService.createWantAgent(story.index, 9000 + story.index);
      const coverPath = (story.coverFile ?? '').length > 0
        ? story.coverFile ?? ''
        : `ios_story_covers/story_${StoryNotificationService.pad2(story.index)}.jpg`;
      const cover = await context.resourceManager.getRawFileContent(coverPath);
      const source = image.createImageSource(cover.buffer as ArrayBuffer);
      const pixelMap = await source.createPixelMap({
        desiredSize: { width: 640, height: 360 },
        desiredPixelFormat: image.PixelMapFormat.RGBA_8888
      });
      const iconPixelMap = await source.createPixelMap({
        desiredSize: { width: 112, height: 112 },
        desiredPixelFormat: image.PixelMapFormat.RGBA_8888
      });
      await notificationManager.publish({
        id: 9000,
        notificationSlotType: notificationManager.SlotType.SERVICE_INFORMATION,
        content: {
          notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_PICTURE,
          picture: {
            title: `今晚故事 · ${story.title}`,
            text: '放松下来，听一个温柔的睡前故事',
            additionalText: '点击立即播放',
            lockscreenPicture: iconPixelMap,
            briefText: '时光睡眠为你精选',
            expandedTitle: story.title,
            picture: pixelMap
          }
        },
        largeIcon: iconPixelMap,
        wantAgent: agent,
        tapDismissed: true,
        color: 0xFF182235,
        colorEnabled: true
      });
      source.release();
    } catch (_) {
      await StoryNotificationService.publishTextPreview(story);
    }
  }

  private static async publishTextPreview(story: StoryListItem): Promise<void> {
    const agent = await StoryNotificationService.createWantAgent(story.index, 9000 + story.index);
    await notificationManager.publish({
      id: 9000,
      notificationSlotType: notificationManager.SlotType.SERVICE_INFORMATION,
      content: {
        notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_LONG_TEXT,
        longText: {
          title: `今晚故事 · ${story.title}`,
          text: '放松下来，听一个温柔的睡前故事',
          additionalText: '点击立即播放',
          longText: `时光睡眠为你精选《${story.title}》。闭上眼睛，跟随声音进入故事世界。`,
          briefText: '时光睡眠为你精选',
          expandedTitle: story.title
        }
      },
      wantAgent: agent,
      tapDismissed: true
    });
  }

  private static async scheduleDailyStories(context: common.UIAbilityContext): Promise<void> {
    try {
      await reminderAgentManager.cancelAllReminders();
    } catch (_) {
    }

    const hours: number[] = [11, 16, 20];
    for (let index = 0; index < hours.length; index++) {
      const story = await StoryCatalog.random(context);
      const request: reminderAgentManager.ReminderRequestAlarm = {
        reminderType: reminderAgentManager.ReminderType.REMINDER_TYPE_ALARM,
        hour: hours[index],
        minute: 0,
        daysOfWeek: [1, 2, 3, 4, 5, 6, 7],
        title: `今日故事 · ${story.title}`,
        content: `时光睡眠为你精选，点击立即播放《${story.title}》`,
        expiredContent: `《${story.title}》正在等你`,
        notificationId: 9100 + index,
        groupId: REMINDER_GROUP,
        slotType: notificationManager.SlotType.SERVICE_INFORMATION,
        tapDismissed: true,
        wantAgent: {
          pkgName: BUNDLE_NAME,
          abilityName: ABILITY_NAME,
          parameters: {
            notificationStoryIndex: story.index
          }
        }
      };
      try {
        await reminderAgentManager.publishReminder(request);
      } catch (_) {
      }
    }
  }

  private static async createWantAgent(storyIndex: number, requestCode: number): Promise<WantAgent> {
    return wantAgent.getWantAgent({
      wants: [{
        bundleName: BUNDLE_NAME,
        abilityName: ABILITY_NAME,
        parameters: {
          notificationStoryIndex: storyIndex
        }
      }],
      actionType: wantAgent.OperationType.START_ABILITY,
      requestCode: requestCode,
      actionFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
    });
  }

  private static pad2(value: number): string {
    return value < 10 ? `0${value}` : `${value}`;
  }
}
