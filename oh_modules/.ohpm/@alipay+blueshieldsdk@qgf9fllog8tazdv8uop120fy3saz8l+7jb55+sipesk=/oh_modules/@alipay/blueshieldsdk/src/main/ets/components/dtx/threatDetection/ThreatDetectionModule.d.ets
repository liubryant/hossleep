// @keepTs
// @ts-nocheck
export declare class ThreatDetectionModule {
    private static readonly TAG;
    private static sourceId;
    private static configKey;
    private static sysIntegrityConfig;
    private static deviceAuthenticityConfig;
    private static deviceVerifyConfig;
    private static secureLocationConfig;
    private static sysIntegrityIntervalTime;
    private static deviceAuthenticityIntervalTime;
    private static deviceVerifyIntervalTime;
    private static secureLocationIntervalTime;
    static sysIntegritySpKey: string;
    static deviceAuthenticitySpKey: string;
    static deviceVerifySpKey: string;
    static secureLocationSpKey: string;
    constructor();
    initThreatDetectionModuleConfig(): Promise<void>;
    dtxSysIntegrityCheck(o27?: boolean): Promise<string>;
    dtxDeviceAuthenticityCheck(d27?: boolean): Promise<string>;
    dtxDeviceVerify(): Promise<string>;
    dtxCurrentSecureLocationGet(l26?: boolean, m26?: number, n26?: boolean): Promise<string>;
}
