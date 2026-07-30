// @keepTs
// @ts-nocheck
import { BizContext } from '../context/BizContext';
export declare class StatisticManager {
    private constructor();
    static stash(d25: BizContext | undefined, e25: string, f25: string): void;
    static submit(a25: BizContext | undefined, b25: string, c25: string): void;
    static forceUploadExisting(z24: BizContext | undefined): void;
    static putError(v24: BizContext | undefined, w24: string, x24: string, y24: Error | undefined): void;
    static putErrorWithRes(q24: BizContext | undefined, r24: string, s24: string, t24: Error | undefined, u24: string): void;
    static putAction(m24: BizContext | undefined, n24: string, o24: string, p24?: string | undefined): void;
    static localSequence(): number;
    static requestSequence(): number;
}
