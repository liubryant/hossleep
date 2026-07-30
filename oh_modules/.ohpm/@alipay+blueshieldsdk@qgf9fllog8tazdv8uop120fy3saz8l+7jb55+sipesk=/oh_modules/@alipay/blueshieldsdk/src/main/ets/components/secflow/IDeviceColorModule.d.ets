// @keepTs
// @ts-nocheck
export interface IDeviceColorModule {
    getColorLabel(bizToken: string, extParams: Map<string, string>): string;
    initColorInfo(): number;
    getColorInfo(bizToken: string, bizParams: string, extParams: Map<string, string>): string;
}
export declare enum DEVICE_COLOR_CONSTANTS {
    COLOR_KEY = "color",
    EDGE_TRACE_KEY = "edge-traceID",
    EDGE_APPID_KEY = "appid",
    EDGE_MODE_KEY = "mode",
    MODE_NORMAL = "0",
    MODE_ENHANCE = "1",
    UPDATE_LABEL_SCENE_STATIC = "static",
    UPDATE_LABEL_SCENE_DYNAMIC = "dynamic",
    UPDATE_CODE_SCENE_CONFIG = "config",
    UPDATE_CODE_SCENE_PULL = "pull"
}
