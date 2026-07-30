// @keepTs
// @ts-nocheck
import { MspConfig } from '../data/MspConfig';
import { Context } from "@ohos.abilityAccessCtrl";
export declare class GlobalContext {
    private static instance;
    private constructor();
    static getInstance(): GlobalContext;
    getConfig(): MspConfig;
    getUtdid(v27: Context): string;
}
