// @keepTs
// @ts-nocheck
export declare class MdapService {
    static uploadEvent(r10: string, s10: string, t10: Record<string, string>): number;
    static uploadCaptchaEvent(l10: string | undefined, m10: string | undefined, n10: string | number, o10: number, p10?: string): void;
    static onOneKeyStopResult(h10: string, i10: string, j10: string): void;
    static dtxSendEvent(z9: string, a10: string, b10: string, c10: string, d10: string, e10?: string): Promise<void>;
    static stxSendEvent(u9: string, v9: string, w9: string): Promise<void>;
    static bsSendEvent(p9: string, q9: string, r9: string): void;
    static trustEngineEvent(j9: string, k9: string, l9: string, m9: string, n9: string): void;
    static dynamic4Event(c9: string, d9: string, e9: string | null, f9: number, g9: Record<string, string> | null): void;
}
export declare enum MDAP_EVENT_ID {
    MDAP_EVENT_INFOSEC_DETECT = "10091",
    MDAP_EVENT_INFOSEC_COVERAGE = "10097",
    MDAP_EVENT_INFOSEC_DP = "100910",
    MDAP_EVENT_FRAUD_SCAN = "10096",
    MDAP_EVENT_FRAUD_CARD = "10099",
    MDAP_EVENT_TADS_REPORT = "100911",
    MDAP_EVENT_TADS_RESULT = "100912",
    MDAP_EVENT_TADS_CONTROL = "100913",
    MDAP_EVENT_TADS_ACTION = "100914",
    MDAP_EVENT_DTX = "10101369",
    MDAP_EVENT_CAPTCHA = "103655",
    MDAP_EVENT_ONE_KEY_STOP = "1020459",
    MDAP_EVENT_STX = "103657",
    MDAP_EVENT_BS = "103664",
    MDAP_TRUST_ENGINE = "103669",
    MADP_DYNAMIC4 = "103680"
}
export declare enum MDAP_BIZ_TYPE {
    MDAP_BIZ_APSECURITY = "apsecurity",
    MDAP_BIZ_INFOSEC = "infosec",
    MDAP_BIZ_DTX = "dtxservice"
}
