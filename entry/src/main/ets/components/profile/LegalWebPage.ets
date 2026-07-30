import { webview } from '@kit.ArkWeb';
import { SleepColor } from '../../common/SleepDesign';
import { CommonNavBar } from '../common/CommonNavBar';

@Component
export struct LegalWebPage {
  title: string = '';
  url: string = '';
  onBack: () => void = () => {};
  private controller: webview.WebviewController = new webview.WebviewController();

  build() {
    Column() {
      CommonNavBar({ title: this.title, onBack: this.onBack })
      Web({ src: this.url, controller: this.controller })
        .javaScriptAccess(false)
        .domStorageAccess(false)
        .layoutWeight(1)
        .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(SleepColor.background)
  }
}
