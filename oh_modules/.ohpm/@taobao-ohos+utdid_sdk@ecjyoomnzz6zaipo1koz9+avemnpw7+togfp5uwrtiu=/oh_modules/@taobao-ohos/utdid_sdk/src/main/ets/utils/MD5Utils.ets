import { UtdidLogger } from "./UtdidLogger";
import { cryptoFramework } from "@kit.CryptoArchitectureKit";
import { ByteUtils } from "./ByteUtils";

export class MD5Utils {
  private static readonly HMAC_MD5_PK: string = "QrMgt8GGYI6T52ZY5AnhtxkLzb8egpFn";

  static getHmacMd5Hex(data: string): string {
    return MD5Utils._getHmacMd5Hex(MD5Utils._getHmacMd5Key(), data);
  }

  private static _getHmacMd5Hex(key: string, data: string): string {
    try {
      const result: Uint8Array = MD5Utils._getHmacSHA256(ByteUtils.utf8Encode(key), ByteUtils.utf8Encode(data));
      if (result != null) {
        return ByteUtils.toHexString(result);
      }
    } catch (e) {
      UtdidLogger.d("error in _getHmacMd5Hex" + e.message);
    }
    return "0000000000000000";
  }

  private static _md5(source: Uint8Array): Uint8Array {
    let res = new Uint8Array();
    if (source == null) {
      UtdidLogger.e('encryptDataMD5 params error: data should not be null.');
      return res;
    }
    try {
      // 计算 MD5
      let md = cryptoFramework.createMd('MD5');
      md.updateSync({ data: new Uint8Array(source) });
      let mdResult = md.digestSync();
      res = mdResult.data;
    } catch (e) {
      UtdidLogger.e(`error in encryptDataMD5:${e.message}`);
    }
    return res;
  }

  private static _getHmacSHA256(key: Uint8Array, data: Uint8Array): Uint8Array {
    const length = 64;
    const ipad = new Uint8Array(length).fill(0x36);
    const opad = new Uint8Array(length).fill(0x5C);
    let actualKey = key;

    if (key.length > length) {
      actualKey = MD5Utils._md5(key);
    }

    const keyArr = new Uint8Array(length);
    keyArr.set(actualKey);

    const kIpadXorResult = new Uint8Array(length);
    for (let i = 0; i < length; i++) {
      kIpadXorResult[i] = keyArr[i] ^ ipad[i];
    }

    const firstAppendResult = new Uint8Array(kIpadXorResult.length + data.length);
    firstAppendResult.set(kIpadXorResult);
    firstAppendResult.set(data, keyArr.length);

    const firstHashResult = MD5Utils._md5(firstAppendResult);

    const kOpadXorResult = new Uint8Array(length);
    for (let i = 0; i < length; i++) {
      kOpadXorResult[i] = keyArr[i] ^ opad[i];
    }

    const secondAppendResult = new Uint8Array(kOpadXorResult.length + firstHashResult.length);
    secondAppendResult.set(kOpadXorResult);
    secondAppendResult.set(firstHashResult, keyArr.length);

    return MD5Utils._md5(secondAppendResult);
  }

  private static _getHmacMd5Key(): string {
    const state = ByteUtils.utf8Encode(MD5Utils.HMAC_MD5_PK);
    try {
      for (let counter = 0; counter < state.length; counter++) {
        state[counter] = (state[counter] + counter) & 0xFF; // 确保值在0-255范围内
      }
      return ByteUtils.toHexString(state);
    } catch (e) {
      return "";
    }
  }
}
