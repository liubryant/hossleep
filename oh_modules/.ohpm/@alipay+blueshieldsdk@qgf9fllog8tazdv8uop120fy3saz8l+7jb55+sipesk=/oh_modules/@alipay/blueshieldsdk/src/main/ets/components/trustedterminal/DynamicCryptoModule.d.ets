// @keepTs
// @ts-nocheck
import { IDynamicCryptoModule } from './IDynamicCryptoModule';
export declare class DynamicCryptoModule implements IDynamicCryptoModule {
    encrypt(y65: Uint8Array): Uint8Array;
    encryptStringBase64(v65: string): string;
    decrypt(s65: Uint8Array): Uint8Array;
    decryptStringBase64(o65: string): string;
}
