// @keepTs
// @ts-nocheck
import { Page, State } from '../model/EdgeEState';
import { EdgeEvent } from '../model/EdgeEvent';
export declare class EdgeEventCurrStateMgr {
    private static instance;
    private currEventState;
    constructor();
    static getInstance(): EdgeEventCurrStateMgr;
    addEventExtData(t30: EdgeEvent): void;
    updateState(r30: EdgeEvent): boolean;
    updateSubState(p30: State): boolean;
    getCurrPage(): Page;
}
