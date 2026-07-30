// @keepTs
// @ts-nocheck
import { EdgeRiskResult, EdgeRiskUAMode, IEdgeRiskModule } from './IEdgeRiskModule';
import { EdgeEvent } from './event/model/EdgeEvent';
export declare class EdgeRiskModule implements IEdgeRiskModule {
    initialize(): Promise<number>;
    postUserAction(l29: EdgeRiskUAMode, m29: Map<string, string>): number;
    getRiskResult(b29: EdgeRiskUAMode, c29: Map<string, string>, d29: number): EdgeRiskResult;
    postAsyncEvent(a29: EdgeEvent): void;
    postSyncEvent(): Promise<void>;
    postSyncAndAsyncEvent(): boolean;
}
