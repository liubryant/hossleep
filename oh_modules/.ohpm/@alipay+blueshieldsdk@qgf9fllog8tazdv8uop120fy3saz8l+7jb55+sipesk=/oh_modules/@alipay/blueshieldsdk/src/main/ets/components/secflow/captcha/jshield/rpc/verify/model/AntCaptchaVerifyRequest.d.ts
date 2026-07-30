import { BaseApiRequest } from './BaseApiRequest';
import { QuestionPayload } from './QuestionPayload';
export declare class AntCaptchaVerifyRequest extends BaseApiRequest {
    ua?: string;
    native_ua?: string;
    payload?: QuestionPayload;
    scene?: string;
    buildId?: string;
    encryptedExt?: QuestionPayload;
    extraData?: Record<string, Object>;
    triggerEnv?: string;
}
