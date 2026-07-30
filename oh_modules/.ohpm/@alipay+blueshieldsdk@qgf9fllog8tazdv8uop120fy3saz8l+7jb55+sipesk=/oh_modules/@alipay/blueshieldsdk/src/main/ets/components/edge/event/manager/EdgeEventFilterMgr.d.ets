// @keepTs
// @ts-nocheck
export declare class EdgeEventFilterMgr {
    private static instance;
    isInited: boolean;
    private configVersion;
    private filterEventMap;
    static getInstance(): EdgeEventFilterMgr;
    getConfigVersion(): string;
    getGroupID(p32: string, q32: string): string;
    queryResource(v31: string, w31: string, x31: string | null): string;
    initFilter(): void;
    filter(o31: string, p31: string): boolean;
}
