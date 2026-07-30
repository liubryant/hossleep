// @keepTs
// @ts-nocheck
import { ITrustedEngine } from './ITrustedEngineModule';
export declare class TrustedEngine implements ITrustedEngine {
    vmName: string;
    released: boolean;
    constructor(h74: string);
    getInstanceName(): string;
    isRelease(): boolean;
    getReturnTypeBool(): string;
    getReturnTypeIntergerNumber(): string;
    getReturnTypeDoubleNumber(): string;
    getReturnTypeString(): string;
    getReturnTypeUint8Array(): string;
    release(): void;
    getSteeName(): string;
    invoke(c74: string, d74: string, ...e74: Object[]): Object;
}
