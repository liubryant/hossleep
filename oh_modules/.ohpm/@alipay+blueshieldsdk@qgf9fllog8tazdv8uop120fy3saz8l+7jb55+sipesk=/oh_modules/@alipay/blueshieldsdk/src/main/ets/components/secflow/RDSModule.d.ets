// @keepTs
// @ts-nocheck
import { IRDSEngine, IRDSModule, RDSEvent } from './IRDSModule';
import { AsyncCallback } from '@ohos.base';
export declare class RDSModule implements IRDSModule {
    startEngine(m63: string, n63: Map<string, string>): IRDSEngine;
    executeEngine(k63: IRDSEngine): string;
    executeEngineAsync(e63: IRDSEngine, c63: AsyncCallback<string, void>): void;
    executeEngineAsync(e63: IRDSEngine): Promise<string>;
    stopEngine(z62: IRDSEngine): boolean;
}
export declare class RDSEngine implements IRDSEngine {
    private mInstance;
    private mState;
    constructor(x62: string, y62: string);
    onExecuteAsync(): Promise<string>;
    onExecute(): string;
    onDestory(): boolean;
    onPage(u62: string): void;
    onControlClick(t62: string): void;
    onKeyDown(r62: string, s62: string): void;
    onGetFocus(q62: string): void;
    onLostFocus(p62: string): void;
    onTouchScreen(n62: string, o62: TouchEvent): void;
    onPageEnd(m62: string): void;
    onEvent(e62: RDSEvent, f62?: string, g62?: Object): void;
}
