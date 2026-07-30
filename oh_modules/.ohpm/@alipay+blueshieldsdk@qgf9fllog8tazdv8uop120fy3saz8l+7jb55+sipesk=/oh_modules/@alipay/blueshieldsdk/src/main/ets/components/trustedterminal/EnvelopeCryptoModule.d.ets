// @keepTs
// @ts-nocheck
import { EnvelopeCryptoParams, EnvelopeCryptoResult, IEnvelopeCryptoModule } from './IEnvelopeCryptoModule';
export declare class EnvelopeCryptoModule implements IEnvelopeCryptoModule {
    encrypt(q67: EnvelopeCryptoParams, r67: Uint8Array): EnvelopeCryptoResult;
    encrypt(q67: EnvelopeCryptoParams, r67: Uint8Array, s67: string): EnvelopeCryptoResult;
    decrypt(i67: EnvelopeCryptoParams, j67: Uint8Array): EnvelopeCryptoResult;
    decrypt(i67: EnvelopeCryptoParams, j67: Uint8Array, k67: string): EnvelopeCryptoResult;
    private doEncrypt;
    private doDecrypt;
}
