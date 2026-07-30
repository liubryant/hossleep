// @keepTs
// @ts-nocheck
import { OnBridgeCallback } from './OnBridgeCallback';
export interface WebViewJavascriptBridge {
    sendToWeb(data: string): void;
    sendToWeb(data: string, responseCallback: OnBridgeCallback): void;
}
