/**
 * @author liuzheng
 * @mail bryant_liu24@126.com
 */
import { common } from '@kit.AbilityKit';
import { Log, Pay } from '@cashier_alipay/cashiersdk';
import { VipOrderData } from './VipProduct';

export class AlipayLaunchResult {
  launched: boolean;
  message: string;

  constructor(launched: boolean, message: string) {
    this.launched = launched;
    this.message = message;
  }
}

export class AlipayManager {
  private static didSetupLog: boolean = false;

  static async pay(context: common.UIAbilityContext, orderData: VipOrderData): Promise<AlipayLaunchResult> {
    AlipayManager.setupSdkLog();
    const orderString = AlipayManager.resolveOrderString(orderData);
    if (orderString.length === 0) {
      return new AlipayLaunchResult(false, '支付宝参数错误');
    }

    console.info(`[AlipayManager] pay start orderId=${AlipayManager.safeValue(orderData.orderId ?? orderData.id)} ` +
      `orderStringLength=${orderString.length} appId=${AlipayManager.queryValue(orderString, 'app_id')} ` +
      `method=${AlipayManager.queryValue(orderString, 'method')} ` +
      `outTradeNo=${AlipayManager.queryValue(orderString, 'out_trade_no')}`);
    const result = await new Pay().pay(orderString, true);
    const resultStatus = result.get('resultStatus') ?? '';
    const memo = result.get('memo') ?? '';
    const resultBody = result.get('result') ?? '';
    console.info(`[AlipayManager] pay resultStatus=${resultStatus} memo=${memo} resultLength=${resultBody.length}`);
    if (resultStatus === '9000') {
      return new AlipayLaunchResult(true, '支付成功');
    }
    if (resultStatus === '8000') {
      return new AlipayLaunchResult(true, '支付处理中，请稍后刷新会员状态');
    }
    if (resultStatus === '6001') {
      return new AlipayLaunchResult(false, '支付已取消');
    }
    if (resultStatus === '4000') {
      return new AlipayLaunchResult(false, memo.length > 0 ? memo : '支付失败');
    }
    return new AlipayLaunchResult(true, memo.length > 0 ? memo : '请返回后确认支付结果');
  }

  private static resolveOrderString(orderData: VipOrderData): string {
    return orderData.aliPayOrderString && orderData.aliPayOrderString.length > 0
      ? orderData.aliPayOrderString
      : (orderData.orderString && orderData.orderString.length > 0
        ? orderData.orderString
        : (orderData.alipayOrderString ?? ''));
  }

  private static setupSdkLog(): void {
    if (AlipayManager.didSetupLog) {
      return;
    }
    AlipayManager.didSetupLog = true;
    Log.setupLogCallback((logLine: string) => {
      console.info(`[alipay_sdk] ${logLine}`);
    });
  }

  private static queryValue(orderString: string, key: string): string {
    const prefix = `${key}=`;
    const parts = orderString.split('&');
    for (let index = 0; index < parts.length; index++) {
      const part = parts[index];
      if (part.startsWith(prefix)) {
        return decodeURIComponent(part.substring(prefix.length));
      }
    }
    if (key === 'out_trade_no') {
      const bizContent = AlipayManager.queryValue(orderString, 'biz_content');
      const marker = '"out_trade_no":"';
      const markerIndex = bizContent.indexOf(marker);
      if (markerIndex >= 0) {
        const start = markerIndex + marker.length;
        const end = bizContent.indexOf('"', start);
        return end > start ? bizContent.substring(start, end) : '';
      }
    }
    return '';
  }

  private static safeValue(value: string | undefined): string {
    return value === undefined ? '' : value;
  }
}
