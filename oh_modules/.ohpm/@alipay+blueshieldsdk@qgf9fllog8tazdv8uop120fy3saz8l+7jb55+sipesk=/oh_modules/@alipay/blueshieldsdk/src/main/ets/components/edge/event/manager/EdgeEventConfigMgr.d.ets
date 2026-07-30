// @keepTs
// @ts-nocheck
export declare class EdgeEventConfigMgr {
    private static instance;
    private monitorSample;
    private static detectMain;
    private static detectFilter;
    private static detectNative;
    private static detectSample;
    private static detectCloseList;
    private static controlOpen;
    private static controlFilter;
    private static controlSample;
    private static controlEventList;
    private static controlDialogList;
    private static controlTargetList;
    private static controlNative;
    static EDGE_LOGIN_RECEIVER_SWITCH: string;
    static EDGE_FRAUD_SCREEN_CAPTURE_CONFIG: string;
    static EDGE_FRAUD_PAY_EVENT_SWITCH: string;
    static EDGE_FRAUD_BROADCAST_NETWORK_STATE_SWITCH: string;
    static EDGE_FRAUD_AIR_PLANE_SWITCH_ON: string;
    static EDGE_FRAUD_EVENT_DETECT_SWITCH: string;
    static EDGE_LOGIN_RECEIVER_SWITCH_DEFAULT: string;
    static EDGE_FRAUD_SCREEN_CAPTURE_CONFIG_DEFAULT: string;
    static EDGE_FRAUD_PAY_EVENT_SWITCH_DEFAULT: string;
    static EDGE_FRAUD_BROADCAST_NETWORK_STATE_SWITCH_DEFAULT: string;
    static EDGE_FRAUD_AIR_PLANE_SWITCH_ON_DEFAULT: string;
    static EDGE_FRAUD_EVENT_DETECT_SWITCH_DEFAULT: string;
    static getInstance(): EdgeEventConfigMgr;
    initConfig(): void;
    static detectIsOpenByType(m30: number): boolean;
    static detectFilterOn(): boolean;
    static controlFilterOn(): boolean;
    static detectNativeCfg(): string;
    static detectTimeout(): number;
}
