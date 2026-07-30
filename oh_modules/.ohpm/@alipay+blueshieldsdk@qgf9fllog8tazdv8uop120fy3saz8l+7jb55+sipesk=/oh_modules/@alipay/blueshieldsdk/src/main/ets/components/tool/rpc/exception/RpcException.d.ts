export default class RpcException {
    constructor();
    mOperationType?: string;
    /**
     * 异常码
     */
    mErrorCode: number;
    /**
     * 异常消息
     */
    mErrorMsg: string;
    bifrostErrCode?: string;
    static ErrorCode: {
        new (): {};
        /**
         * 成功
         */
        readonly OK: number;
        /**
         * 未知错误
         */
        readonly CLIENT_UNKNOWN_ERROR: number;
        /**
         * 客户端没有网络,如用户关闭了网络或者禁止了应用的网络权限
         */
        readonly CLIENT_NETWORK_UNAVAILABLE_ERROR: number;
        /**
         * SSL相关错误,包括SSL握手错误,SSL证书错误
         */
        readonly CLIENT_NETWORK_SSL_ERROR: number;
        /**
         * 客户端默认错误码,包括注解处理错误,线程执行错误ExecutionException等
         */
        readonly CLIENT_HANDLE_ERROR: number;
        /**
         * 客户端数据反序列化错误,服务端数据格式有误
         */
        readonly CLIENT_DESERIALIZER_ERROR: number;
        /**
         * 客户端登录失败
         */
        readonly CLIENT_LOGIN_FAIL_ERROR: number;
        /**
         * 客户端登录账号切换
         */
        readonly CLIENT_USER_CHANGE_ERROR: number;
        /**
         * 客户端网络缓存错误
         */
        readonly CLIENT_NETWORK_CACHE_ERROR: number;
        /**
         * 网络限流,客户端限流,当客户端请求流量超过阈值后会被限制网络请求
         */
        readonly NETWORK_TRAFIC_BEYOND_LIMIT: number;
        /**
         * 需要认证的wifi,如CMCC等需要认证才能使用的wifi
         */
        readonly NETWORK_AUTH_WIFI: number;
        /**
         * 客户端数据序列化错误
         */
        readonly CLIENT_SERIALIZER_ERROR: number;
        /**
         * 客户端业务拦截器处理错误
         */
        readonly BIZ_INTERCEPTOR_HANDLE_ERROR: number;
        readonly CLIENT_REQ_OVERSIZE_ERROR: number;
        readonly CLIENT_RES_OVERSIZE_ERROR: number;
        /**
         * 登录刷新错误码
         */
        readonly LOGIN_REFRESH_ERROR: number;
        /**
         * BACKGROUND FETCH 模式，限制RPC发送。
         */
        readonly BACKGROUND_FETCH_FUSE_RPC_ERROR: number;
        /***
         * 地区切换中拒绝RPC请求
         */
        readonly REFUSE_RPC_WHEN_REGION_SWITCHING: number;
        /**地区已经切换*/
        readonly REGION_CHANGED_ERROR: number;
        /**登录被拦截错误码*/
        readonly RPC_NOTAUTH_SKIPLOGIN: number;
        /**SSL证书尚未生效：系统时间在SSL证书有效期之前*/
        readonly CLIENT_NETWORK_SSL_CERT_NOT_YET_VALID: number;
        /**SSL证书已经过期：系统时间在SSL证书有效期之后*/
        readonly CLIENT_NETWORK_SSL_CERT_EXPIRED: number;
        /**预期外RPC异常,比如ArrayIndexOutOfBoundsException*/
        readonly CLIENT_RPC_UNEXCEPT_ERROR: number;
        /**SSL证书路径无效*/
        readonly CLIENT_NETWORK_SSL_CERT_PATH_INVALID: number;
        /**拦截器处理异常*/
        readonly CLIENT_HANDLE_ANNOTATION_ERROR: number;
        /**rpc客户端限流,主要场景:1.大促限流 2.业务无效流量*/
        /**rpc任务超时错误码
         * java.util.concurrent.TimeoutException
         * at java.util.concurrent.FutureTask.get(FutureTask.java:206)
         * at com.alipay.mobile.common.rpc.transport.http.HttpCaller.b(SourceFile:30)
         * at com.alipay.mobile.common.rpc.transport.http.HttpCaller.call(SourceFile:268)
         */
        /**rpc签名超长耗时*/
        readonly CLIENT_SIGN_LONG_COST_EXCEPTION: number;
        /**
         * 拒绝访问。
         */
        readonly SERVER_PERMISSIONDENY: number;
        /**
         * 调用次数超过限制:系统繁忙，请稍后再试。
         */
        readonly SERVER_INVOKEEXCEEDLIMIT: number;
        readonly SERVER_INVOKEEXCEEDLIMIT2: number;
        readonly SERVER_RDS_SAFE_LIMIT: number;
        /**
         * 当前App无权限访问该RPC。
         */
        readonly SERVER_APP_NO_PERMISSION_TO_ACCESS: number;
        /**
         * 设备id检查失败,请求头里的 utdid 和 session 中的 utdid 不一致
         */
        readonly SERVER_UTDID_CHECK_FAIL: number;
        /**
         * 调用业务方被 guardian 限流
         */
        readonly SERVER_GUARDIAN_LIMIT: number;
        /**
         * 错误描述：被安全xagent(spanner侧)拦截
         * 原因：识别出流量有风险，属于不正常操作
         */
        readonly SERVER_XAGENT_CHECK_FAIL: number;
        /**
         * 登录超时，请重新登录:登录超时，请重新登录。
         */
        readonly SERVER_SESSIONSTATUS: number;
        /**
         * 游客模式, 要求登录
         */
        readonly SERVER_VISITORSTATUS: number;
        /**
         * 缺少操作类型或者此操作类型不支持
         */
        readonly SERVER_OPERATIONTYPEMISSED: number;
        /**
         * 请求数据为空:系统繁忙，请稍后再试。
         */
        readonly SERVER_REQUESTDATAMISSED: number;
        /**
         * 数据格式有误。
         */
        readonly SERVER_VALUEINVALID: number;
        /**
         * 网关加解密异常
         */
        readonly SERVER_CRYPT_ERROR: number;
        /**
         * 服务请求超时，请稍后再试:。
         */
        readonly SERVER_REQUESTTIMEOUT: number;
        /**
         * 远程调用业务系统异常:网络繁忙，请稍后再试。
         */
        readonly SERVER_REMOTEACCESSEXCEPTION: number;
        /**
         * 创建远程调用代理失败:网络繁忙，请稍后再试。
         */
        readonly SERVER_CREATEPROXYERROR: number;
        /**
         * 未知错误:抱歉，暂时无法操作，请稍后再试。
         */
        readonly SERVER_UNKNOWERROR: number;
        /**spanner http2集群限流*/
        readonly SPANNER_HTTP_LIMIT: number;
        /**
         * RPC-服务找不到。
         */
        readonly SERVER_SERVICENOTFOUND: number;
        /**
         * RPC-目标方法找不到。
         */
        readonly SERVER_METHODNOTFOUND: number;
        /**
         * RPC-参数数目不正确
         */
        readonly SERVER_PARAMMISSING: number;
        /**
         * RPC-目标方法不可访问。
         */
        readonly SERVER_ILLEGALACCESS: number;
        /**
         * RPC-JSON解析异常。
         */
        readonly SERVER_JSONPARSEREXCEPTION: number;
        /**
         * RPC-调用目标方法时参数不合法
         */
        readonly SERVER_ILLEGALARGUMENT: number;
        /**
         * RPC-业务异常。
         */
        readonly SERVER_BIZEXCEPTION: number;
        /**
         * 没有设置公钥
         */
        readonly PUBLIC_KEY_NOT_FOUND: number;
        /**
         * 验签的参数不够
         */
        readonly SIGNA_PARAM_MISSING: number;
        /**
         * 验签失败
         */
        readonly SIGN_VERIFY_FAILED: number;
        /**
         * 验签时间戳校验失败CLIENT_NETWORK_AUTH_ERROR
         */
        readonly SIGN_TIME_STAMP_ERROR: number;
        /**
         * 验签RPC接口 operationType参数为空
         */
        readonly PRC_OPERATIONTYPE_EMPTY: number;
        /**
         * productId参数为空
         */
        readonly PRC_PRODCUTID_EMPTY: number;
        /**
         * 验签RPC接口 did参数为空
         */
        readonly PRC_DID_EMPTY: number;
        /**
         * 验签RPC接口 请求发送时间参数t为空
         */
        readonly PRC_REQUESTTIME_EMPTY: number;
        /**
         * 验签RPC接口 IMEI(客户端设备标识)参数为空
         */
        readonly PRC_IMEI_EMPTY: number;
        /**
         * 验签RPC接口 IMSI(客户端用户标识)为空
         */
        readonly PRC_IMSI_EMPTY: number;
        /**
         * 验签RPC接口 加签数据为空
         */
        readonly PRC_SIGN_EMPTY: number;
        /**
         * 验签RPC接口 API版本号为空
         */
        readonly PRC_APIVERSION_EMPTY: number;
        /**
         * 验签RPC接口 用户没有权限
         */
        readonly PRC_NO_AUTHORIZED: number;
        /**
         * 验签RPC接口 RPC没有对外开放
         */
        readonly PRC_NO_PUBLISHED: number;
        /**
         * 验签RPC接口 productId没有注册或者获取密钥为空
         */
        readonly PRC_SECRET_EMPTY: number;
        /**
         * 验签RPC接口 签约无效
         */
        readonly PRC_SIGN_INVALID: number;
        /**
         * 验签RPC接口 请求登录RPC需要传入sid
         */
        readonly PRC_SID_EMPTY: number;
        /**
         * 验签RPC接口 请求登录RPC需要传入sid
         */
        readonly PRC_SID_INVALID: number;
        /**
         * 验签RPC接口 请求登录RPC需要传入token无效
         */
        readonly PRC_TOKEN_INVALID: number;
        /**
         * 验签RPC接口 请求登录RPC 获取alipayuserid为空
         */
        readonly PRC_TOKEN_ALIPAYUSER_EMPTY: number;
        /**
         * 响应数据没有变化,etag场景,服务端数据无变化,客户端使用上次缓存结果,如拉取开关RPC
         */
        readonly RESPONSE_DATA_NOT_MODIFIED: number;
        /**RWP网关返回的result-status,此状态码不应直接抛给业务方,应有网络sdk内部处理*/
        readonly RPC_RETRY_WITH_PENDING: number;
    };
}
