import { SleepColor, SleepRadius, SleepText } from '../../common/SleepDesign';

@Component
export struct ConfirmDialog {
  title: string = '';
  message: string = '';
  confirmText: string = '确定';
  destructive: boolean = false;
  onConfirm: () => void = () => {};
  onCancel: () => void = () => {};

  build() {
    Stack() {
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('#73000000')
        .onClick(this.onCancel)

      Column({ space: 18 }) {
        Text(this.title)
          .fontSize(SleepText.title3)
          .fontWeight(FontWeight.Medium)
          .fontColor(SleepColor.textPrimary)
          .width('100%')

        Text(this.message)
          .fontSize(SleepText.body)
          .fontColor(SleepColor.textSecondary)
          .lineHeight(24)
          .width('100%')

        Row({ space: 12 }) {
          Row() {
            Text('取消')
              .fontSize(SleepText.body)
              .fontColor(SleepColor.textPrimary)
              .textAlign(TextAlign.Center)
          }
          .layoutWeight(1)
          .height(46)
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)
          .backgroundColor(SleepColor.secondaryBackground)
          .borderRadius(SleepRadius.card)
          .onClick(this.onCancel)

          Row() {
            Text(this.confirmText)
              .fontSize(SleepText.body)
              .fontWeight(FontWeight.Medium)
              .fontColor(Color.White)
              .textAlign(TextAlign.Center)
          }
          .layoutWeight(1)
          .height(46)
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)
          .backgroundColor(this.destructive ? SleepColor.destructive : SleepColor.primary)
          .borderRadius(SleepRadius.card)
          .onClick(this.onConfirm)
        }
        .width('100%')
      }
      .width('86%')
      .padding(20)
      .backgroundColor(SleepColor.tertiaryBackground)
      .borderRadius(SleepRadius.modal)
    }
    .width('100%')
    .height('100%')
  }
}
