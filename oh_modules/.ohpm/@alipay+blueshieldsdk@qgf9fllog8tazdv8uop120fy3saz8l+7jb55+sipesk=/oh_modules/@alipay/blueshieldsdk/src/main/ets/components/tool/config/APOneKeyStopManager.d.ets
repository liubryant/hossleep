// @keepTs
// @ts-nocheck
export declare enum OneKeyStop_Module {
    MODULE_OTP = "otp",
    MODULE_STORE = "store",
    MODULE_CAPTCHA = "captcha",
    MODULE_EDGE = "edge"
}
export declare enum OneKeyStop_Func {
    FUNC_JSHIELD = "jshield"
}
export declare class APOneKeyStopManager {
    private static GLOBAL_SWITCH_KEY;
    private static DEFAULT_SWITCH_KEY;
    private static switchCache;
    private static NOT_STOP_MODULES;
    static shouldStop(q64: string, r64?: string, s64?: string): boolean;
    /**
     * @param switchCache 缓存止血开关的List
     * @param configJson 止血开关配置，Json结构
     * @param rootKey 需要缓存进List的Json对应的key，因为是递归调用，所以调用时可以传null，从最外层开始
     * @return 是否成功将Json结构的配置转成List
     */
    private static loadSwitchConfig;
    /**
     * @param params 按顺序传入Module、Function、Block以及未来可能扩展的参数，若没有，则不传
     * @return 是否需要关闭该功能
     */
    private static shouldStopInner;
    private static combineMonitorKey;
}
