// @keepTs
// @ts-nocheck
export interface ITrustedEngine {
    getReturnTypeBool(): string;
    getReturnTypeIntergerNumber(): string;
    getReturnTypeDoubleNumber(): string;
    getReturnTypeString(): string;
    getReturnTypeUint8Array(): string;
    invoke(funcName: string, returnType: string, ...args: Object[]): Object;
    getInstanceName(): string;
    isRelease(): boolean;
}
export interface ITrustedEngineModule {
    createInstance(ctx: Context, picName: string): ITrustedEngine | null;
    createInstance(ctx: Context, picName: string, heapSize: number, stackSize: number): ITrustedEngine | null;
    destoryInstance(instance: ITrustedEngine): boolean;
}
