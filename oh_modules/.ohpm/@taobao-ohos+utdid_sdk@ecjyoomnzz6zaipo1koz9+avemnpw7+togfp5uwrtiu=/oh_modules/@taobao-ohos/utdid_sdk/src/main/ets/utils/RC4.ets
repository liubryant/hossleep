import { StringUtils } from "./StringUtils";

/**
 * RC4加密/解密
 */
class RC4Key {
  state: number[] = new Array(256);
  x: number = 0;
  y: number = 0;
}
export class RC4 {
  private static readonly RC4_PK: string = "QrMgt8GGYI6T52ZY5AnhtxkLzb8egpFn3j5JELI8H6wtACbUnZ5cc3aYTsTRbmkAkRJeYbtx92LPBWm7nBO9UIl7y5i5MQNmUZNf5QENurR5tGyo7yJ2G0MBjWvy6iAtlAbacKP0SwOUeUWx5dsBdyhxa7Id1APtybSdDgicBDuNjI0mlZFUzZSS9dmN8lBD0WTVOMz0pRZbR3cysomRXOO1ghqjJdTcyDIxzpNAEszN8RMGjrzyU7Hjbmwi6YNK";
  static rc4(inputData: Uint8Array): Uint8Array | null {
    if (inputData != null) {
      const rc4Key = RC4._prepareKey(RC4.RC4_PK);
      if (rc4Key != null) {
        return RC4._rc4Transform(inputData, rc4Key);
      }
    }
    return null;
  }

  private static _prepareKey(privateKey: string): RC4Key | null {
    if (!StringUtils.isEmpty(privateKey)) {
      const rc4Key = new RC4Key();
      let index1 = 0;
      let index2 = 0;
      for (let i = 0; i < 256; i++) {
        rc4Key.state[i] = i;
      }
      rc4Key.x = 0;
      rc4Key.y = 0;
      try {
        for (let i = 0; i < 256; i++) {
          index2 = (privateKey.charCodeAt(index1) + rc4Key.state[i] + index2) % 256;
          const swapInt = rc4Key.state[i];
          rc4Key.state[i] = rc4Key.state[index2];
          rc4Key.state[index2] = swapInt;
          index1 = (index1 + 1) % privateKey.length;
        }
      } catch (e) {
        return null;
      }
      return rc4Key;
    }
    return null;
  }

  private static _rc4Transform(data: Uint8Array, key: RC4Key): Uint8Array | null {
    if (data != null && key != null) {
      let x = key.x;
      let y = key.y;

      for (let i = 0; i < data.length; i++) {
        x = (x + 1) % 256;
        y = (key.state[x] + y) % 256;
        let swapInt = key.state[x];
        key.state[x] = key.state[y];
        key.state[y] = swapInt;
        const xorIndex = (key.state[x] + key.state[y]) % 256;
        data[i] ^= key.state[xorIndex];
      }

      key.x = x;
      key.y = y;
      return data;
    }
    return null;
  }
}