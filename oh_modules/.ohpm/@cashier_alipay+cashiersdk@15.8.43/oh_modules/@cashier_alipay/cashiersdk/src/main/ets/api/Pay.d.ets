// @keepTs
// @ts-nocheck
import { Context } from "@ohos.abilityAccessCtrl";
import { Loading } from '../components/Loading';
export declare class Pay {
    context: Context;
    showLoading: boolean;
    registeredApp: boolean;
    loading?: Loading;
    navPathStack?: NavPathStack;
    navCallback?: (name: string, params: Map<string, Object>) => void;
    useH5WhenAppNotInstalled: boolean;
    constructor();
    getVersion(): string;
    /**
     *
     * @param orderInfo
     * @param showPayLoading 为 true时需要传入对应的component
     * @returns
     */
    pay(i5: string, j5?: boolean): Promise<Map<string, string>>;
    registerApp(h5: string): Promise<void>;
    /**
     *
     * @param orderInfo
     * @param showPayLoading
     * @param navCallback 商户传入自定义的nav跳转，由商户控制H5跳转
     * @param navPathStack 商户自定义跳转时的navPath，以及使用系统路由表的navPath
     * @param useH5WhenAppNotInstalled 唤端失败时是否使用H5支付
     * @returns
     */
    payWithNav(y4: string, z4?: boolean, a5?: (name: string, params: Map<string, Object>) => void, b5?: NavPathStack | undefined, c5?: boolean): Promise<Map<string, string>>;
    /**
     * 支付宝H5支付URL拦截器，完成拦截及支付方式转化
     * @param h5PayUrl 待过滤拦截的 url string
     * @param showPayLoading 是否出现loading
     * @param callback 异步回调接口
     * @returns true：表示URL为支付宝支付URL，URL已经被拦截并支付转化；false：表示URL非支付宝支付URL；
     */
    payInterceptorWithUrl(j4: string, k4: boolean, l4: (result: Map<string, string>) => void): boolean;
    /**
     * 独立签约
     * @param signParams
     * @param navPathStack
     * @param useH5WhenAppNotInstalled 是否使用 H5 唤起下载支付宝的落地页，需要的情况下 navPathStack 不能为空，默认 true
     * @returns
     */
    deduct(n3: string, o3: NavPathStack | undefined, p3?: boolean): Promise<Map<string, string>>;
    private deductWithH5Landing;
    private shouldInterceptUrlForCashier;
    private innerPay;
    private payResult;
    private openAlipay;
    private requestH5Pay;
    private processH5Pay;
    private router;
    private updateTid;
    private showPayLoading;
    private hidePayLoading;
}
