// @keepTs
// @ts-nocheck
export declare class Result {
    static getParamsError(): Map<string, string>;
    static getCancel(): Map<string, string>;
    static getDoubleRequest(): Map<string, string>;
    static parseResult(q5: ResultStatus, r5?: string): Map<string, string>;
    static parseResultV1(n5: number | string, o5: string, p5: string): Map<string, string>;
}
export declare class ResultStatus {
    static SUCCEEDED: ResultStatus;
    static FAILED: ResultStatus;
    static CANCELED: ResultStatus;
    static NETWORK_ERROR: ResultStatus;
    static ACTIVITY_NOT_START_EXIT: ResultStatus;
    static PARAMS_ERROR: ResultStatus;
    static DOUBLE_REQUEST: ResultStatus;
    static ALIPAY_NOT_INSTALLED: ResultStatus;
    static INVOKE_ALIPAY_FAIL: ResultStatus;
    static PAY_WAITTING: ResultStatus;
    status: number;
    memo: string;
    constructor(l5: number, m5: string);
    toString(): string;
    static getResultStatus(k5: number): ResultStatus;
}
