import { SleepColor } from '../../common/SleepDesign';
import { AuthService, LoginResult } from '../../services/AuthService';

@Component
export struct LoginPage {
  @Prop mode: number = 0;
  onBack: () => void = () => {};
  onSwitchMode: () => void = () => {};
  onLoginSuccess: (phone: string, accessToken: string) => void = () => {};
  onOpenLegal: (type: string) => void = () => {};

  @State private phone: string = '';
  @State private code: string = '';
  @State private password: string = '';
  @State private agreementChecked: boolean = false;
  @State private countdown: number = 0;
  @State private busy: boolean = false;
  @State private message: string = '';

  build() {
    Stack() {
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('#1A000000')

      Column({ space: 0 }) {
        Row() {
          Column({ space: 6 }) {
            Text('登录')
              .fontFamily('MiSans-DemiBold')
              .fontSize(22)
              .fontColor(SleepColor.textPrimary)
            Text(this.mode === 1 ? '使用手机号和验证码登录' : '使用手机号和密码登录')
              .fontFamily('MiSans')
              .fontSize(13)
              .fontColor(SleepColor.textSecondary)
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)

          Text('×')
            .fontFamily('MiSans')
            .fontSize(25)
            .fontColor('#111111')
            .width(34)
            .height(34)
            .textAlign(TextAlign.Center)
            .onClick(() => this.onBack())
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)

        TextInput({ text: this.phone, placeholder: '请输入手机号' })
          .type(InputType.PhoneNumber)
          .maxLength(11)
          .fontFamily('MiSans')
          .fontSize(14)
          .fontColor(SleepColor.textPrimary)
          .placeholderColor('#A6A6A6')
          .height(46)
          .width('100%')
          .padding({ left: 14, right: 14 })
          .margin({ top: 22 })
          .backgroundColor('#F8FAFD')
          .border({ width: 1, color: '#D6DCE7' })
          .borderRadius(12)
          .onChange((value: string) => {
            this.phone = value;
            this.message = '';
          })

        if (this.mode === 1) {
          Row() {
            TextInput({ text: this.code, placeholder: '请输入验证码' })
              .type(InputType.Number)
              .maxLength(6)
              .fontFamily('MiSans')
              .fontSize(14)
              .fontColor(SleepColor.textPrimary)
              .placeholderColor('#A6A6A6')
              .height(44)
              .layoutWeight(1)
              .padding({ left: 14, right: 8 })
              .backgroundColor(Color.Transparent)
              .onChange((value: string) => {
                this.code = value;
                this.message = '';
              })

            Text(this.countdown > 0 ? `${this.countdown}秒` : '获取验证码')
              .fontFamily('MiSans-DemiBold')
              .fontSize(13)
              .fontColor(this.countdown > 0 ? '#A6A6A6' : '#3978F3')
              .height(34)
              .constraintSize({ minWidth: 72 })
              .padding({ left: 10, right: 10 })
              .textAlign(TextAlign.Center)
              .backgroundColor(Color.White)
              .border({ width: 1, color: this.countdown > 0 ? '#D6DCE7' : '#3978F3' })
              .borderRadius(9)
              .margin({ right: 6 })
              .onClick(() => this.sendCode())
          }
          .width('100%')
          .height(46)
          .margin({ top: 12 })
          .alignItems(VerticalAlign.Center)
          .backgroundColor('#F8FAFD')
          .border({ width: 1, color: '#D6DCE7' })
          .borderRadius(12)
        } else {
          TextInput({ text: this.password, placeholder: '请输入密码' })
            .type(InputType.Password)
            .fontFamily('MiSans')
            .fontSize(14)
            .fontColor(SleepColor.textPrimary)
            .placeholderColor('#A6A6A6')
            .height(46)
            .width('100%')
            .padding({ left: 14, right: 14 })
            .margin({ top: 12 })
            .backgroundColor('#F8FAFD')
            .border({ width: 1, color: '#D6DCE7' })
            .borderRadius(12)
            .onChange((value: string) => {
              this.password = value;
              this.message = '';
            })
        }

        if (this.message.length > 0) {
          Text(this.message)
            .fontFamily('MiSans')
            .fontSize(12)
            .fontColor('#C2410C')
            .width('100%')
            .margin({ top: 8 })
        }

        Button(this.busy ? '登录中…' : '登录')
          .type(ButtonType.Normal)
          .fontFamily('MiSans-DemiBold')
          .fontSize(15)
          .fontColor(Color.White)
          .width('100%')
          .height(46)
          .margin({ top: 20 })
          .linearGradient({
            angle: 0,
            colors: this.busy
              ? [['#8B919E', 0], ['#A0A6B1', 1]] as [string, number][]
              : [['#171A24', 0], ['#35405A', 1]] as [string, number][]
          })
          .borderRadius(12)
          .enabled(!this.busy)
          .onClick(() => this.login())

        Text(this.mode === 1 ? '使用密码登录' : '使用验证码登录')
          .fontFamily('MiSans')
          .fontSize(13)
          .fontColor(SleepColor.textSecondary)
          .padding(4)
          .margin({ top: 8 })
          .alignSelf(ItemAlign.Center)
          .onClick(() => {
            this.message = '';
            this.onSwitchMode();
          })

        Row({ space: 6 }) {
          Text(this.agreementChecked ? '✓' : '')
            .fontFamily('MiSans-DemiBold')
            .fontSize(11)
            .fontColor(Color.White)
            .width(16)
            .height(16)
            .lineHeight(16)
            .textAlign(TextAlign.Center)
            .backgroundColor(this.agreementChecked ? '#3978F3' : Color.Transparent)
            .border({ width: 1, color: this.agreementChecked ? '#3978F3' : '#9CA3AF' })
            .borderRadius(2)

          Row({ space: 0 }) {
            Text('我已阅读并同意')
              .fontFamily('MiSans')
              .fontSize(12)
              .fontColor(SleepColor.textSecondary)
            Text('《用户协议》')
              .fontFamily('MiSans')
              .fontSize(12)
              .fontColor('#3978F3')
              .onClick(() => this.onOpenLegal('user'))
            Text('和')
              .fontFamily('MiSans')
              .fontSize(12)
              .fontColor(SleepColor.textSecondary)
            Text('《隐私政策》')
              .fontFamily('MiSans')
              .fontSize(12)
              .fontColor('#3978F3')
              .onClick(() => this.onOpenLegal('privacy'))
          }
        }
        .width('100%')
        .margin({ top: 12 })
        .alignItems(VerticalAlign.Center)
        .onClick(() => {
          this.agreementChecked = !this.agreementChecked;
        })
      }
      .width('92%')
      .padding({ left: 28, right: 28, top: 24, bottom: 24 })
      .backgroundColor(Color.White)
      .borderRadius(16)
      .shadow({ radius: 18, color: '#26000000', offsetY: 6 })
    }
    .width('100%')
    .height('100%')
  }

