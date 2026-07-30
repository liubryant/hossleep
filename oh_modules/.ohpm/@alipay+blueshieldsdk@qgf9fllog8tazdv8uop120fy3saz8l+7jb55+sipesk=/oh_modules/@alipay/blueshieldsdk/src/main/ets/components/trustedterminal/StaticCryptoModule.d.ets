// @keepTs
// @ts-nocheck
import { IStaticCryptoModule, BS_STAIC_CRYPTO_MODE } from './IStaticCryptoModule';
export declare class StaticCryptoModule implements IStaticCryptoModule {
    encrypt(t72: BS_STAIC_CRYPTO_MODE, u72: string, v72: Uint8Array, w72?: string): Uint8Array;
    decrypt(p72: BS_STAIC_CRYPTO_MODE, q72: string, r72: Uint8Array, s72?: string): Uint8Array;
    encryptBase64(l72: BS_STAIC_CRYPTO_MODE, m72: string, n72: Uint8Array, o72?: string): Uint8Array;
    decryptBase64(h72: BS_STAIC_CRYPTO_MODE, i72: string, j72: Uint8Array, k72?: string): Uint8Array;
    encryptStringBase64(a72: BS_STAIC_CRYPTO_MODE, b72: string, c72: string, d72?: string): string;
    decryptStringBase64(t71: BS_STAIC_CRYPTO_MODE, u71: string, v71: string, w71?: string): string;
    private doEncrypt;
    private doDecrypt;
}
