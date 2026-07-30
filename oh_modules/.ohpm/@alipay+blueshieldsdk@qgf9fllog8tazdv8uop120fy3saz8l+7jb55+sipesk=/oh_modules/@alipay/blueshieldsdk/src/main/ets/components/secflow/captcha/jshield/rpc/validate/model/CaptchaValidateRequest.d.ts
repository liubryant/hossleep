import { QuestionPayload } from './QuestionPayload';
import { CaptchaVerifyRequest } from './CaptchaVerifyRequest';
import { BaseCaptchaRequest } from './BaseCaptchaRequest';
export declare class CaptchaValidateRequest extends BaseCaptchaRequest {
    token?: string;
    scene?: string;
    extraData?: Record<string, Object>;
    degrade?: boolean;
    oriRequestToken?: string;
    oriRequestTokenEmpty?: boolean;
    encryptedExt?: QuestionPayload;
    consultData?: CaptchaVerifyRequest;
    signFormat?: string;
}
