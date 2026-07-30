import { http } from '@kit.NetworkKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

interface InfoData {
  storySwitch?: number | string;
}

interface InfoResponse {
  resultCode?: number;
  data?: InfoData;
}

const DOMAIN: number = 0x0000;
const INFO_URL: string = 'https://www.cjym123.cn/api/info';

export class RemoteContentConfig {
  static async fetchStorySwitch(): Promise<number> {
    const request = http.createHttp();
    try {
      const response = await request.request(INFO_URL, {
        method: http.RequestMethod.GET,
        expectDataType: http.HttpDataType.STRING,
        connectTimeout: 5000,
        readTimeout: 8000
      });
      if (response.responseCode < 200 || response.responseCode >= 300) {
        hilog.error(DOMAIN, 'hossleep',
          'Remote storySwitch request failed, httpCode=%{public}d', response.responseCode);
        return 0;
      }
      const root = JSON.parse(response.result as string) as InfoResponse;
      const raw = root.data?.storySwitch;
      const enabled = root.resultCode === 200 && Number(raw) === 1 ? 1 : 0;
      hilog.info(DOMAIN, 'hossleep',
        'Remote content config loaded: storySwitch=%{public}d, articlesEnabled=%{public}s',
        enabled, enabled === 1 ? 'true' : 'false');
      return enabled;
    } catch (error) {
      hilog.error(DOMAIN, 'hossleep',
        'Remote storySwitch load failed, fallback=0, error=%{public}s', `${error}`);
      return 0;
    } finally {
      request.destroy();
    }
  }
}
