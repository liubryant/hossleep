// @keepTs
// @ts-nocheck
export declare class BASE64Helper {
    base64Alphabet: Uint8Array;
    lookUpBase64Alphabet: Uint8Array;
    BASELENGTH: number;
    LOOKUPLENGTH: number;
    constructor();
    decode(r29: string): ArrayBuffer | null;
    removeWhiteSpace(n29: Uint8Array): number;
    arrayCopy(h29: Uint8Array, i29: number, j29: Uint8Array, k29: number, l29: number): void;
    isData(g29: number): boolean;
    isPad(f29: number): boolean;
    isWhiteSpace(e29: number): boolean;
}
