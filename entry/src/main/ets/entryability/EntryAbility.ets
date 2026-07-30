/**
 * @author liuzheng
 * @mail bryant_liu24@126.com
 */
import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { font, window } from '@kit.ArkUI';

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(DOMAIN, 'hossleep', '%{public}s', 'Ability onCreate');
    this.handleNotificationWant(want);
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.handleNotificationWant(want);
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'hossleep', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    font.registerFont({ familyName: 'MiSans', familySrc: $rawfile('fonts/misans_medium.ttf') });
    font.registerFont({ familyName: 'MiSans-DemiBold', familySrc: $rawfile('fonts/misans_demibold.ttf') });
    font.registerFont({ familyName: 'MiSans-Normal', familySrc: $rawfile('fonts/misans_normal.ttf') });
    // ArkUI 默认正文使用 HarmonyOS Sans/sans-serif；将应用内默认族映射为 MiSans，
    // 让未单独指定字体的 Text、TextInput、按钮和系统控件统一使用 MiSans。
    font.registerFont({ familyName: 'HarmonyOS Sans', familySrc: $rawfile('fonts/misans_normal.ttf') });
    font.registerFont({ familyName: 'sans-serif', familySrc: $rawfile('fonts/misans_normal.ttf') });

    const mainWindow = windowStage.getMainWindowSync();
    mainWindow.setWindowSystemBarProperties({
      statusBarColor: '#F2F2F7',
      statusBarContentColor: '#111827',
      navigationBarColor: '#FFFFFF',
      navigationBarContentColor: '#111827'
    });

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'hossleep', 'Failed to load content: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'hossleep', '%{public}s', 'Succeeded in loading content.');
    });
  }

  onWindowStageDestroy(): void {
    hilog.info(DOMAIN, 'hossleep', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    hilog.info(DOMAIN, 'hossleep', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    hilog.info(DOMAIN, 'hossleep', '%{public}s', 'Ability onBackground');
  }

  private handleNotificationWant(want: Want): void {
    const value = want.parameters?.notificationStoryIndex;
    if (typeof value === 'number' && value > 0) {
      AppStorage.setOrCreate('notificationStoryIndex', value);
    } else {
      AppStorage.setOrCreate('notificationStoryIndex', 0);
    }
  }
}
