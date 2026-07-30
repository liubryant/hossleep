// @keepTs
// @ts-nocheck
import { CollectBase } from '../CollectBase';
import { CollectArgs } from '../CollectArgs';
declare class Tid extends CollectBase {
    constructor();
    doCollect(z3?: CollectArgs): Promise<string | null>;
}
declare const _default: Tid;
export default _default;
