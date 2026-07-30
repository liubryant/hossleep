/**
 * @author liuzheng
 * @mail bryant_liu24@126.com
 */
import { SleepColor } from '../../common/SleepDesign';

@Component
export struct StartupGatePage {
  build() {
    Column()
      .width('100%')
      .height('100%')
      .backgroundColor(SleepColor.tertiaryBackground)
  }
}
