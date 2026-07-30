import { util } from "@kit.ArkTS";

export class ByteUtils {
  // 将一个字节数组转换为它的十六进制字符串表示形式
  static toHexString(b: Uint8Array): string {
    let sb = "";
    if (b == null || b.length == 0) {
      return sb;
    }
    // 十六进制字符数组
    const hexChar: string[] = '0123456789abcdef'.split('');
    for (let i = 0; i < b.length; i++) {
      sb += hexChar[(b[i] & 0xf0) >>> 4];
      sb += hexChar[b[i] & 0x0f];
    }
    return sb;
  }

  // 将字符串编码为 UTF-8 字节数组： 实现一个TextEncoder
  static utf8Encode(str: string): Uint8Array {
    let textEncoder = new util.TextEncoder("utf-8");
    return textEncoder.encodeInto(str);
  }

  // 将一个字节数组转化为base64编码的字符串
  static toBase64String(b: Uint8Array, type: util.Type = util.Type.BASIC): string {
    let base64Helper = new util.Base64Helper();
    let result = base64Helper.encodeToStringSync(b, type);
    return result;
  }

  // 将 Uint8Array 转换为字符串，使用 'utf-8' 编码
  static toUTF8String(b: Uint8Array): string {
    let textDecoder = util.TextDecoder.create('utf-8');
    return textDecoder.decodeToString(b);
  }

  static base64ToUnit8Array(str: Uint8Array | string, type: util.Type = util.Type.BASIC): Uint8Array {
    let base64Helper = new util.Base64Helper();
    return base64Helper.decodeSync(str, type);
  }
}