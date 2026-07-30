// @keepTs
// @ts-nocheck
import { ArrayList } from '@kit.ArkTS';
export declare class Message {
    callbackId: string;
    responseId: string;
    responseData: string;
    data: string;
    handlerName: string | null;
    static toArrayList(s55: string): ArrayList<Message>;
}
