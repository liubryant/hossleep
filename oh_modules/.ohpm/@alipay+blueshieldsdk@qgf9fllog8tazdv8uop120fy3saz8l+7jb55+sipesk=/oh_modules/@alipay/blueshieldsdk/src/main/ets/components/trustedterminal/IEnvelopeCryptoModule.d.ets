// @keepTs
// @ts-nocheck
export interface IEnvelopeCryptoModule {
    encrypt(cryptoParams: EnvelopeCryptoParams, plainData: Uint8Array): EnvelopeCryptoResult;
    encrypt(cryptoParams: EnvelopeCryptoParams, plainData: Uint8Array, bizKey: string): EnvelopeCryptoResult;
    decrypt(cryptoParams: EnvelopeCryptoParams, cipherData: Uint8Array): EnvelopeCryptoResult;
    decrypt(cryptoParams: EnvelopeCryptoParams, cipherData: Uint8Array, bizKey: string): EnvelopeCryptoResult;
}
export declare const enum BS_ENVELOPE_CRYPTO_MASTER_ALGO {
    MASTER_ALGORITHM_SM2_PUBLIC_KEY = 0,
    MASTER_ALGORITHM_SM4_ECB_NONE_PADDING = 1
}
export declare const enum BS_ENVELOPE_CRYPTO_SESSION_ALGO {
    SESSION_ALGORITHM_SM4_GCM_NONE_PADDING = 0
}
export declare class EnvelopeCryptoParams {
    masterAlgo: BS_ENVELOPE_CRYPTO_MASTER_ALGO;
    sessionAlgo: BS_ENVELOPE_CRYPTO_SESSION_ALGO;
    masterKey: Uint8Array | null;
    sessionKey: Uint8Array | null;
    sessionIV: Uint8Array | null;
}
export declare class EnvelopeCryptoResult {
    sessionKey: Uint8Array | null;
    sessionIV: Uint8Array | null;
    cryptoData: Uint8Array | null;
    errorCode: number;
}
