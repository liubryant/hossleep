import { QuestionPayload } from './QuestionPayload';
import { BaseCaptchaRequest } from './BaseCaptchaRequest';
export declare class CaptchaVerifyRequest extends BaseCaptchaRequest {
    ua?: string;
    native_ua?: string;
    payload?: QuestionPayload;
    scene?: string;
    buildId?: string;
    encryptedExt?: QuestionPayload;
    extraData?: Record<string, Object>;
    originSignString?: string;
    apiVersion?: string;
    signFormat?: string;
}
