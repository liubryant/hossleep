// @keepTs
// @ts-nocheck
export declare enum EnvType {
    PROD = "prod",
    PRE = "pre",
    DEV = "dev"
}
export declare class ServerUrlUtil {
    private static currentEnv;
    static setEnv(c35: EnvType): void;
    private static getEnv;
    static getUrl(): string;
}
