// @keepTs
// @ts-nocheck
import { JSONObject } from '../../utils/Utils';
export declare class Letter {
    private envelop;
    private body;
    constructor(o17: string, p17: string);
    getEnvelop(): string;
    getBody(): string;
    getTemplate(): JSONObject;
}
