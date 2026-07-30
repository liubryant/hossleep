import { InteractionTheme } from './InteractionTheme';
import { BaseCaptchaResult } from './BaseCaptchaResult';
export declare class CaptchaLoadResult extends BaseCaptchaResult {
    verifyMode?: string;
    interaction?: string;
    lang?: string;
    interactionTheme?: InteractionTheme;
    tips?: string;
    payload?: string;
    payloadProtocol?: string;
    trace?: string;
}
