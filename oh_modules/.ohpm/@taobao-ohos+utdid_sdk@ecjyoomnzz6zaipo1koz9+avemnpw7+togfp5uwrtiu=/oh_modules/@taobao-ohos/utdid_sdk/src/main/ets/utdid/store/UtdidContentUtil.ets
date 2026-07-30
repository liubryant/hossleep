import { StringUtils } from "../../utils/StringUtils";
import { UtdidLogger } from "../../utils/UtdidLogger";
import { util } from '@kit.ArkTS';
import { buffer } from '@kit.ArkTS';
import { RC4 } from "../../utils/RC4";

export class UtdidContentUtil {
  static getEncodedContent(udid: string): string {
    let temp = '';
    if (StringUtils.isEmpty(udid)) {
      return temp;
    }
    try {
      // 将字符串编码为 UTF-8 字节数组： 实现一个TextEncoder
      let textEncoder = new util.TextEncoder("utf-8");
      const bytes: Uint8Array | null = RC4.rc4(textEncoder.encodeInto(udid));
      temp = buffer.from(bytes).toString("base64");
    } catch (e) {
      UtdidLogger.e("error in getEncodedContent:" + e.message);
    }
    return temp;
  }
}