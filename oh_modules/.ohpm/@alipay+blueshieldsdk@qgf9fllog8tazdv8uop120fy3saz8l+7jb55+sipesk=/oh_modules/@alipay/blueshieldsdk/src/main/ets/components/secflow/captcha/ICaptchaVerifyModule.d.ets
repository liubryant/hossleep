// @keepTs
// @ts-nocheck
export declare enum CAPTCHA_CODE {
    OK = 0,
    ERROR_CODE_INVALID_PARAM = 1001,
    ERROR_CODE_CAPTCHA_FAIL = 1002,
    ERROR_CODE_CAPTCHA_CLOSE = 1003,
    ERROR_CODE_CAPTCHA_DEGRAGE = 1004,
    ERROR_CODE_CAPTCHA_ERROR = 1005,
    ERROR_CODE_OPEN_PAGE_TIMEOUT_ERROR = 1006
}
export declare enum CAPTCHA_PARAM {
    CAPTCHA_TYPE = "type",
    CAPTCHA_ID = "captchaId",
    HOST = "host",
    CAPTCHA_CORE_URL = "captchaCoreUrl",
    LANGUAGE = "language",
    EXTRA_DATA = "extraData",
    HIDE_BAR = "hideBar",
    IS_CANCELED_ON_TOUCH_OUTSIDE = "isCanceledOnTouchOutside",
    TIMEOUT = "timeout",
    BACKGROUND_COLOR = "backgroundColor",
    PAGE_TYPE = "pageType",
    CAPTCHA_CONFIG = "captchaConfig",
    UA = "ua",
    AI_MODE = "AIMode"
}
export declare const PAGE_NAME_RDS = "JShieldCaptcha";
export declare enum CAPTCHA_TYPE {
    JSHIELD = 1
}
export interface ICaptchaVerifyModule {
    onCaptchaVerify: (params: Map<string, string>, callback: CaptchaVerifyCallback) => void;
    getRiskData: (captchaId: string, params?: Map<string, string>) => Promise<string | undefined>;
}
export interface CaptchaVerifyCallback {
    onVerified: (secToken: string, extraInfo: Map<string, string>, errorCode: number) => void;
}
