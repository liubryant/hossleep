/**
 * @author liuzheng
 * @mail bryant_liu24@126.com
 */
import { SleepColor, SleepText } from '../../common/SleepDesign';

@Component
export struct CommonNavBar {
  title: string = '';
  onBack: () => void = () => {};

  build() {
    Row() {
      Stack() {
        Image($rawfile('icons_sleep/ic_back_modern.svg'))
          .width(24)
          .height(24)
          .objectFit(ImageFit.Contain)
      }
      .width(44)
      .height(44)
      .align(Alignment.Center)
      .backgroundColor(Color.White)
      .borderRadius(22)
      .shadow({ radius: 5, color: '#12000000', offsetY: 1 })
        .onClick(() => {
          this.onBack();
        })

      Text(this.title)
        .fontSize(SleepText.headline)
        .fontWeight(FontWeight.Medium)
        .fontColor(SleepColor.textPrimary)
        .textAlign(TextAlign.Center)
        .layoutWeight(1)

      Column()
        .width(44)
        .height(44)
    }
    .width('100%')
    .height(54)
    .padding({ left: 6, right: 6 })
    .backgroundColor(SleepColor.background)
  }
}
