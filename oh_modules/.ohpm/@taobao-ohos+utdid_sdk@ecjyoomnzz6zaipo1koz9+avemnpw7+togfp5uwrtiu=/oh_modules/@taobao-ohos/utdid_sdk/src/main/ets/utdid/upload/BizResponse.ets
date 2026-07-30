import { StringUtils } from "../../utils/StringUtils";
import { UtdidLogger } from "../../utils/UtdidLogger";
import { JSON } from "@kit.ArkTS";
import { update_utdid_native } from 'libutdid_native.so';

export class BizResponse {
  private static readonly TAG_CODE: string = "code";
  private static readonly TAG_DATA: string = "data";
  private static readonly TAG_UTDID: string = "utdid";
  code: number = -1;

  // 解析Api 结果
  static parseResult(content: string): BizResponse {
    let response: BizResponse = new BizResponse();
    try {
      let json = JSON.parse(content) as object;

      if (Reflect.has(json, BizResponse.TAG_CODE)) {
        response.code = BizResponse._getInt(json[BizResponse.TAG_CODE]);
      }

      if (Reflect.has(json, BizResponse.TAG_DATA)) {
        const dataJson = json[BizResponse.TAG_DATA] as object;

        if (dataJson != null) {
          if (Reflect.has(dataJson, BizResponse.TAG_UTDID)) {
            const utdid = dataJson[BizResponse.TAG_UTDID] as string;
            if (StringUtils.isValidUtdid(utdid)) {
              update_utdid_native(utdid);
            }
          }
        }
      }
      UtdidLogger.d(`BizResponse content:${content}`);
    } catch (e) {
      UtdidLogger.e("error in parseResult:" + e.message);
    }
    return response;
  }

  static isSuccess(code: number): boolean {
    return (code >= 0 && code != 10012);
  }

  private static _getInt(aim: string | number): number {
    if(typeof aim == 'number') {
      return aim;
    }
    let aimNumber: number = 0;
    try {
      aimNumber = parseInt(aim);
    } catch (e) {
      aimNumber = 0;
      UtdidLogger.e("error in _getInt:" + e.message);
    }
    return aimNumber;
  }
}
