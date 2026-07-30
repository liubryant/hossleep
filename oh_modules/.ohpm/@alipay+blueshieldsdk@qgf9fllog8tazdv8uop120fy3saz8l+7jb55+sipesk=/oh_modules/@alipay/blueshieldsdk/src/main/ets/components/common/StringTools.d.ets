// @keepTs
// @ts-nocheck
export declare class StringTools {
    static isEmpty(l12: string): boolean;
    static getNonNullString(j12: string, k12: string): string;
    static encodeToBase64Str(h12: string): string;
    static encodeToBase64Uint8(g12: Uint8Array): string;
    static decodeToBase64Uint8(e12: Uint8Array | string): Uint8Array;
    static safeBase64decodeToBase64Uint8(c12: Uint8Array | string): Uint8Array;
    static decodeToBase64Str(a12: Uint8Array | string): string;
    static stringToUint8Array(y11: string): Uint8Array;
    static uint8ArrayToString(v11: Uint8Array): string;
    private static HEX_ARRAY;
    static uint8ArrayToHexString(r11: Uint8Array): string;
    static isNonEmptyString(q11: string | null | undefined): boolean;
}
