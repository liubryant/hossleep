import { JSONObject } from './JSONObject';
export declare class JSONArray {
    private array;
    constructor(p32?: string | any[]);
    get(o32: number): any;
    length(): number;
    applyToArray(l32: (item: any, index: number, array: any[]) => void): void;
    put(k32: any): void;
    put(h32: number, k32: any): void;
    remove(f32: number): void;
    getString(c32: number, d32?: string): string;
    getBoolean(z31: number, a32?: boolean): boolean;
    getNumber(w31: number, x31?: number): number;
    getJsonObject(t31: number, u31?: JSONObject | null): JSONObject | null;
    getJsonArray(q31: number, r31?: JSONArray | null): JSONArray | null;
    getArray<l31>(m31: number, n31?: l31[] | null): l31[] | null;
    toJson(): string;
}
