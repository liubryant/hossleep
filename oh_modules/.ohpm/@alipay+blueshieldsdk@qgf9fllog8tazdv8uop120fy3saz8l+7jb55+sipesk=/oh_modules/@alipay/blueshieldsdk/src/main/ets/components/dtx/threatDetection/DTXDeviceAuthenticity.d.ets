// @keepTs
// @ts-nocheck
export declare class DTXDeviceAuthenticity {
    private static TAG;
    private static challenge;
    private static handle;
    static signature: Uint8Array;
    private static GetEccGenerateProperties;
    private static GetAnonAttestProperties;
    private static GetEccSignProperties;
    private static GetEccVerifyProperties;
    static generateKey(z24: string): Promise<void>;
    static anonAttestOptions(u24: string): Promise<string>;
    static Sign(n24: string, o24: string): Promise<void>;
    static Verify(d24: string, e24: string, f24: Uint8Array): Promise<void>;
    static DeleteEccKey(z23: string): Promise<void>;
    static huksAbort(): void;
    static localVerifyAnonCertChain(r23: string): Promise<number>;
}
