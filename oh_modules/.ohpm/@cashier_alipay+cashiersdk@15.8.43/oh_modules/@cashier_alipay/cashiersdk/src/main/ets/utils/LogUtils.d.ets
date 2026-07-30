// @keepTs
// @ts-nocheck
export declare class LogUtils {
    private static logCb;
    static setupLogCallback(v34: (logLine: string) => void): void;
    private static writeLog;
    static d(o34: string | undefined, p34: string | undefined): void;
    static i(m34: string | undefined, n34: string | undefined): void;
    static w(k34: string | undefined, l34: string | undefined): void;
    static e(i34: string | undefined, j34: string | undefined): void;
    static eStack(f34: string | undefined, g34: string | undefined, h34: Error | undefined): void;
    static printExceptionStackTrace(e34: Error | undefined): void;
}
