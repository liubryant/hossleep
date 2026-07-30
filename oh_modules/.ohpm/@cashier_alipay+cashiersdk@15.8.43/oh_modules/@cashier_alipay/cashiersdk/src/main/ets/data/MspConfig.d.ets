// @keepTs
// @ts-nocheck
import { BizContext } from '../context/BizContext';
import { TidStorage } from '../tid/TidStorage';
import { Context } from "@ohos.abilityAccessCtrl";
export declare class MspConfig {
    static SHARE_PREFERENCE_NAME: string;
    static PREFERENCE_VIRTUAL_IMSI: string;
    static PREFERENCE_VIRTUAL_IMEI: string;
    mUserAgent: string | undefined;
    mKernelVersion: string | undefined;
    mClientKey: string | undefined;
    static instance: MspConfig;
    private constructor();
    static getInstance(): MspConfig;
    getUserAgent(p13: BizContext, q13: TidStorage, r13: boolean): string;
    static getPa(l13: Context): string;
    private getNetworkTypeSync;
    getVirtualImsi(d13: BizContext): string;
    getVirtualImei(z12: BizContext): string;
    static setRsaPublicKey(y12: string): void;
}
