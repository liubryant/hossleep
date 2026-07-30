import { ByteUtils } from "../../utils/ByteUtils";
import { UtdidLogger } from "../../utils/UtdidLogger";
import { HttpResponse } from "./HttpResponse";
import { BizResponse } from "./BizResponse";

export class UtdidResponse {
  static response(response: HttpResponse): boolean {
    let result: string = "";
    try {
      if (response.data != null) {
        result = ByteUtils.toUTF8String(response.data);
      }
    } catch (e) {
      UtdidLogger.d(`error in response:${e.message}`);
    }
    if (HttpResponse.checkSignature(result, response.signature)) {
      return BizResponse.isSuccess(BizResponse.parseResult(result).code);
    } else {
      return false;
    }
  }
}