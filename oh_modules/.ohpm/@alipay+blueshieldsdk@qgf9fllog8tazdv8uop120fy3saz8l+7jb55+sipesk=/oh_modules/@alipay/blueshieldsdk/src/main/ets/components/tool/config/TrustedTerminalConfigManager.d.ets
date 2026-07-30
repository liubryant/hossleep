// @keepTs
// @ts-nocheck
import { STEE_TYPE } from "./ConfigKeys";
export declare class TrustedTerminalConfigManager {
    private static instance;
    static getInstance(): TrustedTerminalConfigManager;
    isOpenBySteeType(a65: STEE_TYPE): boolean;
}
