import { init } from '@umeng/analytics';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN: number = 0x0000;

export class UmengAnalytics {
  private static initialized: boolean = false;
  private static initializing: boolean = false;

  static async initialize(): Promise<void> {
    if (UmengAnalytics.initialized || UmengAnalytics.initializing) {
      return;
    }

    UmengAnalytics.initializing = true;
    try {
      await init();
      UmengAnalytics.initialized = true;
      hilog.info(DOMAIN, 'hossleep', '%{public}s', 'Umeng analytics initialized after privacy consent.');
    } catch (error) {
      hilog.error(DOMAIN, 'hossleep', 'Failed to initialize Umeng analytics: %{public}s', `${error}`);
    } finally {
      UmengAnalytics.initializing = false;
    }
  }
}
