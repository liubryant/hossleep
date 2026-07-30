// @keepTs
// @ts-nocheck
import window from "@ohos.window";
export declare class Loading {
    loadingWindow?: window.Window;
    show(): Promise<void>;
    hide(): Promise<void>;
}
