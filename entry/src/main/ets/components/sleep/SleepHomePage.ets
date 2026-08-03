/**
 * @author liuzheng
 * @mail bryant_liu24@126.com
 */
import { SleepColor, SleepRadius, SleepText } from '../../common/SleepDesign';
import { SleepDetectedEvent, SleepReportData } from '../../models/SleepModels';
import { SoundCoverImage } from '../common/CoverImages';

@Component
export struct SleepHomePage {
  private ringSettings: RenderingContextSettings = new RenderingContextSettings(true);
  private ringContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.ringSettings);
  @Prop selectedPage: number = 0;
  @Prop isMonitoring: boolean = false;
  @Prop trendRange: number = 0;
  @Prop recordingPath: string = '';
  @Prop recordingPaths: string[] = [];
  @Prop isRecordingPlaying: boolean = false;
  @Prop elapsedSeconds: number = 0;
  @Prop environmentDecibels: number = 0;
  @Prop report: SleepReportData = {
    hasData: false, endedAt: 0, durationSeconds: 0, averageDecibels: 0, peakDecibels: 0,
    score: 60, efficiency: 0, quietPercent: 0, deepSeconds: 0,
    lightSeconds: 0, dreamSeconds: 0, awakeSeconds: 0, events: []
  };
  @Prop reports: SleepReportData[] = [];
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
            Text(this.isMonitoring ?
              `已进行 ${this.elapsedText()} · 环境音量 ${this.environmentDecibels > 0 ? this.environmentDecibels : '--'} dB` :
              '开始后会在本地识别打鼾、咳嗽、梦话、磨牙和噪音')
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
          .width('88%')
          .height(44)
          .alignSelf(ItemAlign.Center)
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)
          .linearGradient({
            angle: 90,
            colors: this.isMonitoring ?
              [['#F43F5E', 0], ['#DC2626', 1]] as [string, number][] :
              [['#3392FF', 0], ['#0868E8', 1]] as [string, number][]
          })
          .borderRadius(24)
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
        this.eventMetric('打鼾', this.hasActualReport() ? 0 : 2)
        this.eventMetric('咳嗽', 0)
        this.eventMetric('说梦话', 0)
      }
      Row({ space: 10 }) {
        this.eventMetric('磨牙', this.hasActualReport() ? 0 : 1)
        this.eventMetric('环境噪音', this.hasActualReport() ? this.report.events.length : 4)
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
      Image(this.eventIcon(title))
        .width(23)
        .height(23)
        .fillColor(SleepColor.primary)
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
      this.chartBars()
      Row({ space: 12 }) {
        this.trendMetric('平均评分', `${this.historyAverageScore()} 分`)
        this.trendMetric('平均噪音', `${this.historyAverageDecibels()} dB`)
        this.trendMetric('噪音事件', `${this.historyEventCount()} 次`)
      }
      this.historyReportList()
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
    Row({ space: this.trendRange === 0 ? 8 : 2 }) {
      ForEach(this.trendScores(), (scoreValue: number, index: number) => {
        Column() {
          Blank()
          Column()
            .width(this.trendRange === 0 ? 16 : 6)
            .height(scoreValue > 0 ? Math.max(16, scoreValue) : 8)
            .backgroundColor(scoreValue > 0 ? SleepColor.primary : '#E5E9F2')
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
  private historyReportList() {
    Column({ space: 8 }) {
      Row() {
        Text(this.trendRange === 0 ? '近 7 天报告' : '近 30 天报告')
          .fontSize(SleepText.headline)
          .fontWeight(FontWeight.Medium)
          .fontColor(SleepColor.textPrimary)
        Blank()
        Text(`${this.rangeReports().length} 条`)
          .fontSize(SleepText.caption)
          .fontColor(SleepColor.textSecondary)
      }
      if (this.rangeReports().length === 0) {
        Text('当前时间范围内暂无睡眠报告')
          .fontSize(SleepText.caption)
          .fontColor(SleepColor.textTertiary)
          .width('100%')
          .height(48)
          .textAlign(TextAlign.Center)
      } else {
        ForEach(this.rangeReports(), (item: SleepReportData) => {
          Row({ space: 10 }) {
            Column({ space: 3 }) {
              Text(this.reportDateText(item.endedAt))
                .fontSize(SleepText.subheadline)
                .fontWeight(FontWeight.Medium)
                .fontColor(SleepColor.textPrimary)
              Text(`${this.durationText(item.durationSeconds)} · ${item.averageDecibels} dB · ${item.events.length} 个事件`)
                .fontSize(SleepText.caption)
                .fontColor(SleepColor.textSecondary)
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)
            Text(`${item.score} 分`)
              .fontSize(SleepText.headline)
              .fontWeight(FontWeight.Bold)
              .fontColor(SleepColor.primary)
          }
          .width('100%')
          .padding(12)
          .backgroundColor(Color.White)
          .borderRadius(10)
        }, (item: SleepReportData) => `${item.endedAt}`)
      }
    }
    .width('100%')
  }

  @Builder
  private reportPanel() {
    Column({ space: 16 }) {
      Text(this.hasActualReport() ? (this.isMonitoring ? '本次声音监测实时分析' : '最近一次声音监测分析') : '示例报告 · 开始睡眠监测后将生成你的专属报告')
        .fontSize(SleepText.caption)
        .fontColor(SleepColor.textSecondary)
        .padding({ left: 10, right: 10, top: 4, bottom: 4 })
        .backgroundColor(SleepColor.tertiaryBackground)
        .borderRadius(12)
      Row() {
        Text('睡眠报告')
          .fontSize(SleepText.title3)
          .fontWeight(FontWeight.Medium)
          .fontColor(SleepColor.textPrimary)
        Blank()
        Text(`${this.effectiveScore()}`)
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor(SleepColor.primary)
        Text('分')
          .fontSize(SleepText.subheadline)
          .fontColor(SleepColor.textSecondary)
      }
      Row({ space: 12 }) {
        this.reportMetric('时长', this.hasActualReport() ? this.durationText(this.actualDurationSeconds()) : '7小时36分')
        this.reportMetric('平均噪音', `${this.effectiveAverageDecibels()} dB`)
        this.reportMetric('峰值', `${this.effectivePeakDecibels()} dB`)
      }
      Row({ space: 12 }) {
        this.reportMetric('睡眠效率', `${this.effectiveEfficiency()}%`)
        this.reportMetric('安静占比', `${this.effectiveQuietPercent()}%`)
        this.reportMetric('深睡估算', this.hasActualReport() ? this.durationText(this.effectiveDeepSeconds()) : '142 分钟')
      }
      this.recordingControl()
      this.eventList()
      this.sleepDistribution()
      Text('参考来源：Sleep Foundation《Stages of Sleep》')
        .fontSize(SleepText.caption)
        .fontColor(SleepColor.primary)
        .width('100%')
        .textAlign(TextAlign.Start)
      Text('参考来源：中国睡眠研究会')
        .fontSize(SleepText.caption)
        .fontColor(SleepColor.primary)
        .width('100%')
        .textAlign(TextAlign.Start)
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
      if (!this.hasActualReport()) {
        this.eventRow('打鼾咳嗽', '02:13:00', '86%')
        this.eventRow('磨牙', '03:42:00', '79%')
        this.eventRow('环境噪音', '04:18:00', '72%')
      } else if (this.report.events.length === 0) {
        Text('本次监测未发现明显噪音事件')
          .fontSize(SleepText.caption)
          .fontColor(SleepColor.textTertiary)
          .width('100%')
          .height(44)
          .textAlign(TextAlign.Center)
      } else {
        ForEach(this.report.events, (event: SleepDetectedEvent) => {
          this.eventRow(event.title, this.eventTimeText(event.elapsedSeconds), `${event.decibels} dB`)
        }, (event: SleepDetectedEvent) => `${event.title}-${event.elapsedSeconds}`)
      }
    }
    .padding(14)
    .backgroundColor(SleepColor.tertiaryBackground)
    .borderRadius(SleepRadius.card)
  }

  @Builder
  private eventRow(title: string, time: string, value: string) {
    Row({ space: 10 }) {
      Image(this.eventIcon(title))
        .width(20)
        .height(20)
        .fillColor(SleepColor.primary)
        .width(28)
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
      Text(value)
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
      Row({ space: 16 }) {
        Stack() {
          Canvas(this.ringContext)
            .width(120)
            .height(120)
            .id(this.stagePercentages().join('-'))
            .onReady(() => {
              this.drawSleepRing(this.stagePercentages());
            })
          Text(this.hasActualReport() ? this.shortDurationText(this.actualDurationSeconds()) : '7.6h')
            .fontSize(SleepText.headline)
            .fontWeight(FontWeight.Medium)
            .fontColor(SleepColor.textPrimary)
        }
        .width(120)
        .height(120)

        Column({ space: 8 }) {
          this.stageRow('深睡', this.hasActualReport() ? this.durationText(this.effectiveDeepSeconds()) : '142 分钟', this.hasActualReport() ? `${this.stagePercent(this.effectiveDeepSeconds())}%` : '31%', SleepColor.primary)
          this.stageRow('浅睡', this.hasActualReport() ? this.durationText(this.effectiveLightSeconds()) : '221 分钟', this.hasActualReport() ? `${this.stagePercent(this.effectiveLightSeconds())}%` : '48%', '#80D6FF')
          this.stageRow('做梦', this.hasActualReport() ? this.durationText(this.effectiveDreamSeconds()) : '68 分钟', this.hasActualReport() ? `${this.stagePercent(this.effectiveDreamSeconds())}%` : '15%', '#9B7BFF')
          this.stageRow('清醒', this.hasActualReport() ? this.durationText(this.effectiveAwakeSeconds()) : '27 分钟', this.hasActualReport() ? `${this.stagePercent(this.effectiveAwakeSeconds())}%` : '6%', '#FFB36B')
        }
        .layoutWeight(1)
      }
      Text(this.hasActualReport() ?
        `根据本次声音强度变化估算：深睡 ${this.durationText(this.effectiveDeepSeconds())}，浅睡 ${this.durationText(this.effectiveLightSeconds())}，做梦 ${this.durationText(this.effectiveDreamSeconds())}，清醒 ${this.durationText(this.effectiveAwakeSeconds())}。睡眠阶段仅供参考。` :
        '示例：深度睡眠 142 分钟，浅睡眠 221 分钟，做梦 68 分钟，睡眠中清醒约 27 分钟。完成监测后将显示你的真实分析。')
        .fontSize(SleepText.caption)
        .fontColor(SleepColor.textSecondary)
        .lineHeight(20)
    }
    .padding(14)
    .backgroundColor(SleepColor.tertiaryBackground)
    .borderRadius(SleepRadius.card)
  }

  @Builder
  private stageRow(title: string, duration: string, percent: string, color: string) {
    Row({ space: 5 }) {
      Column()
        .width(8)
        .height(8)
        .backgroundColor(color)
        .borderRadius(4)
      Text(title)
        .fontSize(12)
        .fontColor(SleepColor.textPrimary)
      Blank()
      Text(duration)
        .fontSize(11)
        .fontWeight(FontWeight.Medium)
        .fontColor(SleepColor.textPrimary)
        .maxLines(1)
      Text(percent)
        .fontSize(10)
        .fontColor(SleepColor.textSecondary)
        .width(25)
        .textAlign(TextAlign.End)
    }
    .width('100%')
  }

  private eventIcon(title: string): Resource {
    if (title === '打鼾' || title === '大口呼吸') {
      return $rawfile('icons_sleep/event_wind.svg');
    }
    if (title === '咳嗽' || title === '打鼾咳嗽') {
      return $rawfile('icons_sleep/event_lungs.svg');
    }
    if (title === '说梦话') {
      return $rawfile('icons_sleep/event_talk.svg');
    }
    if (title === '磨牙') {
      return $rawfile('icons_sleep/event_mouth.svg');
    }
    if (title === '环境噪音' || title === '突发噪音') {
      return $rawfile('icons_sleep/event_speaker.svg');
    }
    if (title === '鼻塞') {
      return $rawfile('icons_sleep/event_nose.svg');
    }
    if (title === '放屁') {
      return $rawfile('icons_sleep/event_air.svg');
    }
    return $rawfile('icons_sleep/event_pause.svg');
  }

  private hasActualReport(): boolean {
    return this.isMonitoring || this.elapsedSeconds > 0 || this.report.hasData || this.recordingPaths.length > 0;
  }

  private actualDurationSeconds(): number {
    return this.isMonitoring ? this.elapsedSeconds : Math.max(this.report.durationSeconds, this.elapsedSeconds);
  }

  private effectiveScore(): number {
    return this.hasActualReport() ? Math.max(60, this.report.score) : 86;
  }

  private effectiveAverageDecibels(): number {
    if (!this.hasActualReport()) {
      return 38;
    }
    return this.report.averageDecibels > 0 ? this.report.averageDecibels : this.environmentDecibels;
  }

  private effectivePeakDecibels(): number {
    if (!this.hasActualReport()) {
      return 62;
    }
    return this.report.peakDecibels > 0 ? this.report.peakDecibels : this.environmentDecibels;
  }

  private effectiveEfficiency(): number {
    return this.hasActualReport() ? this.report.efficiency : 92;
  }

  private effectiveQuietPercent(): number {
    return this.hasActualReport() ? this.report.quietPercent : 94;
  }

  private effectiveDeepSeconds(): number {
    return this.report.hasData ? this.report.deepSeconds : Math.round(this.actualDurationSeconds() * 0.34);
  }

  private effectiveDreamSeconds(): number {
    return this.report.hasData ? this.report.dreamSeconds : Math.round(this.actualDurationSeconds() * 0.20);
  }

  private effectiveAwakeSeconds(): number {
    return this.report.hasData ? this.report.awakeSeconds : 0;
  }

  private effectiveLightSeconds(): number {
    if (this.report.hasData) {
      return this.report.lightSeconds;
    }
    return Math.max(0, this.actualDurationSeconds() - this.effectiveDeepSeconds() - this.effectiveDreamSeconds());
  }

  private trendScores(): number[] {
    const reports = this.rangeReports();
    if (!this.hasActualReport() && reports.length === 0) {
      return [54, 74, 62, 88, 76, 92, 70];
    }
    const dayCount = this.trendRange === 0 ? 7 : 30;
    const scores: number[] = [];
    const now = new Date();
    for (let offset = dayCount - 1; offset >= 0; offset--) {
      const target = new Date(now.getFullYear(), now.getMonth(), now.getDate() - offset);
      let score = 0;
      for (let index = 0; index < reports.length; index++) {
        const reportDate = new Date(reports[index].endedAt);
        if (reportDate.getFullYear() === target.getFullYear() &&
          reportDate.getMonth() === target.getMonth() && reportDate.getDate() === target.getDate()) {
          score = reports[index].score;
          break;
        }
      }
      scores.push(score);
    }
    return scores;
  }

  private rangeReports(): SleepReportData[] {
    const dayCount = this.trendRange === 0 ? 7 : 30;
    const now = new Date();
    const rangeStart = new Date(now.getFullYear(), now.getMonth(), now.getDate() - dayCount + 1).getTime();
    const rangeEnd = new Date(now.getFullYear(), now.getMonth(), now.getDate() + 1).getTime();
    return this.reports
      .filter((item: SleepReportData): boolean =>
        item.hasData && item.endedAt >= rangeStart && item.endedAt < rangeEnd)
      .sort((left: SleepReportData, right: SleepReportData): number => right.endedAt - left.endedAt);
  }

  private historyAverageScore(): number {
    const reports = this.rangeReports();
    if (reports.length === 0) {
      return this.hasActualReport() ? this.effectiveScore() : 86;
    }
    return Math.round(reports.reduce((sum: number, item: SleepReportData): number => sum + item.score, 0) / reports.length);
  }

  private historyAverageDecibels(): number {
    const reports = this.rangeReports();
    if (reports.length === 0) {
      return this.hasActualReport() ? this.effectiveAverageDecibels() : 38;
    }
    return Math.round(reports.reduce((sum: number, item: SleepReportData): number => sum + item.averageDecibels, 0) / reports.length);
  }

  private historyEventCount(): number {
    const reports = this.rangeReports();
    if (reports.length === 0) {
      return this.hasActualReport() ? this.report.events.length : 4;
    }
    return reports.reduce((sum: number, item: SleepReportData): number => sum + item.events.length, 0);
  }

  private reportDateText(timestamp: number): string {
    const date = new Date(timestamp);
    return `${date.getFullYear()}-${this.twoDigits(date.getMonth() + 1)}-${this.twoDigits(date.getDate())} ${this.twoDigits(date.getHours())}:${this.twoDigits(date.getMinutes())}`;
  }

  private durationText(seconds: number): string {
    const hours = Math.floor(seconds / 3600);
    const minutes = Math.floor((seconds % 3600) / 60);
    const remainSeconds = Math.floor(seconds % 60);
    if (hours > 0) {
      return `${hours}小时${minutes}分`;
    }
    if (minutes > 0) {
      return `${minutes}分${remainSeconds}秒`;
    }
    return `${remainSeconds}秒`;
  }

  private shortDurationText(seconds: number): string {
    if (seconds >= 3600) {
      return `${(seconds / 3600).toFixed(1)}h`;
    }
    if (seconds >= 60) {
      return `${Math.floor(seconds / 60)}m`;
    }
    return `${seconds}s`;
  }

  private eventTimeText(seconds: number): string {
    const hours = Math.floor(seconds / 3600);
    const minutes = Math.floor((seconds % 3600) / 60);
    const remainSeconds = Math.floor(seconds % 60);
    return `${this.twoDigits(hours)}:${this.twoDigits(minutes)}:${this.twoDigits(remainSeconds)}`;
  }

  private twoDigits(value: number): string {
    return value < 10 ? `0${value}` : `${value}`;
  }

  private stagePercent(seconds: number): number {
    const duration = this.actualDurationSeconds();
    if (!this.hasActualReport() || duration <= 0) {
      return 0;
    }
    return Math.round(seconds * 100 / duration);
  }

  private stagePercentages(): number[] {
    if (!this.hasActualReport()) {
      return [31, 48, 15, 6];
    }
    return [
      this.stagePercent(this.effectiveDeepSeconds()),
      this.stagePercent(this.effectiveLightSeconds()),
      this.stagePercent(this.effectiveDreamSeconds()),
      this.stagePercent(this.effectiveAwakeSeconds())
    ];
  }

  private drawSleepRing(values: number[]): void {
    const context = this.ringContext;
    const center = 60;
    const radius = 48;
    const lineWidth = 18;
    context.clearRect(0, 0, 120, 120);
    context.lineWidth = lineWidth;
    context.lineCap = 'butt';
    context.strokeStyle = '#EEF2F8';
    context.beginPath();
    context.arc(center, center, radius, 0, Math.PI * 2);
    context.stroke();

    const colors: string[] = [SleepColor.primary, '#80D6FF', '#9B7BFF', '#FFB36B'];
    let startAngle = -Math.PI / 2;
    for (let index = 0; index < values.length; index++) {
      const portion = Math.max(0, values[index]) / 100;
      if (portion <= 0) {
        continue;
      }
      const endAngle = startAngle + Math.PI * 2 * portion;
      context.strokeStyle = colors[index];
      context.beginPath();
      context.arc(center, center, radius, startAngle, endAngle);
      context.stroke();
      startAngle = endAngle;
    }
  }
}
