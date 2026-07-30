// @keepTs
// @ts-nocheck
import { CaptchaVerifyCallback } from '../ICaptchaVerifyModule';
import { RpcTransportCallback } from '../../../tool/rpc/api/RpcTrasportCallback';
import { AntCaptchaValidateResult } from './rpc/validate/model/AntCaptchaValidateResult';
interface ValidateParam {
    bizNo: string;
    captchaId: string;
    token: string;
    extraData: Map<string, string>;
}
export declare class JShieldCaptchaDisposeUtils {
    static setCookieAndNotify(s48?: string, t48?: string, u48?: string): Promise<void>;
    static validate(o48: ValidateParam, p48: RpcTransportCallback<AntCaptchaValidateResult>): Promise<void>;
    static showCaptchaDialog(s47: string, t47: Map<string, string>, u47?: CaptchaVerifyCallback): Promise<void>;
}
export {};
