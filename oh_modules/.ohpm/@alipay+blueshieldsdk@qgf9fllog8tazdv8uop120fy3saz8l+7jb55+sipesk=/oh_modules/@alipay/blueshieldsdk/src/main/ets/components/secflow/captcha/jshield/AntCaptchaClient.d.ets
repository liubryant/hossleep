// @keepTs
// @ts-nocheck
import { AntCaptchaConfig } from './AntCaptchaConfig';
import { ParamsHolder } from './ParamsHolder';
import { webview } from '@kit.ArkWeb';
import { JSBridgeController } from './webview/JSBridgeController';
import { CaptchaLoadResult } from './rpc/verify/model/CaptchaLoadResult';
export declare class AntCaptchaClient implements OnSuccessListener, OnCloseListener, OnErrorListener, OnReadyListener {
    holder: ParamsHolder;
    webViewController: webview.WebviewController;
    jsBridgeController: JSBridgeController;
    private timeoutId;
    private uuid;
    private rdsEngine?;
    private rdsModule?;
    constructor(v45?: UIContext);
    static getVersion(): string;
    init(f45?: string, g45?: string, h45?: AntCaptchaConfig): AntCaptchaClient;
    startH5Page(q44?: string): Promise<void>;
    showCaptcha(k44?: string): Promise<boolean>;
    verify(o43: string, p43: Map<string, string>): Promise<CaptchaLoadResult>;
    getRiskData(k43: string, l43?: Map<string, string> | undefined): Promise<string | undefined>;
    getRiskDataObj(b43: string, c43?: Map<string, string> | undefined): Promise<Map<string, Object> | undefined>;
    initRDS(): Promise<void>;
    showLoading(): void;
    hideLoading(): void;
    onSuccess(u42: string): void;
    onClose(): void;
    onError(t42: string): void;
    clearTimeout(): void;
    onReady(): void;
    setLogEnable(s42: boolean): AntCaptchaClient;
    cancel(): void;
    destroy(): void;
    addOnSuccessListener(r42: OnSuccessListener): AntCaptchaClient;
    removeOnSuccessListener(q42: OnSuccessListener): void;
    addOnErrorListener(p42: OnErrorListener): AntCaptchaClient;
    removeOnErrorListener(o42: OnErrorListener): void;
    addOnReadyListener(n42: OnReadyListener): AntCaptchaClient;
    removeOnReadyListener(m42: OnReadyListener): void;
    addOnCloseListener(l42: OnCloseListener): AntCaptchaClient;
    removeOnCloseListener(k42: OnCloseListener): void;
}
export interface OnSuccessListener {
    onSuccess: (response: string, extraInfo: Map<string, string>) => void;
}
export interface OnErrorListener {
    onError: (error: string) => void;
}
export interface OnReadyListener {
    onReady: () => void;
}
export interface OnCloseListener {
    onClose: () => void;
}
