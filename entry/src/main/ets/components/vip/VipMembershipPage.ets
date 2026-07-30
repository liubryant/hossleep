/**
 * @author liuzheng
 * @mail bryant_liu24@126.com
 */
import { common } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { AlipayManager } from '../../pay/AlipayManager';
import { PaymentApi } from '../../pay/PaymentApi';
import { MembershipInfo, VipOrderData, VipProduct } from '../../pay/VipProduct';

const VIP_AGREEMENT_URL = 'https://www.cjym123.cn/agreement_agentclaw_vip.html';

@Component
export struct VipMembershipPage {
  @Prop isLoggedIn: boolean = false;
  @Prop phoneNumber: string = '';
  @Prop accessToken: string = '';
  onClose: () => void = () => {};
  onRequireLogin: () => void = () => {};
  onOpenWebView: (url: string, title: string) => void = () => {};
  onMembershipChanged: (active: boolean) => void = () => {};

  @State private products: VipProduct[] = [];
  @State private selectedProductId: string = '';
  @State private statusText: string = '正在加载会员套餐...';
  @State private memberActive: boolean = false;
  @State private memberExpiresAt: string = '';
  @State private isLoadingProducts: boolean = false;
  @State private isLoadingMembership: boolean = false;
  @State private isPaying: boolean = false;
  @State private isAgreementChecked: boolean = false;
  @State private isBenefitsDetailPresented: boolean = false;
  @State private currentOrderId: string = '';
  private orderPollTimer: number = -1;
  private orderPollCount: number = 0;

  aboutToAppear(): void {
    this.setImmersiveMode(true);
    this.reload();
  }

  aboutToDisappear(): void {
    this.stopOrderPolling();
    this.setImmersiveMode(false);
  }

  private async setImmersiveMode(enabled: boolean): Promise<void> {
    try {
      const context = getContext(this) as common.UIAbilityContext;
      const mainWindow = await window.getLastWindow(context);
      await mainWindow.setWindowLayoutFullScreen(enabled);
      await mainWindow.setWindowSystemBarProperties({
        statusBarColor: enabled ? '#00000000' : '#F2F2F7',
        statusBarContentColor: enabled ? '#FFF2D2' : '#111827',
        navigationBarColor: enabled ? '#0D0703' : '#FFFFFF',
        navigationBarContentColor: enabled ? '#FFF2D2' : '#111827'
      });
    } catch (_) {
    }
  }

