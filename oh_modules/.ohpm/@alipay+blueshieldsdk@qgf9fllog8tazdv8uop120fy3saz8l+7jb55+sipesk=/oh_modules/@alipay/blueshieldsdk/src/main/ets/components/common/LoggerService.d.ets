// @keepTs
// @ts-nocheck
export declare const LOGGER_TAG_CAPTCHA: string;
export declare const LOGGER_TAG_MDAP: string;
export declare const LOGGER_TAG_ONE_KEY_STOP: string;
export declare const LOGGER_TAG_APDID: string;
export declare const LOGGER_TAG_COLLECT: string;
export declare const LOGGER_TAG_EDGE: string;
export declare const LOGGER_TAG_COMMON: string;
export declare const LOGGER_TAG_DTX: string;
export declare const LOGGER_TAG_RDS: string;
export declare const LOGGER_TAG_FS: string;
export declare const LOGGER_TAG_DYNAMIC4: string;
export declare class LoggerService {
    static verbose(a9: string, b9: string): void;
    static debug(y8: string, z8: string): void;
    static info(w8: string, x8: string): void;
    static warn(u8: string, v8: string): void;
    static error(s8: string, t8: string): void;
    static fatal(q8: string, r8: string): void;
}
