/**
 * @author liuzheng
 * @mail bryant_liu24@126.com
 */
import { common } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { SleepColor, SleepRadius, SleepText } from '../../common/SleepDesign';

@Component
export struct PrivacyAgreementDialog {
  @Prop isChecked: boolean = false;
  onToggleChecked: () => void = () => {};
  onAgree: () => void = () => {};
  onDisagree: () => void = () => {};
  onOpenUserAgreement: () => void = () => {};
  onOpenPrivacyPolicy: () => void = () => {};

  aboutToAppear(): void {
    this.setSystemBarColors(true);
  }

  aboutToDisappear(): void {
    this.setSystemBarColors(false);
  }

  private async setSystemBarColors(isPrivacyDialog: boolean): Promise<void> {
    try {
      const context = getContext(this) as common.UIAbilityContext;
      const mainWindow = await window.getLastWindow(context);
      await mainWindow.setWindowSystemBarProperties({
        statusBarColor: isPrivacyDialog ? '#8C8C8C' : SleepColor.background,
        statusBarContentColor: isPrivacyDialog ? '#FFFFFF' : SleepColor.textPrimary,
        navigationBarColor: isPrivacyDialog ? '#8C8C8C' : SleepColor.tertiaryBackground,
        navigationBarContentColor: isPrivacyDialog ? '#FFFFFF' : SleepColor.textPrimary
      });
    } catch (_) {
    }
  }

  build() {
    Stack() {
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('#73000000')

      Column({ space: 20 }) {
        Text('个人信息保护')
          .fontSize(SleepText.title3)
          .fontWeight(FontWeight.Medium)
          .fontColor(SleepColor.textPrimary)

        Scroll() {
          Column({ space: 14 }) {
            Text('欢迎使用时光睡眠。我们非常重视您的个人信息与隐私保护。请您在使用前仔细阅读以下协议，了解我们如何为您提供睡眠监测、声音播放、睡眠数据记录等服务。')
              .fontSize(SleepText.body)
              .fontColor(SleepColor.textPrimary)
              .lineHeight(25)

            Row({ space: 0 }) {
              Text('《用户协议》')
                .fontSize(SleepText.body)
                .fontColor('#2563EB')
                .onClick(() => {
                  this.onOpenUserAgreement();
                })
              Text(' 和 ')
                .fontSize(SleepText.body)
                .fontColor(SleepColor.textPrimary)
              Text('《隐私政策》')
                .fontSize(SleepText.body)
                .fontColor('#2563EB')
                .onClick(() => {
                  this.onOpenPrivacyPolicy();
                })
            }

            Text('在您点击“同意并继续”前，我们不会主动请求麦克风等敏感权限，也不会开始睡眠声音监测。')
              .fontSize(SleepText.body)
              .fontColor(SleepColor.textPrimary)
              .lineHeight(25)

            Text('您可以点击上方蓝色协议名称查看完整内容。若您不同意相关条款，将无法继续使用本应用。')
              .fontSize(SleepText.body)
              .fontColor(SleepColor.textPrimary)
              .lineHeight(25)
          }
          .alignItems(HorizontalAlign.Start)
          .width('100%')
        }
        .height(260)
        .width('100%')

        Row({ space: 8 }) {
          Text(this.isChecked ? '✓' : '')
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .width(22)
            .height(22)
            .lineHeight(22)
            .textAlign(TextAlign.Center)
            .backgroundColor(this.isChecked ? SleepColor.primary : '#00000000')
            .border({ width: 1, color: this.isChecked ? SleepColor.primary : SleepColor.textSecondary })
            .borderRadius(4)

          Text('我已阅读并同意《用户协议》和《隐私政策》')
            .fontSize(14)
            .fontColor(SleepColor.textSecondary)
            .layoutWeight(1)
        }
        .width('100%')
        .onClick(() => {
          this.onToggleChecked();
        })

        Button('同意并继续')
          .type(ButtonType.Normal)
          .fontSize(SleepText.body)
          .fontWeight(FontWeight.Medium)
          .fontColor(Color.White)
          .width('100%')
          .height(48)
          .backgroundColor(this.isChecked ? SleepColor.primary : SleepColor.textTertiary)
          .borderRadius(SleepRadius.card)
          .enabled(this.isChecked)
          .onClick(() => {
            if (this.isChecked) {
              this.onAgree();
            }
          })

        Text('不同意')
          .fontSize(SleepText.body)
          .fontColor(SleepColor.textSecondary)
          .onClick(() => {
            this.onDisagree();
          })
      }
      .width('88%')
      .padding(20)
      .backgroundColor(SleepColor.tertiaryBackground)
      .borderRadius(SleepRadius.modal)
    }
    .width('100%')
    .height('100%')
  }
}
