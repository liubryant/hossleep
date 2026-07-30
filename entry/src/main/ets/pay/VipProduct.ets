/**
 * @author liuzheng
 * @mail bryant_liu24@126.com
 */

export interface VipProductJson {
  id?: string;
  name?: string;
  price?: string | number;
  description?: string;
}

export class VipProduct {
  id: string;
  name: string;
  price: string;
  description: string;

  constructor(id: string, name: string, price: string, description: string) {
    this.id = id;
    this.name = name;
    this.price = price;
    this.description = description;
  }

  static from(json: VipProductJson): VipProduct {
    return new VipProduct(
      json.id ?? '',
      json.name ?? '会员套餐',
      json.price === undefined ? '' : `${json.price}`,
      json.description ?? ''
    );
  }
}

export interface MembershipInfoJson {
  active?: boolean;
  isVip?: boolean;
  isMember?: boolean;
  expiresAt?: string;
  expireDate?: string;
  quota?: VipQuotaJson;
}

export interface VipQuotaJson {
  freeVideoDaily?: number | string;
  freeImageDaily?: number | string;
  vipVideoDaily?: number | string;
  vipImageDaily?: number | string;
}

export class MembershipInfo {
  active: boolean;
  expiresAt: string | null;

  constructor(active: boolean, expiresAt: string | null) {
    this.active = active;
    this.expiresAt = expiresAt;
  }

  static from(json: MembershipInfoJson): MembershipInfo {
    const active = (json.active ?? false) || (json.isVip ?? false) || (json.isMember ?? false);
    const expiresAt = json.expiresAt && json.expiresAt.length > 0
      ? json.expiresAt
      : (json.expireDate && json.expireDate.length > 0 ? json.expireDate : null);
    return new MembershipInfo(active, expiresAt);
  }
}

export interface VipOrderData {
  orderId?: string;
  id?: string;
  mock?: boolean;
  aliPayOrderString?: string;
  alipayOrderString?: string;
  orderString?: string;
  payUrl?: string;
  paymentUrl?: string;
  cashierUrl?: string;
  h5Url?: string;
  status?: string;
}
