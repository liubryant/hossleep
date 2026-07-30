// @keepTs
// @ts-nocheck
export interface ITeeTokenModule {
    initTeeEncToken(srvFactor: string, additional: string | null, flag: number): Uint8Array;
    encryptByTeeEncToken(encBizID: Uint8Array, plainData: Uint8Array, additional: string | null, flag: number): Uint8Array;
    decryptByTeeEncToken(encBizID: Uint8Array, cipherData: Uint8Array, additional: string | null, flag: number): Uint8Array;
    signByTeeEncToken(encBizID: Uint8Array, data: Uint8Array, additional: string | null, flag: number): string;
    deleteTeeToken(encBizID: Uint8Array, additional: string | null, flag: number): number;
}
