// @keepTs
// @ts-nocheck
export interface ITrustedSignatureModule {
    getSign(params: Map<string, Object>): Map<string, string>;
}
export declare const enum BS_TRUSTED_SIGN_TYPE {
    SECURITY_GUARD_MD5 = 0,
    SECURITY_GUARD_HMAC_SHA1 = 1,
    TRUSTED_SIGN_NORMAL = 4
}
export declare const enum BS_TRUSTED_SIGN_ENV {
    TRUSTED_SIGN_ENV_ONLINE = 0,
    TRUSTED_SIGN_ENV_DEV = 1,
    TRUSTED_SIGN_ENV_PRE = 2
}
export declare const enum BS_TRUSTED_SIGN_RESULT {
    TRUSTED_SIGN_RET_KEY_TOKEN = "x-bs-token",
    TRUSTED_SIGN_RET_KEY_SIGN = "x-bs-sign",
    TRUSTED_SIGN_RET_KEY_COLOR = "x-bs-color",
    TRUSTED_SIGN_RET_KEY_ERROR = "x-bs-error"
}
export declare const enum BS_TRUSTED_SIGN_PARAM_KEY {
    TRUSTED_SIGN_PARAM_KEY_SIGN_API = "api",
    TRUSTED_SIGN_PARAM_KEY_SIGN_ENV = "env",
    TRUSTED_SIGN_PARAM_KEY_SIGN_TYPE = "signType",
    TRUSTED_SIGN_PARAM_KEY_SIGN_APPKEY = "appKey",
    TRUSTED_SIGN_PARAM_KEY_SIGN_AUTHCODE = "authCode",
    TRUSTED_SIGN_PARAM_KEY_SIGN_DATA = "signData",
    TRUSTED_SIGN_PARAM_KEY_SIGN_SWITCH = "signSwi"
}
