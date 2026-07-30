// @keepTs
// @ts-nocheck
export interface ISafeOtpModule {
    getOtpSHA1(secret: Uint8Array, movingFactor: number, codeDigits: number): string;
    getOtpSM3(seed: string, question: string, movingFactor: number, codeDigits: number): string;
    getOtpCommon(algo: BS_SAFE_OTP_ALGO, seed: string, challenge: string, timestamp: number, interval: number, digits: number): string;
}
export declare const enum BS_SAFE_OTP_ALGO {
    BS_SAFE_OTP_ALGO_HMAC_SM3 = 0,
    BS_SAFE_OTP_ALGO_HMAC_SHA256 = 1
}
