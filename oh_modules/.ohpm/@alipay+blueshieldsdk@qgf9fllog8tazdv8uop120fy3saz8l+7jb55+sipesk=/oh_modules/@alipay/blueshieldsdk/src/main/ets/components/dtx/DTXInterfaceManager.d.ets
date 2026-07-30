// @keepTs
// @ts-nocheck
export declare class DTXInterfaceManager {
    private static TAG;
    private static maxWaitNum;
    private static cacheDeviceAuthenticityResult;
    private static cacheSysIntegrityResult;
    private static cacheLocationResult;
    /***
     * 调用后根据指令执行操作，并同步的返回相关结果。
     *@returns
     cmd 2  设备认证-证书链
      {"certVerify": 1}
     cmd 3 系统完整性
      {"result":0,"verify":1,"detail":["attack"],"timestamp":1722242242136}
     cmd 4 可信地理位置
      {"result":1,"verify":1,"timestamp":1722242243281,"detail":[39.95518144614042,116.31447755648293]}
     */
    DTXInvokeSync(p16: number): Promise<string>;
    /***
     *  调用后立即返回缓存的结果，首次调用结果为空；适用于设备染色。平均耗时1~5ms
     *@returns
     cmd 2  设备认证-证书链
     {"certVerify": 1}
     cmd 3 系统完整性
     {"result":0,"verify":1,"detail":["attack"],"timestamp":1722242242136}
     cmd 4 可信地理位置
     {"result":1,"verify":1,"timestamp":1722242243281,"detail":[39.95518144614042,116.31447755648293]}
     */
    DTXInvokeAsync(n16: number): string;
    private asyncCallSecurityDetect;
    private composeSecurityDetectResult;
}
