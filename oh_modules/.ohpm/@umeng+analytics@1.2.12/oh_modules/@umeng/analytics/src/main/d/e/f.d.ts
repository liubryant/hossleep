import { BasePlugin, UMConfig, LogAgent, LogStore, NativeEncoder } from '@umeng/common';
import buffer from '@ohos.buffer';
import { ErrLog } from "../h/i";
export declare class AnaPlugin extends BasePlugin {
    config: AnaConfig;
    logAgent: LogAgent;
    logStore: LogStore;
    logEncoder: NativeEncoder;
    cfg: UMConfig;
    dsn: Array<string>;
    errlog: ErrLog;
    disable_ekv_smart_check: boolean;
    constructor(o3?: AnaConfig);
    install(k: UMConfig): void;
    agree(): Promise<void>;
    uninstall(): void;
    write(b: string, c: Record<string, string | number>, d: number, e?: string): void;
    beforeEncode(a: buffer.Buffer): Promise<buffer.Buffer>;
}
export interface AnaConfig {
    dsn?: Array<string>;
    disable_ekv_smart_check?: boolean;
}
