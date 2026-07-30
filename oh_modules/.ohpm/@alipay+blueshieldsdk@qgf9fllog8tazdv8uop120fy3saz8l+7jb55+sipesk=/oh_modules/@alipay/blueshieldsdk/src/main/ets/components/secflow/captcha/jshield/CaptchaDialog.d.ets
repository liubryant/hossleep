// @keepTs
// @ts-nocheck
import { ParamsHolder } from './ParamsHolder';
import { webview } from '@kit.ArkWeb';
import { JSBridgeController } from './webview/JSBridgeController';
@CustomDialog
export declare struct CaptchaDialog {
    controller: CustomDialogController;
    holder: ParamsHolder | null;
    webViewController: webview.WebviewController | null;
    jsBridgeController: JSBridgeController | null;
    aboutToAppear(): void;
    build(): void;
}
