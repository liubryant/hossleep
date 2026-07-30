import { http } from '@kit.NetworkKit';
import { MembershipInfo, MembershipInfoJson, VipOrderData, VipProduct, VipProductJson } from './VipProduct';

const BASE_URL: string = 'https://www.cjym123.cn/im/bot/navi/vip';
const ALIPAY_APP_ID: string = '2021006169619056';

interface ProductListData {
  list?: VipProductJson[];
  products?: VipProductJson[];
  items?: VipProductJson[];
}

type ApiData = VipProductJson[] | ProductListData | MembershipInfoJson | VipOrderData;

interface ApiResponse {
  code?: number | string;
  msg?: string;
  data?: ApiData;
}

export class PaymentApi {
  private static instance: PaymentApi | null = null;

  static get shared(): PaymentApi {
    if (PaymentApi.instance === null) {
      PaymentApi.instance = new PaymentApi();
    }
    return PaymentApi.instance;
  }

  async getProducts(): Promise<VipProduct[]> {
    const response = await this.request('/products');
    const data = response.data;
    let list: VipProductJson[] = [];
    if (Array.isArray(data)) {
      list = data as VipProductJson[];
    } else if (data !== undefined) {
      const wrapped = data as ProductListData;
      list = wrapped.list ?? wrapped.products ?? wrapped.items ?? [];
    }
    return list.map((item: VipProductJson): VipProduct => VipProduct.from(item))
      .filter((item: VipProduct): boolean => item.id.length > 0);
  }

  async getMembership(accessToken: string): Promise<MembershipInfo> {
    const response = await this.request('/membership', accessToken);
    return MembershipInfo.from((response.data ?? {}) as MembershipInfoJson);
  }

  async createOrder(accessToken: string, productId: string): Promise<VipOrderData> {
    return (await this.request('/orders', accessToken, JSON.stringify({
      productId: productId,
      payChannel: 'alipay',
      appid: ALIPAY_APP_ID,
      platform: 'harmony'
    }))).data as VipOrderData ?? {};
  }

  async queryOrder(accessToken: string, orderId: string): Promise<VipOrderData> {
    return (await this.request(`/orders/${orderId}`, accessToken)).data as VipOrderData ?? {};
  }

  private async request(path: string, token: string = '', body: string = ''): Promise<ApiResponse> {
    const client = http.createHttp();
    const headers: Record<string, string> = {};
    if (token.length > 0) {
      headers['Authorization'] = `Bearer ${token}`;
    }
    if (body.length > 0) {
      headers['Content-Type'] = 'application/json';
    }
    try {
      const response = await client.request(`${BASE_URL}${path}`, {
        method: body.length > 0 ? http.RequestMethod.POST : http.RequestMethod.GET,
        header: headers,
        extraData: body,
        connectTimeout: 20000,
        readTimeout: 20000
      });
      if (response.responseCode < 200 || response.responseCode >= 300) {
        throw new Error('网络异常，请稍后重试');
      }
      const parsed = JSON.parse(response.result as string) as ApiResponse;
      if (parsed.code !== 0 && parsed.code !== '0') {
        throw new Error(parsed.msg ?? '会员请求失败');
      }
      return parsed;
    } finally {
      client.destroy();
    }
  }
}
