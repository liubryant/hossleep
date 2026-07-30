// @keepTs
// @ts-nocheck
import { EdgeEvent } from './model/EdgeEvent';
export declare class EdgeEventManager {
    private static instance;
    private static configMgr;
    private static FilterMgr;
    private static StateMgr;
    static isInit: boolean;
    static isWarmLifeInit: boolean;
    didLoginObserver: null;
    static getInstance(): EdgeEventManager;
    constructor();
    init(): Promise<void>;
    static postAsyncEventNative(c30: string): Promise<string | null>;
    static postAsyncEvent(a30: EdgeEvent): Promise<void>;
    postSyncEvent(): Promise<void>;
    postSyncAndAsyncEvent(): boolean;
}
