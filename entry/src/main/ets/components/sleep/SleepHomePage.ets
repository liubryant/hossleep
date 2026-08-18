/**
 * @author liuzheng
 * @mail bryant_liu24@126.com
 */
import { SleepColor, SleepRadius, SleepText } from '../../common/SleepDesign';
import { SLEEP_EVENTS } from '../../models/SleepData';
import { SleepEventSummaryItem } from '../../models/SleepModels';
import { SoundCoverImage } from '../common/CoverImages';

@Component
export struct SleepHomePage {
  @Prop selectedPage: number = 0;
  @Prop isMonitoring: boolean = false;
  @Prop trendRange: number = 0;
  @Prop recordingPath: string = '';
  @Prop recordingPaths: string[] = [];
  @Prop isRecordingPlaying: boolean = false;
  @Prop elapsedSeconds: number = 0;
  @Prop reportDurationSeconds: number = 0;
  onSelectPage: (index: number) => void = () => {};
  onToggleMonitoring: () => void = () => {};
  onSelectTrendRange: (index: number) => void = () => {};
  onToggleRecording: (path: string) => void = () => {};

  build() {
    Column({ space: 0 }) {
      this.pageTabs()

      Swiper() {
        this.pageContent(0)
        this.pageContent(1)
      }
      .index(this.selectedPage)
      .indicator(false)
      .loop(false)
      .duration(260)
      .onChange((index: number) => {
        this.onSelectPage(index);
      })
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(SleepColor.background)
  }

  @Builder
  private pageContent(page: number) {
    Scroll() {
      Column({ space: 16 }) {
        if (page === 0) {
          this.statusPanel()
          this.eventSummary()
        }
        this.trendPanel()
        this.reportPanel()
      }
      .width('100%')
      .padding({ left: 16, right: 16, bottom: 112 })
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Off)
  }

  @Builder
  private pageTabs() {
    Row({ space: 28 }) {
      this.pageTab('开始睡眠', 0)
      this.pageTab('睡眠报告', 1)
    }
    .width('100%')
    .height(58)
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  private pageTab(title: string, index: number) {
    Column({ space: 8 }) {
      Text(title)
        .fontFamily('MiSans')
        .fontSize(this.selectedPage === index ? 18 : 17)
        .fontWeight(this.selectedPage === index ? FontWeight.Bold : FontWeight.Normal)
        .fontColor(this.selectedPage === index ? SleepColor.textPrimary : SleepColor.textSecondary)
      Column()
        .width(44)
        .height(3)
        .backgroundColor(this.selectedPage === index ? SleepColor.primary : '#00000000')
        .borderRadius(2)
    }
    .onClick(() => {
      this.onSelectPage(index);
    })
  }

  @Builder
  private statusPanel() {
    Stack({ alignContent: Alignment.BottomStart }) {
      SoundCoverImage({ index: 11, widthValue: '100%', heightValue: 210, radius: 14 })
      Column()
        .width('100%')
        .height(210)
        .linearGradient({
          angle: 135,
          colors: [['#24000000', 0], ['#99000000', 1]] as [string, number][]
        })
        .borderRadius(14)

      Column() {
        Row() {
          Column({ space: 6 }) {
            Text(this.isMonitoring ? '正在监测' : '今晚睡眠')
              .fontSize(22)
              .fontWeight(FontWeight.Medium)
              .fontColor(Color.White)
            Text(this.isMonitoring ? `已进行 ${this.elapsedText()} · 正在采集环境声音` : '开始后会在本地识别打鼾、咳嗽、梦话、磨牙和噪音')
              .fontSize(SleepText.subheadline)
              .fontColor('#EDEFFF')
              .lineHeight(21)
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)
          if (this.isMonitoring) {
            Stack() {
              Column()
                .width(42)
                .height(42)
                .backgroundColor('#26FFFFFF')
                .borderRadius(14)
                .animation({ duration: 900, curve: Curve.EaseInOut, iterations: -1, playMode: PlayMode.Alternate })
              Image($rawfile('icons_sleep/ic_monitor_wave.svg'))
                .width(27)
                .height(27)
                .fillColor(Color.White)
            }
            .width(46)
            .height(46)
          } else {
            Text('☾')
              .fontFamily('MiSans')
              .fontSize(42)
              .fontColor(Color.White)
          }
        }

        Row({ space: 8 }) {
          if (this.isMonitoring) {
            Image($rawfile('icons_sleep/ic_sleep_stop.svg'))
              .width(18)
              .height(18)
              .fillColor(Color.White)
          } else {
            Image($rawfile('icons_sleep/ic_play.svg'))
              .width(17)
              .height(17)
              .fillColor(Color.White)
          }
          Text(this.isMonitoring ? '结束睡眠' : '开始睡眠')
            .fontFamily('MiSans')
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .fontColor(Color.White)
        }
          .width('84%')
          .height(44)
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)
          .linearGradient({
            angle: 90,
            colors: this.isMonitoring ?
              [['#F43F5E', 0], ['#DC2626', 1]] as [string, number][] :
              [['#3392FF', 0], ['#0868E8', 1]] as [string, number][]
          })
          .borderRadius(22)
          .shadow({
            radius: 12,
            color: this.isMonitoring ? '#35EF4444' : '#351677FF',
            offsetY: 5
          })
          .animation({ duration: 220, curve: Curve.EaseOut })
          .onClick(() => {
            this.onToggleMonitoring();
          })
      }
      .padding(22)
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .height(210)
    .borderRadius(14)
    .clip(true)
  }

  private elapsedText(): string {
    const hours = Math.floor(this.elapsedSeconds / 3600);
    const minutes = Math.floor((this.elapsedSeconds % 3600) / 60);
    const seconds = this.elapsedSeconds % 60;
    return `${hours}时${minutes}分${seconds}秒`;
  }

  @Builder
  private eventSummary() {
    Column({ space: 10 }) {
      Row({ space: 10 }) {
        this.eventMetric('打鼾', 0)
        this.eventMetric('咳嗽', 0)
        this.eventMetric('说梦话', 0)
      }
      Row({ space: 10 }) {
        this.eventMetric('磨牙', 0)
        this.eventMetric('环境噪音', 0)
        this.eventMetric('大口呼吸', 0)
      }
      Row({ space: 10 }) {
        this.eventMetric('鼻塞', 0)
        this.eventMetric('放屁', 0)
        this.eventMetric('憋气', 0)
      }
    }
    .width('100%')
  }

  @Builder
  private eventMetric(title: string, count: number) {
    Column({ space: 6 }) {
      Text(this.eventIcon(title))
        .fontFamily('MiSans')
        .fontSize(21)
        .fontColor(SleepColor.primary)
      Text(`${count}`)
        .fontFamily('MiSans')
        .fontSize(19)
        .fontWeight(FontWeight.Bold)
        .fontColor(SleepColor.textPrimary)
      Text(title)
        .fontFamily('MiSans')
        .fontSize(11)
        .fontColor(SleepColor.textSecondary)
        .maxLines(1)
    }
    .layoutWeight(1)
    .height(96)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#F7F7FA')
    .borderRadius(8)
  }

  @Builder
  private trendPanel() {
    Column({ space: 14 }) {
      Row() {
        Text('睡眠趋势')
          .fontSize(SleepText.title3)
          .fontWeight(FontWeight.Medium)
          .fontColor(SleepColor.textPrimary)
        Blank()
        Row() {
          this.rangeButton('周', 0)
          this.rangeButton('月', 1)
        }
        .width(92)
        .height(32)
        .padding(2)
        .alignItems(VerticalAlign.Center)
        .backgroundColor(Color.White)
        .borderRadius(8)
      }
      Column({ space: 8 }) {
        Text('暂无趋势数据')
          .fontSize(SleepText.headline)
          .fontWeight(FontWeight.Medium)
          .fontColor(SleepColor.textPrimary)
        Text('完成更多有效睡眠后，将在这里生成周、月趋势')
          .fontSize(SleepText.caption)
          .fontColor(SleepColor.textSecondary)
      }
      .width('100%')
      .height(150)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    }
    .padding(16)
    .backgroundColor(SleepColor.secondaryBackground)
    .borderRadius(SleepRadius.card)
  }

  @Builder
  private rangeButton(title: string, index: number) {
    Text(title)
      .fontSize(13)
      .fontWeight(FontWeight.Medium)
      .fontFamily('MiSans')
      .fontColor(this.trendRange === index ? Color.White : SleepColor.textSecondary)
      .layoutWeight(1)
      .height(28)
      .textAlign(TextAlign.Center)
      .align(Alignment.Center)
      .backgroundColor(this.trendRange === index ? SleepColor.primary : '#00000000')
      .borderRadius(7)
      .onClick(() => {
        this.onSelectTrendRange(index);
      })
  }

  @Builder
  private chartBars() {
    Row({ space: 8 }) {
      ForEach([54, 74, 62, 88, 76, 92, 70], (heightValue: number, index: number) => {
        Column() {
          Blank()
          Column()
            .width(16)
            .height(heightValue)
            .backgroundColor(index === 5 ? SleepColor.primary : '#C9D2F5')
            .borderRadius(8)
        }
        .height(132)
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)
      }, (_heightValue: number, index: number) => `${index}`)
    }
    .height(150)
    .width('100%')
  }

  @Builder
  private trendMetric(title: string, value: string) {
    Column({ space: 6 }) {
      Text(title)
        .fontSize(SleepText.caption)
        .fontColor(SleepColor.textSecondary)
      Text(value)
        .fontSize(SleepText.headline)
        .fontWeight(FontWeight.Medium)
        .fontColor(SleepColor.textPrimary)
    }
    .layoutWeight(1)
    .padding(10)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor(SleepColor.tertiaryBackground)
    .borderRadius(SleepRadius.card)
  }

  @Builder
  private reportPanel() {
    Column({ space: 16 }) {
      Row() {
        Text('睡眠报告')
          .fontSize(SleepText.title3)
          .fontWeight(FontWeight.Medium)
          .fontColor(SleepColor.textPrimary)
        Blank()
        if (this.reportDurationSeconds > 0) {
          Text('最近一次')
            .fontSize(SleepText.caption)
            .fontColor(SleepColor.textSecondary)
        }
      }
      if (this.reportDurationSeconds <= 0) {
        Column({ space: 10 }) {
          Text('暂无睡眠报告')
            .fontSize(SleepText.headline)
            .fontWeight(FontWeight.Medium)
            .fontColor(SleepColor.textPrimary)
          Text('完成一次不少于30分钟的睡眠监测后，将在这里显示本次报告')
            .fontSize(SleepText.caption)
            .fontColor(SleepColor.textSecondary)
            .textAlign(TextAlign.Center)
            .lineHeight(20)
        }
        .width('100%')
        .height(180)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      } else {
        Row({ space: 12 }) {
          this.reportMetric('时长', this.durationText(this.reportDurationSeconds))
          this.reportMetric('声音事件', '0 次')
          this.reportMetric('录音', `${this.recordingPaths.length} 条`)
        }
        this.recordingControl()
        this.eventList()
        this.sleepDistribution()
      }
    }
    .padding(16)
    .backgroundColor(SleepColor.secondaryBackground)
    .borderRadius(SleepRadius.card)
  }

  @Builder
  private reportMetric(title: string, value: string) {
    Column({ space: 6 }) {
      Text(title)
        .fontSize(SleepText.caption)
        .fontColor(SleepColor.textSecondary)
      Text(value)
        .fontSize(SleepText.subheadline)
        .fontWeight(FontWeight.Medium)
        .fontColor(SleepColor.textPrimary)
        .maxLines(1)
    }
    .layoutWeight(1)
    .padding(10)
    .alignItems(HorizontalAlign.Start)
    .backgroundColor(SleepColor.tertiaryBackground)
    .borderRadius(SleepRadius.card)
  }

  @Builder
  private recordingControl() {
    Column({ space: 10 }) {
      Row({ space: 10 }) {
        Stack() {
          Image($rawfile('icons_sleep/ic_wave.svg'))
            .width(21)
            .height(21)
            .fillColor(SleepColor.primary)
        }
        .width(34)
        .height(34)
        .backgroundColor('#EAF3FF')
        .borderRadius(10)
        Column({ space: 3 }) {
          Text('睡眠录音')
            .fontSize(SleepText.headline)
            .fontWeight(FontWeight.Medium)
            .fontColor(SleepColor.textPrimary)
          Text(this.recordingPaths.length > 0 ? `已保存 ${this.recordingPaths.length} 条录音` : '完成睡眠监测后，录音会显示在这里')
            .fontSize(SleepText.caption)
            .fontColor(SleepColor.textSecondary)
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)
      }

      if (this.recordingPaths.length === 0) {
        Text('暂无可播放录音')
          .fontSize(13)
          .fontColor(SleepColor.textTertiary)
          .width('100%')
          .height(46)
          .textAlign(TextAlign.Center)
      } else {
        ForEach(this.recordingPaths, (path: string, index: number) => {
          this.recordingRow(path, index)
        }, (path: string) => path)
      }
    }
    .padding(14)
    .backgroundColor(SleepColor.tertiaryBackground)
    .borderRadius(SleepRadius.card)
  }

  @Builder
  private recordingRow(path: string, index: number) {
    Row({ space: 10 }) {
      Column({ space: 3 }) {
        Text(this.recordingTitle(path))
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor(SleepColor.textPrimary)
        Text(index === 0 ? '最近一次睡眠录音' : `历史录音 ${index + 1}`)
          .fontSize(11)
          .fontColor(SleepColor.textSecondary)
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      Stack() {
        Image(this.isRecordingPlaying && this.recordingPath === path ?
          $rawfile('icons_sleep/ic_pause.svg') : $rawfile('icons_sleep/ic_play.svg'))
          .width(15)
          .height(15)
          .fillColor(this.isRecordingPlaying && this.recordingPath === path ? Color.White : SleepColor.primary)
      }
      .width(36)
      .height(36)
      .backgroundColor(this.isRecordingPlaying && this.recordingPath === path ? SleepColor.primary : '#EAF3FF')
      .borderRadius(18)
      .onClick(() => this.onToggleRecording(path))
    }
    .width('100%')
    .height(54)
    .padding({ left: 12, right: 8 })
    .backgroundColor(Color.White)
    .borderRadius(10)
  }

  private recordingTitle(path: string): string {
    const name = path.substring(path.lastIndexOf('/') + 1)
      .replace('sleep_', '')
      .replace('.m4a', '');
    if (name.length < 15) {
      return name;
    }
    return `${name.substring(0, 4)}-${name.substring(4, 6)}-${name.substring(6, 8)}  ${name.substring(9, 11)}:${name.substring(11, 13)}`;
  }

  @Builder
  private eventList() {
    Column({ space: 10 }) {
      Text('事件列表')
        .fontSize(SleepText.headline)
        .fontWeight(FontWeight.Medium)
        .fontColor(SleepColor.textPrimary)
        .width('100%')
      Text('本次未识别到打鼾、咳嗽、梦话、磨牙等声音事件')
        .fontSize(SleepText.caption)
        .fontColor(SleepColor.textSecondary)
        .width('100%')
        .textAlign(TextAlign.Center)
        .padding({ top: 16, bottom: 16 })
    }
    .padding(14)
    .backgroundColor(SleepColor.tertiaryBackground)
    .borderRadius(SleepRadius.card)
  }

  @Builder
  private eventRow(title: string, time: string, confidence: string) {
    Row({ space: 10 }) {
      Text(this.eventIcon(title))
        .fontSize(18)
        .fontColor(SleepColor.primary)
        .width(28)
        .textAlign(TextAlign.Center)
      Column({ space: 3 }) {
        Text(title)
          .fontSize(SleepText.subheadline)
          .fontWeight(FontWeight.Medium)
          .fontColor(SleepColor.textPrimary)
        Text(time)
          .fontSize(SleepText.caption)
          .fontColor(SleepColor.textSecondary)
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      Text(confidence)
        .fontSize(SleepText.caption)
        .fontWeight(FontWeight.Medium)
        .fontColor(SleepColor.textSecondary)
    }
    .width('100%')
    .padding({ top: 4, bottom: 4 })
  }

  @Builder
  private sleepDistribution() {
    Column({ space: 12 }) {
      Text('睡眠分布')
        .fontSize(SleepText.headline)
        .fontWeight(FontWeight.Medium)
        .fontColor(SleepColor.textPrimary)
        .width('100%')
      Text('暂无睡眠阶段数据')
        .fontSize(SleepText.headline)
        .fontWeight(FontWeight.Medium)
        .fontColor(SleepColor.textPrimary)
        .width('100%')
        .textAlign(TextAlign.Center)
        .padding({ top: 20, bottom: 4 })
      Text('当前记录仅包含监测时长和本地录音，不会推测深睡、浅睡或做梦时长。')
        .fontSize(SleepText.caption)
        .fontColor(SleepColor.textSecondary)
        .textAlign(TextAlign.Center)
        .lineHeight(20)
    }
    .padding(14)
    .backgroundColor(SleepColor.tertiaryBackground)
    .borderRadius(SleepRadius.card)
  }

  @Builder
  private stageRow(title: string, duration: string, percent: string, color: string) {
    Row({ space: 8 }) {
      Column()
        .width(10)
        .height(10)
        .backgroundColor(color)
        .borderRadius(5)
      Text(title)
        .fontSize(SleepText.subheadline)
        .fontColor(SleepColor.textPrimary)
      Blank()
      Text(duration)
        .fontSize(SleepText.subheadline)
        .fontWeight(FontWeight.Medium)
        .fontColor(SleepColor.textPrimary)
      Text(percent)
        .fontSize(SleepText.caption)
        .fontColor(SleepColor.textSecondary)
    }
    .width('100%')
  }

  private eventIcon(title: string): string {
    if (title === '打鼾咳嗽') {
      return '≋';
    }
    if (title === '说梦话') {
      return '…';
    }
    if (title === '磨牙') {
      return '⌾';
    }
    return '◉';
  }

  private durationText(seconds: number): string {
    const hours = Math.floor(seconds / 3600);
    const minutes = Math.floor((seconds % 3600) / 60);
    if (hours > 0) {
      return `${hours}小时${minutes}分`;
    }
    return `${minutes}分钟`;
  }
}
