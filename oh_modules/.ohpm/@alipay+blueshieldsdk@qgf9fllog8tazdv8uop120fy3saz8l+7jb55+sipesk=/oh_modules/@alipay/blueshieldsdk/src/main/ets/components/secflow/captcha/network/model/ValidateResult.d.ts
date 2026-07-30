import { CommonResult } from './CommonResult';
export declare class ValidateResult extends CommonResult {
    validateStatus?: string;
    x5SecCookie?: string;
    x5SecCookieKey?: string;
    maxAge?: number;
    extra?: Record<string, Object>;
}
