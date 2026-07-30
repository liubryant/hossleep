// @keepTs
// @ts-nocheck
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
export declare class CertChain {
    private certs;
    private beginString;
    private pemRootCert;
    constructor(f13: string);
    private getEncodingCertChain;
    validate(): Promise<void>;
    getPubKey(): Promise<cryptoFramework.PubKey>;
}
