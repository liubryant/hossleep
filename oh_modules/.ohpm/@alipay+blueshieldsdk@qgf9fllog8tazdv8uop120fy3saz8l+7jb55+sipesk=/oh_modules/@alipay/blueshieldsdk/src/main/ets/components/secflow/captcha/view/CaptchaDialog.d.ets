// @keepTs
// @ts-nocheck
import { display } from '@kit.ArkUI';
import { ValidateResult } from '../network/model/ValidateResult';
@CustomDialog
export declare struct CaptchaDialog {
    controller?: CustomDialogController;
    @State
    screenWidth: number;
    @State
    captchaStackMarginWidth: number;
    @State
    progressMarginWidth: number;
    @State
    progressWidth: number;
    @State
    stackWidth: number;
    @State
    maxSlideDistance: number;
    @State
    slideBlockResetPosition: number;
    @State
    currentFoldDisplayMode: display.FoldDisplayMode;
    @State
    customUIElement: string | null;
    @State
    imageView: string | null;
    @State
    tipsValue: number;
    @State
    slideBlockView: ResourceStr | undefined;
    @State
    disposeAccessPoint: string | null;
    @State
    disposeUuid: string | null;
    @State
    disposeName: string | null;
    @State
    disposeApplication: string | null;
    @State
    disposeTrace: string | null;
    @State
    disposeService: string | null;
    @State
    disposeAction: string | null;
    @State
    operationType: string | null;
    @State
    gatewayUrl: string | null;
    @State
    repeat: boolean;
    @State
    titleText: string | null;
    @State
    subTitleText: string | null;
    @State
    titlebarText: string | null;
    @State
    moveText: string | null;
    @State
    loadingText: string | null;
    @State
    qrText: string | null;
    @State
    rj: string | null;
    @State
    clickFeedback: string | null;
    @State
    companyText: string | null;
    @State
    errorText: string | null;
    @State
    feedbackCode: string | null;
    @State
    slideText: string | null;
    @State
    slideTextColor: string;
    @State
    isLock: boolean;
    @State
    _marginTop: number;
    @State
    _marginBottom: number;
    @State
    slideBlockPosition: number;
    @State
    slideLongPress: boolean;
    @State
    slideReached: boolean;
    @State
    rotateAngle: number;
    private defaultZIndex;
    @State
    slideProgressZIndex: number;
    @State
    slideTextZIndex: number;
    private higherZIndex;
    private qrImageWidth;
    private qrImageHeight;
    private rdsEngine;
    private rdsModule;
    cancel: () => void;
    resetScreenWidth(): void;
    aboutToAppear(): void;
    createEmptyPixelMap(): Promise<PixelMap>;
    verify(): Promise<ValidateResult | null>;
    aboutToDisappear(): void;
    resetSlider(): void;
    build(): void;
    private foldDisplayModeCallback;
}
