// @keepTs
// @ts-nocheck
import { EventEnum } from './EdgeEventConstant';
/**
 * name: EdgeEvent
 * desc: 基础事件
 *
 */
export declare class EdgeEvent {
    private eventEnum;
    private createTime;
    uid: string;
    private extData;
    constructor(z75: EventEnum);
    getName(): string;
    getEventEnum(): EventEnum;
    getCreateTime(): number;
    getExtData(u33: string): string;
    addExtData(s33: string, t33: string): void;
    getTarget(): string;
    isDirtyEvent(): boolean;
    getReportMap(): object;
    getDetectJson(): object;
}