  private validPhone(): boolean {
    return /^1[3-9]\d{9}$/.test(this.phone);
  }

  private async sendCode(): Promise<void> {
    if (this.countdown > 0 || this.busy) {
      return;
    }
    if (!this.validPhone()) {
      this.message = '请输入正确的11位手机号';
      return;
    }
    this.busy = true;
    try {
      await AuthService.requestVerificationCode(this.phone);
      this.message = '验证码已发送';
      this.countdown = 60;
      this.tickCountdown();
    } catch (error) {
      this.message = `${error}`;
    } finally {
      this.busy = false;
    }
  }

  private tickCountdown(): void {
    if (this.countdown <= 0) {
      return;
    }
    setTimeout(() => {
      this.countdown--;
      this.tickCountdown();
    }, 1000);
  }

  private async login(): Promise<void> {
    if (this.busy) {
      return;
    }
    if (!this.validPhone()) {
      this.message = '请输入正确的11位手机号';
      return;
    }
    if (!this.agreementChecked) {
      this.message = '请先阅读并同意用户协议和隐私政策';
      return;
    }
    if ((this.mode === 1 && this.code.length < 4) || (this.mode === 0 && this.password.length < 6)) {
      this.message = this.mode === 1 ? '请输入正确的验证码' : '密码至少为6位';
      return;
    }
    this.busy = true;
    try {
      let result: LoginResult;
      if (this.mode === 1) {
        result = await AuthService.loginByCode(this.phone, this.code);
      } else {
        result = await AuthService.loginByPassword(this.phone, this.password);
      }
      this.onLoginSuccess(result.phone, result.accessToken);
    } catch (error) {
      this.message = `${error}`;
    } finally {
      this.busy = false;
    }
  }
}
