// @keepTs
// @ts-nocheck
import common from '@ohos.app.ability.common';
export declare class BlueShieldManager {
    constructor();
    static setContext(y2: common.Context): boolean;
    static getInstance(): BlueShieldManager;
    initialize(n2?: string, o2?: Map<string, string>): number;
    getModule(m2: BlueShieldModuleType): Object | null;
}
export declare const enum BlueShieldModuleType {
    BS_STATIC_STORE_MODULE = 0,
    BS_STATIC_CRYPTO_MODULE = 1,
    BS_ENVELOPE_CRYPTO_MODULE = 2,
    BS_DYNAMIC_CRYPTO_MODULE = 3,
    BS_SAFE_SIGNATURE_MODULE = 4,
    BS_SAFE_OTP_MODULE = 5,
    BS_TRUSTED_SIGNATURE_MODULE = 6,
    BS_TRUSTED_ENGINE_MODULE = 7,
    BS_DEVICE_FEATURE_MODULE = 8,
    BS_SAFE_TOKEN_MODULE = 9,
    BS_APDID_MODULE = 16,
    BS_RDS_MODULE = 32,
    BS_DEVICE_COLOR_MODULE = 33,
    BS_CAPTCHA_MODULE = 34,
    BS_EDGE_RISK_MODULE = 48,
    BS_TEE_TOKEN_MODULE = 64
}
