// @keepTs
// @ts-nocheck
import { CollectBase } from '../CollectBase';
declare class MacAddress extends CollectBase {
    constructor();
    doCollect(): Promise<string>;
}
declare const _default: MacAddress;
export default _default;
