// @keepTs
// @ts-nocheck
import { CollectArgs } from './CollectArgs';
/**
 * 因子采集基类
 */
export declare abstract class CollectBase {
    name: string;
    timeout: number;
    constructor();
    promiseWithTimeout<t3>(u3: Promise<t3>, v3: number): Promise<t3>;
    getCollectName(): string;
    getResult(e3: CollectArgs): Promise<Record<string, string>>;
    abstract doCollect(d3?: CollectArgs): Promise<string | number | null> | string | null | number;
}
