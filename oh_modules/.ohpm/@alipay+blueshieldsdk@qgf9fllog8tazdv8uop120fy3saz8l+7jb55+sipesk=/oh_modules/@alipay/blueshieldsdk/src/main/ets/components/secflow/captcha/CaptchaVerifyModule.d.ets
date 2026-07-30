// @keepTs
// @ts-nocheck
import { CaptchaVerifyCallback, ICaptchaVerifyModule } from './ICaptchaVerifyModule';
export declare class CaptchaVerifyModule implements ICaptchaVerifyModule {
    getRiskData(a40: string, b40?: Map<string, string> | undefined): Promise<string | undefined>;
    onCaptchaVerify(l38: Map<string, string>, m38: CaptchaVerifyCallback | null): void;
}
