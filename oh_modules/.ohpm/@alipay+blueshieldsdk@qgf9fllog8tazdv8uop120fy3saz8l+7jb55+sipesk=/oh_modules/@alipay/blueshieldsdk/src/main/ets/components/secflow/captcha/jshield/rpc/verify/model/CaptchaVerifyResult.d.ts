import { CaptchaLoadResult } from './CaptchaLoadResult';
import { BaseCaptchaResult } from './BaseCaptchaResult';
export declare class CaptchaVerifyResult extends BaseCaptchaResult {
    token?: string;
    result?: string;
    captchaConfig?: CaptchaLoadResult;
    extraData?: Record<string, Object>;
}
