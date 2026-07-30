// @keepTs
// @ts-nocheck
import { AsyncCallback } from '@ohos.base';
export interface IRDSModule {
    /**
     * 开始检测接口，会根据页面名称和参数创建一个RDS检测实例
     * @param page 接入RDS的页面名称
     * @param args 可扩展参数对象,钱包中主要用于外部传入tid,utdid,userId，productid等变量
     */
    startEngine(pageName: string, args: Map<string, string>): IRDSEngine;
    /**
     * 获取检测结果接口，会返回生成的安全数据
     * 耗时运算，需要放在异步线程中执行
     * @param engine 需要停止的RDS检测实例，由startEngine返回。
     */
    executeEngine(engine: IRDSEngine): string;
    /**
     * 异步获取检测结果接口，会在回调中返回安全数据
     * @param engine 需要停止的RDS检测实例，由startEngine返回。
     */
    executeEngineAsync(engine: IRDSEngine, listener: AsyncCallback<string>): void;
    /**
     * 异步获取检测结果接口，会返回Promise
     * @param engine 需要停止的RDS检测实例，由startEngine返回。
     */
    executeEngineAsync(engine: IRDSEngine): Promise<string>;
    /**
     * 停止检测接口，会销毁检测引擎实例
     * @param engine 需要停止的RDS检测实例，由startEngine返回。
     */
    stopEngine(engine: IRDSEngine): boolean;
}
export interface IRDSEngine {
    onPage(refPageName: string): void;
    onControlClick(ctrlName: string): void;
    onKeyDown(ctrlName: string, keyValue: string): void;
    onGetFocus(ctrlName: string): void;
    onLostFocus(ctrlName: string): void;
    onTouchScreen(ctrlName: string, event: TouchEvent): void;
    onPageEnd(updateUser: string): void;
    onEvent(eventType: RDSEvent, eventParam?: string, eventValue?: object): void;
}
export declare const enum RDSEvent {
    RDS_PAGE_START = 0,
    RDS_CONTROL_CLICK = 1,
    RDS_KEY_DOWN = 2,
    RDS_GET_FOCUS = 3,
    RDS_LOST_FOCUS = 4,
    RDS_TOUCH_SCREEN = 5,
    RDS_PAGE_END = 6
}
export declare const enum RDSParamKey {
    UTDID = "utdid",
    TID = "tid",
    APPNAME = "appname",
    APPVER = "appver",
    USER = "user",
    SDKVER = "sdkver",
    SDKNAME = "sdkname",
    PACKAGENAME = "appPackageName"
}
