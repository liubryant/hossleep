// @keepTs
// @ts-nocheck
export declare class ApdIdManager {
    private static instance;
    private constructor();
    static getInstance(): ApdIdManager;
    private apdIdModule;
    private apdIdToken;
    init(g22: Context): Promise<string>;
    private initToken;
    getToken(): string;
}
