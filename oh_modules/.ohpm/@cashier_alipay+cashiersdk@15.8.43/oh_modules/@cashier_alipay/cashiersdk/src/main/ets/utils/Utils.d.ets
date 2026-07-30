// @keepTs
// @ts-nocheck
import { Context } from "@ohos.abilityAccessCtrl";
export type JSONObject = Record<string, ESObject>;
export declare function formatResult(t36: string): Map<string, string>;
export declare function isEmpty(s36: string | null | undefined): boolean;
export declare function getRandomString(l36: number): string;
export declare function stringToUint8ArrayWithEncoder(j36: string): Uint8Array;
export declare function uint8ArrayToStringWithDecoder(h36: Uint8Array): string;
export declare function formatNumber(e36: number, f36: number): string;
export declare function debug(c36: string, d36: string): void;
export declare function getQueryMap(w35: string): Map<string, string>;
export declare function getProcessUid(v35: Context): number;
export declare function elapsedRealtime(): number;
export declare function doLoopSHA256(l35: string): Promise<string>;
/**
 * 截取制定字符串中的字符
 *
 * @param startTag
 *            开始标记
 * @param engTag
 *            结束标记
 * @param str
 *            进行分析处理的字符串
 */
export declare function subString(d35: string, e35: string, f35: string): string;
