// @keepTs
// @ts-nocheck
export interface ISafeTokenModule {
    getEncToken(value: string, additional: string, flag: number): Uint8Array;
    getPaycodeWithEncToken(encToken: Uint8Array, svrTime: number, flag: number): string;
    encryptWithEncToken(encToken: Uint8Array, plainData: Uint8Array, flag: number): Uint8Array;
    decryptWithEncToken(encToken: Uint8Array, cipherData: Uint8Array, flag: number): Uint8Array;
    signWithEncToken(encToken: Uint8Array, data: Uint8Array, flag: number): string;
}
