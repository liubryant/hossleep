// @keepTs
// @ts-nocheck
import { ISafeTokenModule } from './ISafeTokenModule';
export declare class SafeTokenModule implements ISafeTokenModule {
    getEncToken(c71: string, d71: string, e71: number): Uint8Array;
    getPaycodeWithEncToken(x70: Uint8Array, y70: number, z70: number): string;
    encryptWithEncToken(s70: Uint8Array, t70: Uint8Array, u70: number): Uint8Array;
    decryptWithEncToken(n70: Uint8Array, o70: Uint8Array, p70: number): Uint8Array;
    signWithEncToken(i70: Uint8Array, j70: Uint8Array, k70: number): string;
}