  private reload(): void {
    this.loadProducts();
    this.loadMembershipStatus();
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
        this.header()

        Scroll() {
          Column({ space: 14 }) {
            this.userInfo()
            this.benefitsBand()
            this.productSection()
            this.paymentMethodSection()
            this.tipsSection()
          }
          .width('100%')
          .padding({ left: 13, right: 13, top: 8, bottom: 18 })
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)

        this.bottomPayBar()
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#0D0703')

      if (this.isBenefitsDetailPresented) {
        this.benefitsDetailOverlay()
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#0D0703')
  }

  @Builder
  private header() {
    Row({ space: 8 }) {
      Row() {
        Image($rawfile('icons_sleep/ic_vip_back_gold.svg'))
          .width(20)
          .height(20)
          .objectFit(ImageFit.Contain)
      }
      .width(44)
      .height(44)
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .onClick(() => {
        this.onClose();
      })

      Text('VIP 会员')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontFamily('MiSans-DemiBold')
        .fontColor('#FFEDBD')
        .layoutWeight(1)
        .textAlign(TextAlign.Center)

      Blank().width(44)
    }
    .width('100%')
    .height(98)
    .padding({ left: 4, right: 4, top: 48, bottom: 6 })
    .zIndex(30)
  }

  @Builder
  private userInfo() {
    Row({ space: 12 }) {
      Column() {
        Text('VIP')
          .fontSize(11)
          .fontWeight(FontWeight.Bold)
          .fontColor('#3A220D')
      }
      .width(36)
      .height(36)
      .borderRadius(18)
      .justifyContent(FlexAlign.Center)
      .linearGradient({
        angle: 135,
        colors: [['#FFF2BC', 0], ['#D9A64C', 1]] as [string, number][]
      })

      Column({ space: 4 }) {
        Text(this.userTitle())
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontFamily('MiSans-DemiBold')
          .fontColor(Color.White)
        Text(this.memberSubtitle())
          .fontSize(13)
          .fontColor('#FFEDBD')
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      if (!this.isLoggedIn) {
        Text('去登录')
          .fontSize(12)
          .fontWeight(FontWeight.Bold)
          .fontColor('#864F2D')
          .textAlign(TextAlign.Center)
          .padding({ left: 18, right: 18 })
          .height(28)
          .borderRadius(14)
          .linearGradient({
            angle: 0,
            colors: [['#FEEBB9', 0], ['#D9A64C', 1]] as [string, number][]
          })
          .onClick(() => {
            this.onRequireLogin();
          })
      }
    }
    .width('100%')
    .padding({ left: 12, right: 12, top: 8, bottom: 8 })
  }

  private userTitle(): string {
    const phone = this.phoneNumber;
    if (this.isLoggedIn && phone.length === 11) {
      return `${phone.substring(0, 3)}****${phone.substring(7)}`;
    }
    if (this.isLoggedIn && phone.length > 0) {
      return phone;
    }
    return '登录后开通会员';
  }

  @Builder
  private benefitsBand() {
    Column({ space: 12 }) {
      Text('会员权益')
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor('#FFEDBD')
        .width('100%')
        .textAlign(TextAlign.Center)
        .margin({ top: 16 })
      Text('查看套餐详情  ›')
        .fontSize(11)
        .fontColor('#CDAF7A')
        .width('100%')
        .textAlign(TextAlign.Center)

      Row() {
        this.benefitItem('♫', '全部会员\n专享声音')
        this.benefitItem('⇩', '会员资源\n本地下载')
        this.benefitItem('∞', '会员期内\n无限畅听')
      }
      .width('100%')
      .margin({ top: 4 })
    }
    .width('100%')
    .padding({ left: 12, right: 12, bottom: 20 })
    .borderRadius(16)
    .linearGradient({
      angle: 135,
      colors: [['#2B211A', 0], ['#3D2B1F', 0.55], ['#211914', 1]] as [string, number][]
    })
    .border({ width: 1, color: '#6F5133' })
    .onClick(() => {
      this.isBenefitsDetailPresented = true;
    })
  }

  @Builder
  private benefitItem(icon: string, title: string) {
    Column({ space: 8 }) {
      Column() {
        Text(icon)
          .fontSize(18)
          .fontColor('#864F2D')
      }
      .width(36)
      .height(36)
      .borderRadius(18)
      .justifyContent(FlexAlign.Center)
      .backgroundColor('#FEEBB9')

      Text(title)
        .fontSize(12)
        .fontColor(Color.White)
    }
    .layoutWeight(1)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  private productSection() {
    Column({ space: 8 }) {
      Scroll() {
        Row({ space: 10 }) {
          if (this.isLoadingProducts) {
            Text('会员套餐\n\n加载中...')
              .fontSize(13)
              .fontColor('#CDAF7A')
              .width(132)
              .height(142)
              .textAlign(TextAlign.Center)
              .backgroundColor('#1A1512')
              .borderRadius(10)
          } else if (this.products.length === 0) {
            Text('暂无可购买的会员套餐')
              .fontSize(13)
              .fontColor('#CDAF7A')
              .width(180)
              .height(142)
              .textAlign(TextAlign.Center)
              .backgroundColor('#1A1512')
              .borderRadius(10)
          } else {
            ForEach(this.products, (product: VipProduct, index: number) => {
              this.productCard(product, index)
            }, (product: VipProduct) => product.id)
          }
        }
        .padding({ left: 0, right: 0, top: 8, bottom: 8 })
      }
      .width('100%')
      .height(164)
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)

      Text(this.statusText)
        .fontSize(12)
        .fontColor('#999999')
        .textAlign(TextAlign.Center)
        .width('100%')
    }
    .width('100%')
  }

  private memberSubtitle(): string {
    if (this.memberActive && this.memberExpiresAt.length > 0) {
      return `有效期至 ${this.memberExpiresAt}`;
    }
    if (this.memberActive) {
      return '会员已开通，可继续续费';
    }
    return this.isLoggedIn ? '解锁全部助眠声音、故事与睡眠报告' : '登录后开通会员';
  }

  @Builder
  private productCard(product: VipProduct, index: number) {
    Stack({ alignContent: Alignment.Top }) {
      Column({ space: 9 }) {
        Text(`￥${product.price}`)
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.selectedProductId === product.id ? '#864F2D' : '#EBC783')
          .width('100%')
          .textAlign(TextAlign.Center)

        Text(product.name)
          .fontSize(12)
          .fontWeight(FontWeight.Medium)
          .fontColor(this.selectedProductId === product.id ? '#6B3820' : '#B6A58E')
          .width('100%')
          .textAlign(TextAlign.Center)

        Text(product.description.length > 0 ? product.description : this.badgeText(index))
          .fontSize(10)
          .fontColor(this.selectedProductId === product.id ? '#9B5C38' : '#7A6B58')
          .width('100%')
          .textAlign(TextAlign.Center)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .width('100%')
      .height(142)
      .margin({ top: 16 })
      .padding({ left: 10, right: 10, top: 20, bottom: 14 })
      .justifyContent(FlexAlign.Center)
      .borderRadius(10)
      .linearGradient(this.selectedProductId === product.id ? {
        angle: 270,
        colors: [['#FDE9B5', 0], ['#D7A24C', 1]] as [string, number][]
      } : {
        angle: 0,
        colors: [['#1A1512', 0], ['#1A1512', 1]] as [string, number][]
      })
      .border({ width: this.selectedProductId === product.id ? 2 : 1, color: this.selectedProductId === product.id ? '#EBC783' : '#514437' })

      Text(this.badgeText(index))
        .fontSize(10)
        .fontWeight(FontWeight.Medium)
        .fontColor(Color.White)
        .height(22)
        .padding({ left: 12, right: 12 })
        .linearGradient({
          angle: 90,
          colors: [[this.badgeStartColor(index), 0], [this.badgeEndColor(index), 1]] as [string, number][]
        })
        .borderRadius(11)
        .shadow({ radius: 3, color: 'rgba(0,0,0,0.22)', offsetX: 0, offsetY: 1 })
        .margin({ top: 4 })
    }
    .width(138)
    .height(164)
    .onClick(() => {
      this.selectedProductId = product.id;
      this.statusText = this.memberActive ? '会员已开通，可继续续费' : '请选择套餐并支付';
    })
  }

  private badgeText(index: number): string {
    if (index === 0) {
      return '限时特惠';
    }
    if (index === 1) {
      return '超值特惠';
    }
    return '80%用户选择';
  }

  private badgeStartColor(index: number): string {
    if (index === 0) {
      return '#9C27B0';
    }
    if (index === 1) {
      return '#FFB300';
    }
    return '#FF6B35';
  }

  private badgeEndColor(index: number): string {
    if (index === 0) {
      return '#6A1B9A';
    }
    if (index === 1) {
      return '#F57C00';
    }
    return '#E53935';
  }

  @Builder
  private paymentMethodSection() {
    Column({ space: 12 }) {
      Row({ space: 10 }) {
        Divider().width(20).strokeWidth(1).color('#DCDCDC')
        Text('支付方式')
          .fontSize(12)
          .fontColor('#999999')
        Divider().width(20).strokeWidth(1).color('#DCDCDC')
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .margin({ top: 4 })

      Stack({ alignContent: Alignment.TopEnd }) {
        Row({ space: 7 }) {
          Text('支')
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .textAlign(TextAlign.Center)
            .width(24)
            .height(24)
            .backgroundColor('#1677FF')
            .borderRadius(4)

          Text('支付宝支付')
            .fontSize(14)
            .fontColor('#FEEBB9')
        }
        .width('100%')
        .height(56)
        .justifyContent(FlexAlign.Center)
        .backgroundColor('#2B211A')
        .borderRadius(12)
        .border({ width: 1, color: '#6F5133' })

        Text('✓')
          .fontSize(10)
          .fontColor('#864F2D')
          .textAlign(TextAlign.Center)
          .width(22)
          .height(18)
          .backgroundColor('#FEEBB9')
          .borderRadius({ topRight: 12, bottomLeft: 8 })
      }
      .width('100%')
    }
    .width('100%')
    .padding({ left: 3, right: 3 })
  }

  @Builder
  private benefitsDetailOverlay() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0,0,0,0.55)')
        .onClick(() => {
          this.isBenefitsDetailPresented = false;
        })

      Column({ space: 0 }) {
        Column()
          .width(36)
          .height(4)
          .backgroundColor('#3D2D1E')
          .borderRadius(2)
          .margin({ top: 10 })

        Column({ space: 6 }) {
          Column() {
            Text('♛')
              .fontSize(25)
              .fontColor('#3A220D')
          }
          .width(44)
          .height(44)
          .borderRadius(22)
          .justifyContent(FlexAlign.Center)
          .linearGradient({
            angle: 135,
            colors: [['#FFF2BC', 0], ['#D9A64C', 1]] as [string, number][]
          })

          Text('会员套餐详情')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontFamily('MiSans-DemiBold')
            .fontColor('#FFEDBD')

          Text('解锁会员专享声音，支持下载后随时畅听')
            .fontSize(13)
            .fontColor('#9C8A75')
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
        .padding({ top: 18, bottom: 4 })

        Row({ space: 16 }) {
          this.accessCard(
            '♫ 声音内容',
            '普通用户',
            '免费声音',
            'VIP 会员',
            '全部会员声音'
          )
          this.accessCard(
            '⇩ 本地下载',
            '普通用户',
            '免费资源',
            'VIP 会员',
            '会员资源可下载'
          )
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 20 })

        Divider()
          .color('#1E1510')
          .strokeWidth(1)
          .margin({ left: 16, right: 16, top: 20 })

        Row() {
          this.detailBenefitItem('♫', '会员专享声音')
          this.detailBenefitItem('⇩', '下载后播放')
          this.detailBenefitItem('∞', '会员期内畅听')
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 16 })

        Column({ space: 10 }) {
          Text('选择会员套餐')
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFEDBD')
            .width('100%')
            .margin({ left: 4 })

          Scroll() {
            Row({ space: 10 }) {
              if (this.products.length === 0) {
                Text('暂无可购买的会员套餐')
                  .fontSize(12)
                  .fontColor('#988571')
                  .width(240)
                  .height(86)
                  .textAlign(TextAlign.Center)
              } else {
                ForEach(this.products, (product: VipProduct) => {
                  this.detailProductCard(product)
                }, (product: VipProduct) => product.id)
              }
            }
            .padding({ left: 0, right: 0 })
          }
          .width('100%')
          .height(96)
          .scrollable(ScrollDirection.Horizontal)
          .scrollBar(BarState.Off)
        }
        .width('100%')
        .padding({ left: 14, right: 14, top: 18 })

        Text(this.payButtonText())
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#864F2D')
          .textAlign(TextAlign.Center)
          .width('100%')
          .height(52)
          .borderRadius(26)
          .margin({ left: 24, right: 24, top: 22 })
          .linearGradient({
            angle: 0,
            colors: [['#FFFEEBB9', 0], ['#FFFFD889', 1]] as [string, number][]
          })
          .opacity(this.selectedProduct() === null ? 0.5 : 1)
          .onClick(() => {
            if (this.selectedProduct() !== null) {
              this.isBenefitsDetailPresented = false;
              this.startPayment();
            }
          })

        Text('关闭')
          .fontSize(14)
          .fontColor('#666666')
          .textAlign(TextAlign.Center)
          .width('100%')
          .height(44)
          .onClick(() => {
            this.isBenefitsDetailPresented = false;
          })
      }
      .width('100%')
      .padding({ bottom: 32 })
      .borderRadius({ topLeft: 22, topRight: 22 })
      .linearGradient({
        angle: 180,
        colors: [['#20160F', 0], ['#120B07', 1]] as [string, number][]
      })
    }
    .width('100%')
    .height('100%')
    .zIndex(20)
  }

  @Builder
  private accessCard(title: string, freeLabel: string, freeValue: string, vipLabel: string, vipValue: string) {
    Column({ space: 8 }) {
      Text(title)
        .fontSize(12)
        .fontWeight(FontWeight.Bold)
        .fontColor('#CDAF7A')
        .width('100%')

      this.quotaLimitRow(freeLabel, freeValue, '#77706A', FontWeight.Normal)
      this.quotaLimitRow(vipLabel, vipValue, '#CDAF7A', FontWeight.Bold)
    }
    .layoutWeight(1)
    .padding(14)
    .borderRadius(12)
    .backgroundColor('#1A120D')
    .border({ width: 1, color: '#3B2A1B' })
  }

  @Builder
  private quotaLimitRow(label: string, value: string, color: string, weight: FontWeight) {
    Row() {
      Text(label)
        .fontSize(11)
        .fontColor(color)
        .fontWeight(weight)
        .layoutWeight(1)
      Text(value)
        .fontSize(11)
        .fontColor(color)
        .fontWeight(weight)
    }
    .width('100%')
  }

  @Builder
  private detailBenefitItem(icon: string, title: string) {
    Column({ space: 6 }) {
      Text(icon)
        .fontSize(18)
        .fontColor('#CDAF7A')
      Text(title)
        .fontSize(12)
        .fontColor('#B8A48A')
    }
    .layoutWeight(1)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  private detailProductCard(product: VipProduct) {
    Column({ space: 5 }) {
      Row({ space: 7 }) {
        Text(this.selectedProductId === product.id ? '✓' : '○')
          .fontSize(18)
          .fontColor(this.selectedProductId === product.id ? '#F6D28F' : '#6E5C4B')
          .width(24)
          .textAlign(TextAlign.Center)

        Text(product.name)
          .fontSize(13)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .layoutWeight(1)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .width('100%')

      Text(`￥${product.price}`)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#F6D28F')
        .width('100%')
        .padding({ left: 31 })

      if (product.description.length > 0) {
        Text(product.description)
          .fontSize(10)
          .fontColor('#988571')
          .width('100%')
          .padding({ left: 31 })
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
    }
    .width(164)
    .height(86)
    .padding({ left: 12, right: 12, top: 8, bottom: 8 })
    .justifyContent(FlexAlign.Center)
    .backgroundColor(this.selectedProductId === product.id ? '#3A291B' : '#21160F')
    .border({
      width: this.selectedProductId === product.id ? 2 : 1,
      color: this.selectedProductId === product.id ? '#D3A85F' : '#483322'
    })
    .borderRadius(12)
    .onClick(() => {
      this.selectedProductId = product.id;
      this.statusText = this.memberActive ? '会员已开通，可继续续费' : '请选择套餐并支付';
    })
  }

  @Builder
  private tipsSection() {
    Column({ space: 4 }) {
      Text('温馨提示')
        .fontSize(12)
        .fontWeight(FontWeight.Bold)
        .fontColor('#999999')
      Text('1. 会员服务开通后立即生效。\n2. 支付完成后以服务端订单状态为准。\n3. 如遇支付异常，请稍后重新进入会员页查看。')
        .fontSize(12)
        .fontColor('#666666')
        .lineHeight(19)
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .padding({ left: 3, right: 3, bottom: 4 })
  }

  @Builder
  private bottomPayBar() {
    Column({ space: 6 }) {
      Text(this.payButtonText())
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#3A220D')
        .textAlign(TextAlign.Center)
        .width('100%')
        .height(50)
        .backgroundColor(this.canPay() ? '#FEEBB9' : 'rgba(254,235,185,0.45)')
        .borderRadius(12)
        .onClick(() => {
          this.startPayment();
        })

      Row({ space: 6 }) {
        Text(this.isAgreementChecked ? '✓' : '')
          .fontSize(11)
          .fontColor('#864F2D')
          .textAlign(TextAlign.Center)
          .width(18)
          .height(18)
          .backgroundColor(this.isAgreementChecked ? '#FEEBB9' : Color.Transparent)
          .borderRadius(4)
          .border({ width: 1, color: '#999999' })
          .onClick(() => {
            this.isAgreementChecked = !this.isAgreementChecked;
          })

        Text('我已阅读并同意')
          .fontSize(12)
          .fontColor('#999999')

        Text('《会员服务协议》')
          .fontSize(12)
          .fontColor('#999999')
          .onClick(() => {
            this.onOpenWebView(VIP_AGREEMENT_URL, '会员服务协议');
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .padding({ left: 28, right: 28, top: 7, bottom: 10 })
    .backgroundColor('#0D0703')
  }

  private payButtonText(): string {
    if (!this.isLoggedIn) {
      return '登录后开通会员';
    }
    if (this.isPaying) {
      return '支付处理中...';
    }
    const product = this.selectedProduct();
    if (product === null) {
      return '请选择会员套餐';
    }
    return `￥${product.price}  ${this.memberActive ? '立即续费' : '立即开通会员'}`;
  }

  private canPay(): boolean {
    return !this.isPaying && this.products.length > 0;
  }

  private selectedProduct(): VipProduct | null {
    const found = this.products.find((item: VipProduct): boolean => item.id === this.selectedProductId);
    return found === undefined ? null : found;
  }

  private loadProducts(): void {
    this.isLoadingProducts = true;
    PaymentApi.shared.getProducts()
      .then((items: VipProduct[]) => {
        this.products = items;
        if (this.selectedProductId.length === 0 && items.length > 0) {
          this.selectedProductId = items[0].id;
        }
        if (!this.memberActive) {
          this.statusText = items.length > 0 ? '请选择套餐并支付' : '暂无可购买的会员套餐';
        }
      })
      .catch((error: Error) => {
        this.statusText = error.message && error.message.length > 0 ? error.message : '会员套餐加载失败';
        this.products = [];
      })
      .finally(() => {
        this.isLoadingProducts = false;
      });
  }

  private loadMembershipStatus(): void {
    const token = this.accessToken;
    if (token.length === 0) {
      this.memberActive = false;
      this.onMembershipChanged(false);
      this.memberExpiresAt = '';
      return;
    }
    this.isLoadingMembership = true;
    PaymentApi.shared.getMembership(token)
      .then((info: MembershipInfo) => {
        this.memberActive = info.active;
        this.onMembershipChanged(info.active);
        this.memberExpiresAt = info.expiresAt ?? '';
        if (info.active) {
          this.statusText = '会员已开通，可继续续费';
        }
      })
      .catch((error: Error) => {
        if (this.products.length === 0) {
          this.statusText = error.message;
        }
      })
      .finally(() => {
        this.isLoadingMembership = false;
      });
  }

  private startPayment(): void {
    if (this.isPaying) {
      return;
    }
    if (!this.isLoggedIn || this.accessToken.length === 0) {
      this.onRequireLogin();
      return;
    }
    if (!this.isAgreementChecked) {
      AlertDialog.show({
        title: '提示',
        message: '开通会员前，请先阅读并同意《会员服务协议》。',
        confirm: {
          value: '知道了',
          action: () => {}
        }
      });
      return;
    }
    const product = this.selectedProduct();
    if (product === null) {
      this.statusText = '请先选择会员套餐';
      return;
    }

    const token = this.accessToken;
    this.isPaying = true;
    this.statusText = '正在创建安全支付订单...';
    PaymentApi.shared.createOrder(token, product.id)
      .then((data: VipOrderData) => {
        const orderId = data.orderId && data.orderId.length > 0 ? data.orderId : (data.id ?? '');
        if (orderId.length === 0) {
          this.isPaying = false;
          this.statusText = '订单创建失败，请重试';
          return;
        }
        this.currentOrderId = orderId;
        if (data.mock === true) {
          this.statusText = '本地模拟支付完成，正在确认会员状态...';
          this.startOrderPolling();
          return;
        }
        const context = getContext(this) as common.UIAbilityContext;
        AlipayManager.pay(context, data)
          .then((result) => {
            if (!result.launched) {
              this.isPaying = false;
              this.statusText = result.message;
              return;
            }
            this.statusText = result.message;
            this.startOrderPolling();
          })
          .catch((error: Error) => {
            this.isPaying = false;
            this.statusText = error.message && error.message.length > 0 ? error.message : '支付宝未能启动，请重试';
          });
      })
      .catch((error: Error) => {
        this.isPaying = false;
        this.statusText = error.message && error.message.length > 0 ? error.message : '创建订单失败';
      });
  }

  private startOrderPolling(): void {
    if (this.currentOrderId.length === 0) {
      this.isPaying = false;
      return;
    }
    this.stopOrderPolling();
    this.orderPollCount = 0;
    this.orderPollTimer = setInterval(() => {
      this.orderPollCount += 1;
      this.queryCurrentOrder();
      if (this.orderPollCount >= 6) {
        this.stopOrderPolling();
        this.isPaying = false;
        this.statusText = '订单处理中，请稍后重新进入页面查看';
      }
    }, 1500) as number;
  }

  private stopOrderPolling(): void {
    if (this.orderPollTimer >= 0) {
      clearInterval(this.orderPollTimer);
      this.orderPollTimer = -1;
    }
  }

  private queryCurrentOrder(): void {
    const token = this.accessToken;
    if (token.length === 0 || this.currentOrderId.length === 0) {
      return;
    }
    PaymentApi.shared.queryOrder(token, this.currentOrderId)
      .then((data: VipOrderData) => {
        const status = (data.status ?? '').toLowerCase();
        if (status === 'paid' || status === 'success') {
          this.stopOrderPolling();
          this.isPaying = false;
          this.memberActive = true;
          this.onMembershipChanged(true);
          this.statusText = '支付成功，会员已开通';
          this.loadMembershipStatus();
        }
      })
      .catch(() => {
        if (this.orderPollCount >= 6) {
          this.statusText = '暂时无法确认订单，请稍后查看';
        }
      });
  }
}
