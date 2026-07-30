// @keepTs
// @ts-nocheck
export interface IDynamicCryptoModule {
    encrypt(plainData: Uint8Array): Uint8Array;
    encryptStringBase64(plainData: string): string;
    decrypt(cipherData: Uint8Array): Uint8Array;
    decryptStringBase64(cipherData: string): string;
}
