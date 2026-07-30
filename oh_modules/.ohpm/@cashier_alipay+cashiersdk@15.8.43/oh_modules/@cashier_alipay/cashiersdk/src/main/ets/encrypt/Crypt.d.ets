// @keepTs
// @ts-nocheck
export declare class Crypt {
    static encryptRSA2048(t15: string, u15: string): Promise<Uint8Array>;
    /**
     * @param key
     * @param content
     * @param iSrc
     * @returns
     */
    static encrypt3DES192(g15: string, h15: Uint8Array): Promise<Uint8Array>;
    static decrypt3DES192(t14: string, u14: Uint8Array): Promise<Uint8Array>;
    private static genIVParamsSpec;
}
