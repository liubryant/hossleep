// @keepTs
// @ts-nocheck
import { CollectBase } from '../CollectBase';
import { CollectArgs } from '../CollectArgs';
declare class Utdid extends CollectBase {
    constructor();
    doCollect(b4?: CollectArgs): Promise<string | null>;
}
declare const _default: Utdid;
export default _default;
