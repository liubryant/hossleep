// @keepTs
// @ts-nocheck
import { AntCaptchaVerifyRequest } from './model/AntCaptchaVerifyRequest';
import { AntCaptchaVerifyResult } from './model/AntCaptchaVerifyResult';
import { RpcTransportCallback } from '../../../../../tool/rpc/api/RpcTrasportCallback';
export declare class AntCaptchaNativeVerifyService {
    verify(n50: AntCaptchaVerifyRequest, o50: ESObject, p50: RpcTransportCallback<AntCaptchaVerifyResult>): number;
}
