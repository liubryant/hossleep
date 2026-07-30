// @keepTs
// @ts-nocheck
import { ITrustedEngine, ITrustedEngineModule } from './ITrustedEngineModule';
export declare class TrustedEngineModule implements ITrustedEngineModule {
    defaultHeap: number;
    defaultStack: number;
    code: number;
    private init;
    constructor();
    createInstance(c75: Context, d75: string): ITrustedEngine | null;
    createInstance(c75: Context, d75: string, e75: number, f75: number): ITrustedEngine | null;
    destoryInstance(v74: ITrustedEngine): boolean;
    private doCreateInstance;
    private doDestoryInstance;
}
