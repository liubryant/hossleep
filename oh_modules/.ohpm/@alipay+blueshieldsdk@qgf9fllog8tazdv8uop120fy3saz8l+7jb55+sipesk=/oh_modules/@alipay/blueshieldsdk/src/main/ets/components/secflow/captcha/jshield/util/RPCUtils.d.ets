// @keepTs
// @ts-nocheck
import { AntCaptchaVerifyRequest } from '../rpc/verify/model/AntCaptchaVerifyRequest';
import { CaptchaLoadResult } from '../rpc/verify/model/CaptchaLoadResult';
export declare function defaultVerifyRequest(e53: string): Promise<AntCaptchaVerifyRequest>;
export declare function toMapFromCaptchaVerifyRequest(c53: AntCaptchaVerifyRequest): Promise<Map<string, Object>>;
export declare function toMapFromCaptchaLoadResult(a53?: CaptchaLoadResult): Promise<Map<string, string | Map<string, string>>>;
