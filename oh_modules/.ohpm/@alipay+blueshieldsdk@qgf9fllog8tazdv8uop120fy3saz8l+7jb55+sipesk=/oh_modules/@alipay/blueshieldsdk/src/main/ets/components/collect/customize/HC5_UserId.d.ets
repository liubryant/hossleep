// @keepTs
// @ts-nocheck
import { CollectBase } from '../CollectBase';
import { CollectArgs } from '../CollectArgs';
declare class UserId extends CollectBase {
    constructor();
    doCollect(w4?: CollectArgs): Promise<string | null>;
}
declare const _default: UserId;
export default _default;
