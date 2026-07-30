// @keepTs
// @ts-nocheck
import { ParamsHolder } from '../ParamsHolder';
import { JSBridgeController } from './JSBridgeController';
export declare class JShieldInterface {
    private jsBridgeController;
    private holder;
    constructor(q55: JSBridgeController, r55: ParamsHolder);
    response(n55: string, o55: string): void;
    success(l55: string, m55: string): void;
    ready(j55: string, k55: string): void;
    close(h55: String, i55: string): void;
    error(f55: string, g55: string): void;
}
