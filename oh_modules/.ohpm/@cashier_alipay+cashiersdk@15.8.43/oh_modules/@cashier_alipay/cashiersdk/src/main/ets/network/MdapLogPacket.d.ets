// @keepTs
// @ts-nocheck
import { BizContext } from '../context/BizContext';
import { JSONObject } from '../utils/Utils';
import { Letter } from './model/Letter';
import { NetworkTask } from './NetworkTask';
export declare class MdapLogPacket extends NetworkTask {
    buildHeaders(k17: boolean, l17: string): Map<string, string>;
    buildAction(): JSONObject;
    isWifiMocked(): boolean;
    getName(): string;
    buildBody(h17: BizContext, i17: string, j17: JSONObject): string;
    request(p16: BizContext, q16: string): Promise<Letter | null>;
}
