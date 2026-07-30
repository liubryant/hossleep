// @keepTs
// @ts-nocheck
import { Letter } from './Letter';
import cryptoFramework from '@ohos.security.cryptoFramework';
export declare class PackInfo {
    private isGzip;
    private bytes;
    constructor(t18: boolean, u18: Uint8Array);
    getIsGzip(): boolean;
    getBytes(): Uint8Array;
}
export declare class LetterPacker {
    /**
     * 是否加密(上下行保持一致)
     */
    isEncrypt: boolean;
    /**
     * 加密 key
     */
    key: string;
    constructor(s18: boolean);
    packet(k18: Letter, l18: boolean): Promise<PackInfo | null>;
    /**
     * 将一系列 dataField 封装为 05d%length - dataField 的形式
     */
    packetMulti(...d18: Uint8Array[]): Uint8Array;
    static genIVParamsSpec(): cryptoFramework.IvParamsSpec;
    unPacket(q17: PackInfo): Promise<Letter | null>;
}
