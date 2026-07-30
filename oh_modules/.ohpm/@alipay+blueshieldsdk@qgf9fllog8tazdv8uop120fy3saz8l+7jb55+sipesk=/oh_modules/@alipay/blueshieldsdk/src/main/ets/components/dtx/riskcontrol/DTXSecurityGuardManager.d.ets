// @keepTs
// @ts-nocheck
export declare class DTXSecurityGuardManager {
    private static TAG;
    private static sourceId;
    private static configKey;
    private static sgConfig;
    constructor();
    initRiskControlConfig(): Promise<void>;
    getSGPayloadInfo(): Promise<string>;
    getPrivacyLeakBehaviorRisk(): Promise<any>;
    getScreenSpyingBehaviorRisk(): void;
    getHijackBehaviorRisk(): any;
    getContactBehaviorRisk(): any;
}
