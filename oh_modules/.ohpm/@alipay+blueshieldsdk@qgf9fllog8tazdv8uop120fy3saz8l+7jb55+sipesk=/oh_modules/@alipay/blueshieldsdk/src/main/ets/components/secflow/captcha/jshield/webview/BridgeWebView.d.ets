// @keepTs
// @ts-nocheck
import { webview } from '@kit.ArkWeb';
import { ParamsHolder } from '../ParamsHolder';
import { JSBridgeController } from './JSBridgeController';
@Component
export declare struct BridgeWebView {
    webViewController: webview.WebviewController | null;
    jsBridgeController: JSBridgeController | null;
    holder: ParamsHolder | null;
    url: ResourceStr;
    onControllerAttached: () => void;
    aboutToAppear(): void;
    aboutToDisappear(): void;
    build(): void;
}
