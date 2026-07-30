import { UtdidLogger } from "./UtdidLogger";

const DEFAULT_UTDID_LENGTH: number = 24;

export class StringUtils {
  static isEmpty(str: string | null): boolean {
    return str == null || str.trim().length == 0;
  }

  static isValidUtdid(aimStr: string | undefined | null) {
    return typeof aimStr == 'string' && aimStr.length == DEFAULT_UTDID_LENGTH;
  }

  /**
   * 去除回车/换行/制表符/空格
   */
  static getStringWithoutBlank(pStr: string): string {
    if (StringUtils.isEmpty(pStr)) {
      return '';
    }
    const pattern = /\s+/g;
    // 使用正则表达式替换掉回车、换行和制表符
    return pStr.replace(pattern, "");
  }

  /**
   * 将Map对象转化为JSON字符串
   */
  // 将一个Map对象转化为string
  static convertMapToJSONString(map: Map<string, string | null>, needToSort: boolean = false): string {
    try {
      if (map != null && map instanceof Map && map.size > 0) {
        // 使用 Array.from 将 Map 转换为数组，然后使用 map 方法将每个键值对转换成字符串
        const entries = Array.from(map);
        // Sort the array by keys
        if (needToSort) {
          entries.sort((a, b) => StringUtils._compare(a[0], b[0]));
        }
        const keyValuePairs: string[] =
          entries.map(((kvArr: [string, string | null]) => `${JSON.stringify(kvArr[0])}: ${JSON.stringify(kvArr[1])}`));
        // 使用 join 方法将所有键值对用逗号和空格连接起来
        return '{' + `${keyValuePairs.join(', ')}` + '}';
      }
      return '{}';
    } catch (e) {
      UtdidLogger.e('error in convertMapToJSONString:' + e.message);
      return '{}';
    }
  }

  static _compare(a: string, b: string): number {
    if (a < b) {
      return -1;
    }
    if (a > b) {
      return 1;
    }
    return 0;
  }
}