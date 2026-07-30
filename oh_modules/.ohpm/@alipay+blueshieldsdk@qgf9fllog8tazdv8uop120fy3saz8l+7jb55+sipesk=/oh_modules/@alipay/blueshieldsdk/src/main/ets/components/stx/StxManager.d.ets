// @keepTs
// @ts-nocheck
export declare class StxManager {
    private static instance;
    private initStatus;
    private constructor();
    static getInstance(): StxManager;
    getModule(a64: StxModuleType): Object | null;
}
export declare const enum StxModuleType {
    STX_CIRCULATE_MODULE = 0
}
