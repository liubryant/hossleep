// @keepTs
// @ts-nocheck
export declare class MapUtils {
    static mapToJson(x52: Map<string, object | string>): string;
    static mapToJsonObj(s52: Map<string, object | string>): Record<string, object | string>;
    static JsonToMap(p52: string): Map<string, string>;
    static mapToRecord(i52: Map<string, Object>): Record<string, Object>;
    static recordToMap(g52?: Record<string, Object>): Map<any, any>;
}
