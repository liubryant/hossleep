// @keepTs
// @ts-nocheck
export declare class EdgeLoginReceiver {
    private static instance;
    private isRegister;
    private didLoginObserver;
    static getInstance(): EdgeLoginReceiver;
    register(): Promise<void>;
}
