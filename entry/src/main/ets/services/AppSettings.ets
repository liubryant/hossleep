/**
 * 对应 Android AppSettings，持久化隐私同意、登录与监测设置。
 */
import { common } from '@kit.AbilityKit';
import { preferences } from '@kit.ArkData';
import { SleepReportData } from '../models/SleepModels';

const STORE_NAME: string = 'app_settings';

export interface SavedSettings {
  agreementAccepted: boolean;
  isLoggedIn: boolean;
  phoneNumber: string;
  accessToken: string;
  saveAudioClips: boolean;
  sensitivity: number;
  favoriteSoundIds: string[];
  favoriteStoryIds: string[];
  storyReminderEnabled: boolean;
  storyReminderAsked: boolean;
  sleepSensitiveConsent: boolean;
  sleepReport: SleepReportData;
  sleepReports: SleepReportData[];
}

export class AppSettings {
  static async load(context: common.UIAbilityContext): Promise<SavedSettings> {
    const store = await preferences.getPreferences(context, STORE_NAME);
    const favoriteJson = await store.get('sounds.favoriteIds', '[]') as string;
    let favoriteSoundIds: string[] = [];
    try {
      favoriteSoundIds = JSON.parse(favoriteJson) as string[];
    } catch (_) {
      favoriteSoundIds = [];
    }
    const favoriteStoryJson = await store.get('stories.favoriteIds', '[]') as string;
    let favoriteStoryIds: string[] = [];
    try {
      favoriteStoryIds = JSON.parse(favoriteStoryJson) as string[];
    } catch (_) {
      favoriteStoryIds = [];
    }
    const reportJson = await store.get('sleep.latestReport', '') as string;
    let sleepReport: SleepReportData = AppSettings.emptySleepReport();
    if (reportJson.length > 0) {
      try {
        sleepReport = JSON.parse(reportJson) as SleepReportData;
      } catch (_) {
        sleepReport = AppSettings.emptySleepReport();
      }
    }
    const reportsJson = await store.get('sleep.reportHistory', '[]') as string;
    let sleepReports: SleepReportData[] = [];
    try {
      sleepReports = JSON.parse(reportsJson) as SleepReportData[];
    } catch (_) {
      sleepReports = [];
    }
    return {
      agreementAccepted: await store.get('agreement_accepted', false) as boolean,
      isLoggedIn: await store.get('profile.isLoggedIn', false) as boolean,
      phoneNumber: await store.get('profile.phoneNumber', '') as string,
      accessToken: await store.get('profile.accessToken', '') as string,
      saveAudioClips: await store.get('settings.saveAudioClips', true) as boolean,
      sensitivity: await store.get('settings.sensitivity', 0.65) as number,
      favoriteSoundIds: favoriteSoundIds,
      favoriteStoryIds: favoriteStoryIds,
      storyReminderEnabled: await store.get('notifications.storyReminderEnabled', false) as boolean,
      storyReminderAsked: await store.get('notifications.storyReminderAsked', false) as boolean,
      sleepSensitiveConsent: await store.get('privacy.sleepSensitiveConsent', false) as boolean,
      sleepReport: sleepReport,
      sleepReports: sleepReports
    };
  }

  static async acceptAgreement(context: common.UIAbilityContext): Promise<void> {
    await AppSettings.write(context, 'agreement_accepted', true);
  }

  static async login(context: common.UIAbilityContext, phone: string, accessToken: string = ''): Promise<void> {
    const store = await preferences.getPreferences(context, STORE_NAME);
    await store.put('profile.phoneNumber', phone);
    await store.put('profile.isLoggedIn', true);
    await store.put('profile.accessToken', accessToken);
    await store.flush();
  }

  static async logout(context: common.UIAbilityContext): Promise<void> {
    const store = await preferences.getPreferences(context, STORE_NAME);
    await store.put('profile.isLoggedIn', false);
    await store.put('profile.accessToken', '');
    await store.flush();
  }

  static async clearAccount(context: common.UIAbilityContext): Promise<void> {
    const store = await preferences.getPreferences(context, STORE_NAME);
    await store.put('profile.isLoggedIn', false);
    await store.put('profile.phoneNumber', '');
    await store.put('profile.accessToken', '');
    await store.flush();
  }

  static async setSaveAudioClips(context: common.UIAbilityContext, value: boolean): Promise<void> {
    await AppSettings.write(context, 'settings.saveAudioClips', value);
  }

  static async setSensitivity(context: common.UIAbilityContext, value: number): Promise<void> {
    await AppSettings.write(context, 'settings.sensitivity', value);
  }

  static async setFavoriteSoundIds(context: common.UIAbilityContext, ids: string[]): Promise<void> {
    await AppSettings.write(context, 'sounds.favoriteIds', JSON.stringify(ids));
  }

  static async setFavoriteStoryIds(context: common.UIAbilityContext, ids: string[]): Promise<void> {
    await AppSettings.write(context, 'stories.favoriteIds', JSON.stringify(ids));
  }

  static async setStoryReminderEnabled(context: common.UIAbilityContext, value: boolean): Promise<void> {
    await AppSettings.write(context, 'notifications.storyReminderEnabled', value);
  }

  static async markStoryReminderAsked(context: common.UIAbilityContext): Promise<void> {
    await AppSettings.write(context, 'notifications.storyReminderAsked', true);
  }

  static async acceptSleepSensitiveConsent(context: common.UIAbilityContext): Promise<void> {
    await AppSettings.write(context, 'privacy.sleepSensitiveConsent', true);
  }

  static async setSleepReport(context: common.UIAbilityContext, report: SleepReportData): Promise<void> {
    const store = await preferences.getPreferences(context, STORE_NAME);
    const reportsJson = await store.get('sleep.reportHistory', '[]') as string;
    let reports: SleepReportData[] = [];
    try {
      reports = JSON.parse(reportsJson) as SleepReportData[];
    } catch (_) {
      reports = [];
    }
    reports.push(report);
    reports = reports
      .filter((item: SleepReportData): boolean => item.hasData && item.endedAt > 0)
      .sort((left: SleepReportData, right: SleepReportData): number => right.endedAt - left.endedAt)
      .slice(0, 180);
    await store.put('sleep.latestReport', JSON.stringify(report));
    await store.put('sleep.reportHistory', JSON.stringify(reports));
    await store.flush();
  }

  static async clearSleepReport(context: common.UIAbilityContext): Promise<void> {
    const store = await preferences.getPreferences(context, STORE_NAME);
    await store.put('sleep.latestReport', '');
    await store.put('sleep.reportHistory', '[]');
    await store.flush();
  }

  private static emptySleepReport(): SleepReportData {
    return {
      hasData: false, endedAt: 0, durationSeconds: 0, averageDecibels: 0, peakDecibels: 0,
      score: 60, efficiency: 0, quietPercent: 0, deepSeconds: 0,
      lightSeconds: 0, dreamSeconds: 0, awakeSeconds: 0, events: []
    };
  }

  private static async write(context: common.UIAbilityContext, key: string,
    value: boolean | number | string): Promise<void> {
    const store = await preferences.getPreferences(context, STORE_NAME);
    await store.put(key, value);
    await store.flush();
  }
}
