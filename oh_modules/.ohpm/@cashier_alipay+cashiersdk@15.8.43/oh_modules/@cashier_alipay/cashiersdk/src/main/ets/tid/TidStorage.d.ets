// @keepTs
// @ts-nocheck
import { BizContext } from '../context/BizContext';
export declare class TidStorage {
    static PREF_TID_FILE: string;
    static PREF_TID_INFO: string;
    static KEY_TID: string;
    static KEY_CLIENTKEY: string;
    static KEY_TIMESTAMP: string;
    static KEY_VIMEI: string;
    static KEY_VIMSI: string;
    private static instance;
    private mTid;
    private mClientKey;
    private mTimestamp;
    private mVimei;
    private mVimsi;
    private isInit;
    private constructor();
    load(t28: BizContext): void;
    private isIllegal;
    private resetTid;
    private genClientKey;
    static genVirtualCode(): string;
    static getInstance(h28?: BizContext | undefined): TidStorage;
    setTid(g28: string): void;
    getTid(): string;
    save(d28: BizContext, e28: string, f28: string): void;
    saveToLocal(y27: BizContext): void;
    generateDesKey(w27: BizContext): string;
    getClientKey(): string;
}
