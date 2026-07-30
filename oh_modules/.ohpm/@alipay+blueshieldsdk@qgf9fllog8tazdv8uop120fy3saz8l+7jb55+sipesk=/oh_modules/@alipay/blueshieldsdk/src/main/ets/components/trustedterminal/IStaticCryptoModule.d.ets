// @keepTs
// @ts-nocheck
export interface IStaticCryptoModule {
    encrypt(mode: BS_STAIC_CRYPTO_MODE, key: string, input: Uint8Array, authCode?: string): Uint8Array;
    decrypt(mode: BS_STAIC_CRYPTO_MODE, key: string, input: Uint8Array, authCode?: string): Uint8Array;
    encryptBase64(mode: BS_STAIC_CRYPTO_MODE, key: string, input: Uint8Array, authCode?: string): Uint8Array;
    decryptBase64(mode: BS_STAIC_CRYPTO_MODE, key: string, input: Uint8Array, authCode?: string): Uint8Array;
    encryptStringBase64(mode: BS_STAIC_CRYPTO_MODE, key: string, input: string, authCode?: string): string;
    decryptStringBase64(mode: BS_STAIC_CRYPTO_MODE, key: string, input: string, authCode?: string): string;
}
export declare const enum BS_STAIC_CRYPTO_MODE {
    BS_STATIC_CRYPTO_MODE_SG_AES_128 = 16,
    BS_STATIC_CRYPTO_MODE_BS_SM4_GCM = 32,
    BS_STATIC_CRYPTO_MODE_BS_AES_128 = 33
}
