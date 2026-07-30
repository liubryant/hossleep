// @keepTs
// @ts-nocheck
export declare const CAPTCHA_PAGE_TYPE_DISPOSE = "Dispose";
export declare const CAPTCHA_PAGE_TYPE_NORMAL = "Normal";
export declare class AntCaptchaConfig {
    language: string;
    isCanceledOnTouchOutside: boolean;
    timeOut: number;
    backgroundColor: ResourceColor | null;
    captchaCoreUrl: string | Resource | null;
    loading: string;
    hideBar: Array<string> | null;
    pageType: string;
    clientType: string;
    AIMode: boolean;
    transparentParams: Map<string, string>;
    extraParams: Map<string, string>;
    getHideBar(): Array<string> | null;
    setHideBar(g46: Array<string>): AntCaptchaConfig;
    getCaptchaCoreUrl(): string | Resource | null;
    setCaptchaCoreUrl(f46: string | Resource): AntCaptchaConfig;
    getLanguage(): string;
    setLanguage(e46: string): AntCaptchaConfig;
    getIsCanceledOnTouchOutside(): boolean;
    setIsCanceledOnTouchOutside(d46: boolean): AntCaptchaConfig;
    getTimeout(): number;
    setTimeout(c46: number): AntCaptchaConfig;
    setBackgroundColor(b46: ResourceColor): AntCaptchaConfig;
    setPageType(a46?: string): AntCaptchaConfig;
    setTransparentParams(z45: Map<string, string>): AntCaptchaConfig;
    setExtraParams(y45: Map<string, string>): AntCaptchaConfig;
    setAIMode(x45?: boolean): AntCaptchaConfig;
    getBackgroundColor(): ResourceColor | null;
    toMap(): Map<string, string>;
}
