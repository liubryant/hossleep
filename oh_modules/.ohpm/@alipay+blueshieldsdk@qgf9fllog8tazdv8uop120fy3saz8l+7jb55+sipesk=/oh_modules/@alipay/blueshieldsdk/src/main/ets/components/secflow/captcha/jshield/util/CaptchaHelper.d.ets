// @keepTs
// @ts-nocheck
interface CaptchaFileConfigObj {
    url: string;
    version: string;
    md5: string;
}
interface CaptchaFileConfig {
    c?: CaptchaFileConfigObj;
}
export declare class CaptchaHelper {
    static getCaptchaDirPath(): string;
    static getCaptchaCorePath(e52: string): string;
    static getConfigService(): CaptchaFileConfig;
    static getCoreUrlFile(): string;
    static triggerRemoteDownload(q51: CaptchaFileConfigObj, r51: string): void;
    static triggerDownload(): void;
    private static calFileMd5;
}
export {};
