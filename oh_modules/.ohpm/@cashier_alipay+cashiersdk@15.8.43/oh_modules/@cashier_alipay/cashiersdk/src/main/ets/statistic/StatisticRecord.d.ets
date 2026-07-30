// @keepTs
// @ts-nocheck
import { BizContext } from '../context/BizContext';
export declare class StatisticRecord {
    static readonly ET_NET = "net";
    static readonly ET_BIZ = "biz";
    static readonly KEY_TRADE_PARTNER = "partner";
    static readonly KEY_TRADE_OUT_TRADE_NO = "out_trade_no";
    static readonly KEY_TRADE_NO = "trade_no";
    static readonly KEY_BIZ_CONTENT = "biz_content";
    static readonly KEY_APP_ID = "app_id";
    private mTime;
    private mTrade;
    private mApp;
    private mSDK;
    private mIds;
    private mDevice;
    private mResult;
    private mBehavior;
    private mException;
    private mTemplate;
    private mBizContext;
    constructor(t27: BizContext, u27: boolean);
    putError(p27: string, q27: string, r27: Error | undefined): void;
    putErrorWithRes(k27: string, l27: string, m27: Error | undefined, n27: string): void;
    putErrorInner(g27: string, h27: string, i27: string): void;
    putErrorWithMsg(d27: string, e27: string, f27: string): void;
    putActionWithDetail(a27: string, b27: string, c27: string): void;
    putAction(y26: string, z26: string): void;
    putActionInner(u26: string, v26: string, w26: string): void;
    genEventTime(): string;
    private formatDateTime;
    private filter;
    private filterField;
    private getStackTraceMessage;
    format(l26: string): string;
    private buildTime;
    private randomUuid;
    private buildTrade;
    private buildApp;
    private buildSDK;
    private buildIds;
    private buildDevice;
}
