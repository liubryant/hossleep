// @keepTs
// @ts-nocheck
export declare enum DYNAMIC4_ERROR_CODE {
    SUCCESS = 0,
    SET_DEGRADE = 7101,
    UNKNOWN_EXCEPTION = 7202
}
export declare class Dynamic4ResourceManager {
    static MODULE_NAME: string;
    private static instance;
    private static DYNAMIC4_EMERGENCY_DETECTING_CONTROLLER_SWITCH;
    private static DEF_CONFIG;
    private constructor();
    static getInstance(): Dynamic4ResourceManager;
    InitDynamicResourceManager(): number;
    static addCrashHeaderKv(q28: string): Promise<null>;
    static addCrashHeader(l28: string, m28: string): void;
    private isOpen;
}
