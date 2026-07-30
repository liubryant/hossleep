// @keepTs
// @ts-nocheck
export declare class EdgeAirplaneEventSubscriber {
    private static mSubscriber;
    private static instance?;
    private isRegister;
    private static event;
    static getInstance(): EdgeAirplaneEventSubscriber;
    private subscribeInfo;
    private static subscribeCB;
    private createCB;
    register(): void;
}
