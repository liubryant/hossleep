// @keepTs
// @ts-nocheck
import { BizContext } from '../context/BizContext';
export declare class DynamicConfig {
    static readonly DYNAMIC_CONFIG = "alipay_cashier_dynamic_config";
    private static instance;
    private constructor();
    static getInstance(): DynamicConfig;
    updateSync(k10: BizContext, l10: number): Promise<void>;
    private parse;
    private initLocalConfig;
}
