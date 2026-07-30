// @keepTs
// @ts-nocheck
import { webview } from '@kit.ArkWeb';
export declare class BridgeUtil {
    static JAVASCRIPT_STR: String;
    static UNDERLINE_STR: string;
    static webViewLoadLocalJs(o53: Context, p53: webview.WebviewController, q53: string): void;
    private static rawFile2Str;
}
