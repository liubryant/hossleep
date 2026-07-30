// @keepTs
// @ts-nocheck
export declare enum CAPTCHA_ACTION {
    MODULE_CREATED = 1,
    WEBVIEW_CREATED = 2,
    CAPTCHA_READY = 3,
    CAPTCHA_SUCCESS = 4,
    CAPTCHA_FAIL = 5,
    CAPTCHA_ERROR = 6,
    CAPTCHA_CLOSE = 7,
    CAPTCHA_CONSULT = 8
}
export declare const CAPTCHA_HEADER_ACTION = "x-dispose-action";
export declare const CAPTCHA_HEADER_DISPOSE_UUID = "x-dispose-uuid";
export declare const CAPTCHA_HEADER_EXTINFO = "x-dispose-extinfo";
export declare const CAPTCHA_HEADER_DISPOSE_ACCESS_POINT = "x-dispose-access-point";
export declare const CAPTCHA_HEADER_DISPOSE_NAME = "x-dispose-name";
export declare const CAPTCHA_HEADER_DISPOSE_APPLICATION = "x-dispose-application";
export declare const CAPTCHA_HEADER_DISPOSE_TRACE = "x-dispose-trace";
export declare const CAPTCHA_HEADER_DISPOSE_SERVICE = "x-dispose-service";
export declare const CAPTCHA_REPEAT_EXT_TAG = "security_rds_captcha_repeat";
export declare const CAPTCHA_STATUS_EXT_TAG = "security_rds_captcha_status";
export declare const CAPTCHA_ACTION_TYPE = "actionType";
export declare const CAPTCHA_ACTION_TITLE = "tips";
export declare const CAPTCHA_ACTION_SUBTITLE = "memo";
export declare const CAPTCHA_ACTION_IMG = "backgroundImage";
export declare const CAPTCHA_ACTION_TITLE_BAR = "titleBar";
export declare const CAPTCHA_ACTION_MOVE = "move";
export declare const CAPTCHA_ACTION_QR = "qr";
export declare const CAPTCHA_ACTION_COMPANY = "company";
export declare const CAPTCHA_ACTION_LOADING = "loading";
export declare const CAPTCHA_ACTION_ERROR = "error";
export declare const CAPTCHA_ACTION_REDIRECT_URL = "redirectUrl";
export declare const CAPTCHA_ACTION_REPLAY_ORIGIN_REQUEST = "replayOriginRequest";
export declare const CAPTCHA_ACTION_FEEDBACK_CODE = "feedbackCode";
export declare const CAPTCHA_ACTION_GATEWAY = "gatewayUrl";
export declare const CAPTCHA_ACTION_INTERCEPTOR = "interceptor";
export declare const CAPTCHA_ACTION_CAPTCHA_ID = "captchaId";
export declare const CAPTCHA_ACTION_HOST = "captchaServerHost";
export declare const CAPTCHA_ACTION_EXT_INFO = "disposeCaptchaExtInfo";
