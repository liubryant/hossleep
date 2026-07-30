// @keepTs
// @ts-nocheck
import { EdgeEvent } from '../model/EdgeEvent';
export declare class EdgeEventFeatureMgr {
    private static instance;
    constructor();
    static getInstance(): EdgeEventFeatureMgr;
    detectEvent(c31: EdgeEvent): void;
}
