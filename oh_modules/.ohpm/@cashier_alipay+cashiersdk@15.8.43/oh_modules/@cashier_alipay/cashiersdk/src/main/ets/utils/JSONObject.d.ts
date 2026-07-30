import { JSONArray } from './JSONArray';
export declare class JSONObject {
    private object;
    constructor(x33?: string | Record<string, any>);
    getString(u33: string, v33?: string): string;
    getBoolean(r33: string, s33?: boolean): boolean;
    getNumber(o33: string, p33?: number): number;
    getJsonObject(l33: string, m33?: Record<string, any> | null): JSONObject | null;
    getJsonArray(i33: string, j33?: JSONArray | null): JSONArray | null;
    getArray<d33>(e33: string, f33?: d33[] | null): d33[] | null;
    hasKey(c33: string): boolean;
    put(a33: string, b33: any): void;
    remove(z32: string): void;
    applyToArray(w32: string, x32: (item: any, index: number, array: any[]) => void): void;
    toJson(): string;
    toInstance<r32>(s32: {
        new (...args: any[]): r32;
    }): r32;
}
