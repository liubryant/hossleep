// @keepTs
// @ts-nocheck
export interface ISafeSignatureModule {
    sign(signAlgo: BS_SAFE_SIGNATURE_ALGO, keyName: string, signMessage: Uint8Array): Uint8Array;
    signString(signAlgo: BS_SAFE_SIGNATURE_ALGO, keyName: string, signMessage: string): string;
    verify(signAlgo: BS_SAFE_SIGNATURE_ALGO, keyName: string, signMessage: Uint8Array, signValue: Uint8Array): boolean;
    verifyWithKey(signAlgo: BS_SAFE_SIGNATURE_ALGO, signKey: Uint8Array, signMessage: Uint8Array, signValue: Uint8Array): boolean;
}
export declare const enum BS_SAFE_SIGNATURE_ALGO {
    BS_SAFE_SIGNATURE_ALGO_SM3_WITH_SM2 = 0,
    BS_SAFE_SIGNATURE_ALGO_HMAC_SM3 = 32,
    BS_SAFE_SIGNATURE_ALGO_HMAC_MD5 = 33,
    BS_SAFE_SIGNATURE_ALGO_HMAC_SHA1 = 34,
    BS_SAFE_SIGNATURE_ALGO_HMAC_SHA256 = 35,
    BS_SAFE_SIGNATURE_ALGO_SM3 = 64,
    BS_SAFE_SIGNATURE_ALGO_MD5 = 65,
    BS_SAFE_SIGNATURE_ALGO_SHA1 = 66,
    BS_SAFE_SIGNATURE_ALGO_SHA256 = 67,
    BS_SAFE_SIGNATURE_ALGO_SG_SM3 = 96,
    BS_SAFE_SIGNATURE_ALGO_SG_MD5 = 97,
    BS_SAFE_SIGNATURE_ALGO_SG_SHA1 = 98,
    BS_SAFE_SIGNATURE_ALGO_SG_SHA256 = 99,
    BS_SAFE_SIGNATURE_ALGO_SG_XIAMI = 100
}
