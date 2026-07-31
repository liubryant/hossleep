import { common } from '@kit.AbilityKit';
import { preferences } from '@kit.ArkData';

const STORE_NAME: string = 'sleep_reports';
const REPORTS_KEY: string = 'reports';
const MAX_REPORTS: number = 90;

export interface SleepReport {
  id: string;
  startTime: number;
  endTime: number;
  durationSeconds: number;
  averageDbfs: number;
  peakDbfs: number;
  hasNoiseData: boolean;
  recordingPath: string;
}

export class SleepReportStore {
  static async load(context: common.UIAbilityContext): Promise<SleepReport[]> {
    const store = await preferences.getPreferences(context, STORE_NAME);
    const json = await store.get(REPORTS_KEY, '[]') as string;
    try {
      const reports = JSON.parse(json) as SleepReport[];
      return reports
        .filter((item: SleepReport): boolean =>
          item.startTime > 0 && item.endTime >= item.startTime && item.durationSeconds >= 0)
        .sort((left: SleepReport, right: SleepReport): number => right.startTime - left.startTime)
        .slice(0, MAX_REPORTS);
    } catch (_) {
      return [];
    }
  }

  static async add(context: common.UIAbilityContext, report: SleepReport): Promise<SleepReport[]> {
    const reports = await SleepReportStore.load(context);
    const updated = [report, ...reports.filter((item: SleepReport): boolean => item.id !== report.id)]
      .slice(0, MAX_REPORTS);
    const store = await preferences.getPreferences(context, STORE_NAME);
    await store.put(REPORTS_KEY, JSON.stringify(updated));
    await store.flush();
    return updated;
  }

  static async clear(context: common.UIAbilityContext): Promise<void> {
    const store = await preferences.getPreferences(context, STORE_NAME);
    await store.put(REPORTS_KEY, '[]');
    await store.flush();
  }
}
