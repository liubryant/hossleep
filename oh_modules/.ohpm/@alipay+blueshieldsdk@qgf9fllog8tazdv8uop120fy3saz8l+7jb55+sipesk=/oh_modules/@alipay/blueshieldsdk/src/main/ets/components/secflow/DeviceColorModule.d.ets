// @keepTs
// @ts-nocheck
import { IDeviceColorModule } from './IDeviceColorModule';
export declare class DeviceColorModule implements IDeviceColorModule {
    getColorLabel(z61: string, a62: Map<string, string>): string;
    initColorInfo(): number;
    getColorInfo(i61: string, j61: string, k61: Map<string, string>): string;
}
