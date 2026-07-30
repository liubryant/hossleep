// @keepTs
// @ts-nocheck
import { commonEventManager } from '@kit.BasicServicesKit';
export declare const RESULT_KEY_BIZ_NO = "bizNo";
export declare const RESULT_KEY_COOKIE_VALUE = "x5SecCookie";
export declare const RESULT_KEY_COOKIE_KEY = "x5SecCookieKey";
export type onResultCallBack = (code: number, token: string, result: Map<string, string>) => void;
export type onReadyCallBack = () => void;
export declare class JShieldCaptchaBroadCastReceiver {
    private onResultCallBackCaches;
    private onReadyCallBackCaches;
    private static instance;
    static getInstance(): JShieldCaptchaBroadCastReceiver;
    constructor();
    addOnResultCallBack(q47: string, r47: onResultCallBack): void;
    addOnReadyCallBack(o47: string, p47: onReadyCallBack): void;
    onReceive(k47: commonEventManager.CommonEventData): void;
    handleExit(e47: Map<string, Object>): void;
    handlePageReady(b47: Map<string, Object>): void;
}
