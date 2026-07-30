// @keepTs
// @ts-nocheck
import { AsyncCallback } from '@ohos.base';
export declare enum DTXRiskItem {
    DTX_RISK_SG = 1,
    DTX_RISK_CERT_VERIFY = 2,
    DTX_RISK_SYS_INTEGRITY = 3,
    DTX_RISK_SECURE_LOCATION = 4
}
export declare class DetectResult {
    rawData: string;
    riskData: string;
    error_code: string;
    error_msg: string;
    cost: string;
}
export declare function getItemName(r17: DTXRiskItem): string;
/**
 * DTX风险检测接口
 */
export interface IDTXRiskModule {
    /**
     * DTX风险检测接口异步初始化回调接口
     *
     */
    getRiskResult(item: DTXRiskItem, listener: AsyncCallback<DetectResult>): void;
    /**
     * DTX风险检测Promise接口
     */
    getRiskResult(item: DTXRiskItem): Promise<DetectResult>;
}
