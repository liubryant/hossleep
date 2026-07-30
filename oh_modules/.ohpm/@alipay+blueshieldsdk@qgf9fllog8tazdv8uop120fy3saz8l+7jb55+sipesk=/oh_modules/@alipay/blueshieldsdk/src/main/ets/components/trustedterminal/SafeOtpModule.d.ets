// @keepTs
// @ts-nocheck
import { ISafeOtpModule, BS_SAFE_OTP_ALGO } from './ISafeOtpModule';
export declare class SafeOtpModule implements ISafeOtpModule {
    getOtpSHA1(n68: Uint8Array, o68: number, p68: number): string;
    getOtpSM3(h68: string, i68: string, j68: number, k68: number): string;
    getOtpCommon(z67: BS_SAFE_OTP_ALGO, a68: string, b68: string, c68: number, d68: number, e68: number): string;
    verityTrustedEngineOtpSM3(t67: string, u67: string, v67: string, w67: number, x67: number): void;
}
