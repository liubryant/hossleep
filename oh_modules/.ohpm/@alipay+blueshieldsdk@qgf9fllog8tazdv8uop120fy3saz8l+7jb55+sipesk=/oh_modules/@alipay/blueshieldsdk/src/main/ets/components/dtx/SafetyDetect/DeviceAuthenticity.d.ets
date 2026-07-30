// @keepTs
// @ts-nocheck
import { DetectResult } from '../IDTXRiskManager';
import { Context } from '@kit.AbilityKit';
export declare class DeviceAuthenticity {
    private static challenge;
    private static handle;
    static signature: Uint8Array;
    private static GetEccGenerateProperties;
    private static GetAnonAttestProperties;
    private static GetEccSignProperties;
    private static GetEccVerifyProperties;
    static generateKey(p20: string): Promise<void>;
    static anonAttestOptions(k20: string): Promise<string>;
    static Sign(d20: string, e20: string): Promise<void>;
    static Verify(t19: string, u19: string, v19: Uint8Array): Promise<void>;
    static DeleteEccKey(p19: string): Promise<void>;
    static huksAbort(): void;
    static localVerifyAnonCertChain(h19: string): Promise<number>;
    static checkDeviceAuthenticity(s18?: Context | null): Promise<DetectResult>;
}
