// @keepTs
// @ts-nocheck
import { OnCloseListener, OnErrorListener, OnReadyListener, OnSuccessListener } from './AntCaptchaClient';
import { AntCaptchaConfig } from './AntCaptchaConfig';
export declare class ParamsHolder {
    private _onSuccessListenerList;
    private _onErrorListenerList;
    private _onReadyListenerList;
    private _onCloseListenerList;
    private _logEnable;
    get logEnable(): boolean;
    set logEnable(w49: boolean);
    private _captchaId;
    get captchaId(): string;
    set captchaId(v49: string);
    private _host;
    get host(): string;
    set host(u49: string);
    private _config;
    get config(): AntCaptchaConfig | undefined;
    set config(t49: AntCaptchaConfig | undefined);
    notifySuccess(q49: string, r49: Map<string, string>): void;
    notifyReady(): void;
    notifyClose(): void;
    notifyError(m49: string): void;
    notifyErrorCode(i49: number): void;
    removeOnErrorListener(h49: OnErrorListener): void;
    addOnErrorListener(g49: OnErrorListener): void;
    removeOnSuccessListener(f49: OnSuccessListener): void;
    addOnSuccessListener(e49: OnSuccessListener): void;
    removeOnCloseListener(d49: OnCloseListener): void;
    addOnCloseListener(c49: OnCloseListener): void;
    removeOnReadyListener(b49: OnReadyListener): void;
    addOnReadyListener(a49: OnReadyListener): void;
}
