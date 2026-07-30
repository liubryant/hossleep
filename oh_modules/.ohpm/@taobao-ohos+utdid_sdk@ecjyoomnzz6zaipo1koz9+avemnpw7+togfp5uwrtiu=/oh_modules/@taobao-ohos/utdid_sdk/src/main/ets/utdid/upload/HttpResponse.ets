import { ByteUtils } from "../../utils/ByteUtils";
import { MD5Utils } from "../../utils/MD5Utils";
import { StringUtils } from "../../utils/StringUtils";
import { UtdidLogger } from "../../utils/UtdidLogger";

export class HttpResponse {
  httpResponseCode: number = -1;
  timestamp: number = 0;
  signature: string = "";
  data: Uint8Array | null = null;
  rt: number = 0;

  static checkSignature(result: string, signature: string): boolean {
    try {
      if (!StringUtils.isEmpty(result) && !StringUtils.isEmpty(signature)) {
        UtdidLogger.d("result:" + result + ",signature:" + signature);
        let md5: string = MD5Utils.getHmacMd5Hex(result);
        let sign: string = ByteUtils.toBase64String(ByteUtils.utf8Encode(md5));
        if (signature.localeCompare(sign) == 0) {
          UtdidLogger.d("signature is ok");
          return true;
        } else {
          UtdidLogger.d("SignatureCheck", "signature is error");
        }
      }
    } catch (e) {
      UtdidLogger.d("error in checkSignature:" + e.message);
    }
    return false;
  }
}
