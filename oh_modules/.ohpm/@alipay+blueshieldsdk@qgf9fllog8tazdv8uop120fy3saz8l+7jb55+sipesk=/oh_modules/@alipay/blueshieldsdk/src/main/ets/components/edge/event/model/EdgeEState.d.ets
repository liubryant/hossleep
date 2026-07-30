// @keepTs
// @ts-nocheck
/**
 * name: EdgeEState
 * desc: 单前事件状态
 *
 */
export interface State {
    equalsState(state: State): boolean;
}
export declare class Page implements State {
    spm: string;
    constructor(l33: string);
    equalsState(k33: Page): boolean;
    toString(): string;
}
export declare class App implements State {
    source: string;
    target: string;
    App(i33: string, j33: string): void;
    equalsState(h33: App): boolean;
    toString(): string;
}
export declare class EdgeEState {
    private page;
    private app;
    constructor();
    constructor(f33: Page, g33: App);
    equalsSubState(c33: State): boolean;
    updateSubState(b33: State): void;
    getSubState(a33: number): State | null | undefined;
    toString(): string;
}
