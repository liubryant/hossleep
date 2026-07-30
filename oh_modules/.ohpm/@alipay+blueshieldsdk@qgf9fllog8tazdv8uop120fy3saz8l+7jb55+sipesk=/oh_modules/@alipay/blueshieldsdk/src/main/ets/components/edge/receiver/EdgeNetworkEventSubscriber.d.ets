// @keepTs
// @ts-nocheck
export declare class EdgeNetworkEventSubscriber {
    private static mSubscriber;
    private static instance?;
    private isRegister;
    private static state;
    private static lastTime;
    private static event;
    static getInstance(): EdgeNetworkEventSubscriber;
    private subscribeInfo;
    private static subscribeCB;
    private createCB;
    register(): void;
}
