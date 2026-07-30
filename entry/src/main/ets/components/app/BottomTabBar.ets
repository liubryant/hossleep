/**
 * @author liuzheng
 * @mail bryant_liu24@126.com
 */
import { SleepColor } from '../../common/SleepDesign';

interface SleepTab {
  title: string;
}

const TABS: SleepTab[] = [
  { title: '声音' },
  { title: '睡眠' },
  { title: '故事' },
  { title: '我的' }
];

@Component
export struct BottomTabBar {
  @Prop activeIndex: number = 0;
  onSelect: (index: number) => void = () => {};

  build() {
    Row() {
      ForEach(TABS, (tab: SleepTab, index: number) => {
        Column({ space: 3 }) {
          this.tabIcon(index)

          Text(tab.title)
            .fontFamily('MiSans-DemiBold')
            .fontSize(11)
            .fontColor(this.activeIndex === index ? SleepColor.primary : '#7B8190')
        }
        .layoutWeight(1)
        .height(50)
        .justifyContent(FlexAlign.Center)
        .backgroundColor(this.activeIndex === index ? '#0F1677FF' : Color.Transparent)
        .borderRadius(18)
        .margin({
          left: index === 0 ? 0 : 4,
          right: index === TABS.length - 1 ? 0 : 4
        })
        .onClick(() => {
          this.onSelect(index);
        })
      }, (tab: SleepTab) => tab.title)
    }
    .width('100%')
    .height(62)
    .padding({ left: 12, right: 12, top: 6, bottom: 2 })
    .backgroundColor('#FCFFFFFF')
    .border({ width: { top: 0.5 }, color: SleepColor.divider })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }

  @Builder
  private tabIcon(index: number) {
    if (index === 0) {
      Image($rawfile('icons_sleep/tab_sound.svg'))
        .width(21)
        .height(21)
        .fillColor(this.activeIndex === index ? SleepColor.primary : '#7B8190')
    } else if (index === 1) {
      Image($rawfile('icons_sleep/tab_sleep.svg'))
        .width(21)
        .height(21)
        .fillColor(this.activeIndex === index ? SleepColor.primary : '#7B8190')
    } else if (index === 2) {
      Image($rawfile('icons_sleep/tab_story.svg'))
        .width(21)
        .height(21)
        .fillColor(this.activeIndex === index ? SleepColor.primary : '#7B8190')
    } else {
      Image($rawfile('icons_sleep/tab_profile.svg'))
        .width(21)
        .height(21)
        .fillColor(this.activeIndex === index ? SleepColor.primary : '#7B8190')
    }
  }
}
