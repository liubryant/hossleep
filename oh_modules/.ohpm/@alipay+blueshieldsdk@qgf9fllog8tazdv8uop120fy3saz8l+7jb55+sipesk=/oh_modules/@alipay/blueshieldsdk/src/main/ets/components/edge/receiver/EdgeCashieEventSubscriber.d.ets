// @keepTs
// @ts-nocheck
export declare class EdgeCashieEventSubscriber {
    private static mSubscriber;
    private static instance?;
    private isRegister;
    private static event;
    static getInstance(): EdgeCashieEventSubscriber;
    private subscribeInfo;
    private static subscribeCB;
    private createCB;
    register(): void;
}
