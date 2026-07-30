// @keepTs
// @ts-nocheck
import { ITeeTokenModule } from './ITeeTokenModule';
export declare class TeeTokenModule implements ITeeTokenModule {
    initTeeEncToken(x73: string, y73: string, z73: number): Uint8Array;
    encryptByTeeEncToken(r73: Uint8Array, s73: Uint8Array, t73: string, u73: number): Uint8Array;
    decryptByTeeEncToken(l73: Uint8Array, m73: Uint8Array, n73: string, o73: number): Uint8Array;
    signByTeeEncToken(f73: Uint8Array, g73: Uint8Array, h73: string, i73: number): string;
    deleteTeeToken(a73: Uint8Array, b73: string, c73: number): number;
}
