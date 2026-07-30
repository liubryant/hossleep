// @keepTs
// @ts-nocheck
import { RpcTransportCallback } from '../../../../../tool/rpc/api/RpcTrasportCallback';
import { AntCaptchaValidateResult } from './model/AntCaptchaValidateResult';
import { CaptchaValidateRequest } from './model/CaptchaValidateRequest';
export declare class AntCaptchaNativeValidateService {
    validate(x49: CaptchaValidateRequest, y49: ESObject, z49: RpcTransportCallback<AntCaptchaValidateResult>): number;
}
