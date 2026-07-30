// @keepTs
// @ts-nocheck
import { AsyncCallback } from '@kit.BasicServicesKit';
import { DetectResult, IDTXRiskModule, DTXRiskItem } from './IDTXRiskManager';
export declare class DTXRiskManager implements IDTXRiskModule {
    private static instance;
    private static DTX_CONFIG_SG;
    private static DTX_CONFIG_SG_DEFAULT;
    private static DTX_CONFIG_DEVICE;
    private static DTX_CONFIG_DEVICE_DEFAULT;
    private static configSwitch;
    static sysIntegritySpKey: string;
    static deviceAuthenticitySpKey: string;
    static deviceVerifySpKey: string;
    static secureLocationSpKey: string;
    static secureLocationCreateKeySpKey: string;
    static sysIntegrityIntervalTime: number;
    static deviceAuthenticityIntervalTime: number;
    static deviceVerifyIntervalTime: number;
    static secureLocationCreateKeyIntervalTime: number;
    static getInstance(): DTXRiskManager;
    constructor();
    private initRiskControlConfig;
    getRiskResult(b17: DTXRiskItem, c17: AsyncCallback<DetectResult, void>): void;
    getRiskResult(b17: DTXRiskItem): Promise<DetectResult>;
}
