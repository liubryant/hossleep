// @keepTs
// @ts-nocheck
@Builder
export declare function AlipayH5PageBuilder(w8: string, x8: Object): void;
export declare class RouterParams {
    url: string;
    method: string;
    cookie: string;
    title: string;
    isBackExit: boolean;
    containerVersion: string;
    navPathStack?: NavPathStack;
}
@Entry({ routeName: 'alipay/sdk/pages/h5page/index' })
@Component
export declare struct AlipayH5Page {
    private context;
    private url;
    @State
    progress: number;
    private method;
    private cookie;
    @State
    title: string | Resource;
    @State
    showRefresh: boolean;
    @State
    showHeader: boolean;
    @State
    showProgress: boolean;
    navPageIntent?: Map<string, Object>;
    private navPathStack?;
    private isBackExit;
    private containerVersion;
    private isErrorPage;
    private webviewController?;
    @State
    isFullScreen: boolean;
    @State
    statusBarHeight: number;
    private mainWindow?;
    aboutToAppear(): void;
    private getStatusBarHeight;
    private updateCookie;
    aboutToDisappear(): void;
    onBackPress(): boolean | void;
    emitPayResult(b8: Map<string, string>): void;
    goBack(): void;
    finish(): void;
    onPageShow(): void;
    onRefresh(): void;
    isV1(): boolean;
    build(): void;
    @Builder
    buildContent(): void;
    private createWebViewController;
    injectJsApi(): void;
    processJsBridge(w5: string): void;
    processJsBridgeInner(t5: string, u5: string, v5: string): void;
}
