// @keepTs
// @ts-nocheck
import { CollectBase } from '../CollectBase';
declare class RandomStr extends CollectBase {
    private randomStr;
    private readonly prefsKey;
    constructor();
    private static stringToArray;
    private static arrayToString;
    doCollect(): Promise<string | null>;
}
declare const _default: RandomStr;
export default _default;
