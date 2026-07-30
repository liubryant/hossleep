// @keepTs
// @ts-nocheck
export declare class CaptchaDialogCallerParams {
    uiElement: string | null;
    constructor(j42: string);
}
@Component
export declare struct CaptchaDialogCaller {
    @State
    customUIElement: string | null;
    private lastWindow;
    private dialogController;
    aboutToAppear(): void;
    aboutToDisappear(): void;
    exitDialog(): void;
    build(): void;
}
export declare class CaptchaViewManager {
    static parseCaptchaParam(f41: string): Map<string, string>;
    static show(o40: string): Promise<string | null>;
    private static openCustomDialog;
}
