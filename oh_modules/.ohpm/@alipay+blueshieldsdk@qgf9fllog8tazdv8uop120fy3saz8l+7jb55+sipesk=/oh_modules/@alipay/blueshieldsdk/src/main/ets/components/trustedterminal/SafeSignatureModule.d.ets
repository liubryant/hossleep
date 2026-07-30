// @keepTs
// @ts-nocheck
import { ISafeSignatureModule, BS_SAFE_SIGNATURE_ALGO } from './ISafeSignatureModule';
export declare class SafeSignatureModule implements ISafeSignatureModule {
    verify(e70: BS_SAFE_SIGNATURE_ALGO, f70: string, g70: Uint8Array, h70: Uint8Array): boolean;
    verifyWithKey(a70: BS_SAFE_SIGNATURE_ALGO, b70: Uint8Array, c70: Uint8Array, d70: Uint8Array): boolean;
    sign(x69: BS_SAFE_SIGNATURE_ALGO, y69: string, z69: Uint8Array): Uint8Array;
    signString(r69: BS_SAFE_SIGNATURE_ALGO, s69: string, t69: string): string;
    private signInternal;
    private verifyInternal;
}
