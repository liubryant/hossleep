// @keepTs
// @ts-nocheck
import { trustedAppService } from '@kit.DeviceSecurityKit';
import { DetectResult } from '../IDTXRiskManager';
declare class SecureLocation {
    private timeout;
    private challenge;
    private certChainObj;
    constructor(u22: number, v22: string);
    private createAttestKey;
    private initSecureLocationAttestContext;
    private finalizeAttestContext;
    private destroyAttestKey;
    private verifySecureLocation;
    checkSecureLocation(o21: trustedAppService.LocatingPriority, p21?: Context | null): Promise<DetectResult>;
}
declare const _default: SecureLocation;
export default _default;
