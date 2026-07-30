// @keepTs
// @ts-nocheck
import cryptoCert from '@ohos.security.cert';
import cryptoFramework from '@ohos.security.cryptoFramework';
export declare function eccVerify(i15: Uint8Array, j15: Uint8Array, k15: cryptoFramework.DataBlob): Promise<boolean>;
export declare function strToCertChain(d15: string): Promise<cryptoCert.X509Cert[]>;
export declare function certChainThreeValidator(k14: string[]): Promise<number>;
export declare function sysIntegrityJWSVerify(v13: string[], w13: string[]): Promise<number>;
