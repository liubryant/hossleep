// @keepTs
// @ts-nocheck
import { BizContext } from '../context/BizContext';
import { JSONObject } from '../utils/Utils';
import { ActionType } from './ActionType';
export declare class ElementAction {
    actionType: ActionType;
    name: string;
    params: string[];
    constructor(x21: string, y21: ActionType);
    static update(t21: BizContext, u21: ElementAction): void;
    static parse(m21: JSONObject | null): ElementAction[];
    private static parseActionName;
    private static parseParams;
}
