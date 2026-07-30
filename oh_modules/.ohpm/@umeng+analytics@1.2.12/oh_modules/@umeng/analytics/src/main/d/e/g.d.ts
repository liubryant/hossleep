import { BasePlugin, UMConfig, LogAgent, LogStore, NativeEncoder } from '@umeng/common';
interface SourceConfig {
}
export declare class SourcePlugin extends BasePlugin {
    config: SourceConfig;
    dsn: Array<string>;
    logAgent: LogAgent;
    logStore: LogStore;
    logEncoder: NativeEncoder;
    cfg: UMConfig;
    constructor(p3: SourceConfig);
    install(q: UMConfig): void;
    write(m: string, n: Record<string, string | number>, o: number, p?: string): void;
    agree(): Promise<void>;
}
export {};
