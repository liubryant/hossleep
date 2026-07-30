// @keepTs
// @ts-nocheck
export declare class ScpFrameworkEvents {
    static E_INVALID_RESULT: number;
    static E_EXCEPTION_FOUND: number;
    static isScpInitialized: boolean;
    static scpSendEvent(v32: string, w32: string, x32: Uint8Array | null, y32: number | undefined): string;
    static scpPostEvent(r32: string, s32: string, t32: Uint8Array): number;
}
