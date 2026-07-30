// @keepTs
// @ts-nocheck
import { AsyncCallback } from '@ohos.base';
/**
 * 设备指纹结果类
 * 包含apdidToken
 */
export declare class TokenResult {
    apdidToken: string;
    apdid: string;
    umidToken: string;
}
export declare const enum APDIDParamKey {
    TID = "tid",
    UTDID = "utdid",
    USERID = "userId"
}
/**
 * 设备指纹接口类
 */
export interface IAPDIDModule {
    /**
     * 设备指纹异步初始化回调接口
     * 采集设备信息并通过RPC发送到服务器，然后回调用户设置的listener接口返回结果
     * 注意:用户设置的回调listener将在异步线程中被SDK调用,不用直接在listener中做UI相关的操作
     *
     * @param inArgs   可扩展参数对象,钱包中主要用于外部传入tid,utdid,userId等变量
     * @param listener 结果回调，回调参数见{@link TokenResult}
     * @throws BusinessError 1111 - to be declared error.
     */
    initToken(inArgs: Map<string, string>, listener: AsyncCallback<TokenResult>): void;
    /**
     * 设备指纹异步初始化Promise接口
     * 采集设备信息并通过RPC发送到服务器，结果通过Promise返回
     *
     * @param inArgs   可扩展参数对象,钱包中主要用于外部传入tid,utdid,userId等变量
     * @returns Promise<TokenResult>, 结果见{@link TokenResult}
     */
    initToken(inArgs: Map<string, string>): Promise<TokenResult>;
    /**
     * 同步获取TokenResult
     *
     * @return 参照类 {@link TokenResult}
     */
    getTokenResult(): TokenResult;
    /**
     * 同步获取apdidToken
     *
     * @return apdidToken {@link TokenResult.apdidToken}
     */
    getApdidToken(): string;
    /**
     * 设备指纹开放版异步初始化callback接口
     * 集成在钱包H5容器中的App调用,获取apdidToken
     *
     * @param appName
     * @param appKeyClient
     * @param listener, 回调参数为apdidToken
     */
    initOpenToken(appName: string, appKeyClient: string, listener: AsyncCallback<string>): void;
    /**
     * 设备指纹开放版异步初始化promise接口
     * 集成在钱包H5容器中的App调用,获取apdidToken
     *
     * @param appName
     * @param appKeyClient
     * @returns Promise<string>, 结果为apdidToken
     */
    initOpenToken(appName: string, appKeyClient: string): Promise<string>;
    /**
     * 设备指纹id变化监听注册接口
     *
     * @param listener, 回调参数含义：
     *  0: apdid 没变;
     *  1: apdid 跟上次比较有变化
     */
    registerDeviceIdChanged(listener: AsyncCallback<number>): void;
}
