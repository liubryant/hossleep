// @keepTs
// @ts-nocheck
import { window } from '@kit.ArkUI';
export declare class EdgeScreenshotReceiver {
    private static instance?;
    isRegister: boolean;
    private switchOn;
    static getInstance(): EdgeScreenshotReceiver;
    onScreenshot(k37: window.Window): Promise<void>;
    configParse(): void;
    register(): Promise<void>;
}
