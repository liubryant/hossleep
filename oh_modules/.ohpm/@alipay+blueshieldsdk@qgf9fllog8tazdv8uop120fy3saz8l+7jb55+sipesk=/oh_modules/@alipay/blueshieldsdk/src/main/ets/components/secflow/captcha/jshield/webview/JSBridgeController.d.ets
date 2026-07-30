// @keepTs
// @ts-nocheck
import { Message } from './Message';
import { OnBridgeCallback } from './OnBridgeCallback';
import { ArrayList, HashMap } from '@kit.ArkTS';
import { webview } from '@kit.ArkWeb';
export declare class JSBridgeController {
    webViewController: webview.WebviewController;
    private uniqueId;
    private startupMessage;
    constructor(e55: webview.WebviewController);
    private _responseCallbacks;
    get responseCallbacks(): HashMap<String, OnBridgeCallback>;
    setStartupMessage(d55: ArrayList<Message> | null): void;
    getStartupMessage(): ArrayList<Message> | null;
    doSend(y54: string | null, z54: string, a55: OnBridgeCallback): void;
    callHandler(v54: string, w54: string, x54: OnBridgeCallback): void;
    sendResponse(s54: string, t54: string): void;
    dispatchMessage(p54: Message): void;
    private queueMessage;
}
