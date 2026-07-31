/**
 * 睡眠监测页。仅展示用户实际产生的睡眠会话与录音，不内置演示数据。
 */
import { SleepColor, SleepRadius, SleepText } from '../../common/SleepDesign';
import { SleepReport } from '../../services/SleepReportStore';
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
  @Prop currentNoiseDbfs: number = 0;
  @Prop hasCurrentNoise: boolean = false;
  @Prop reports: SleepReport[] = [];
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
          if (this.reports.length === 0) {
            this.zeroEventSummary()
            this.zeroTrendPanel()
          } else {
            this.trendPanel()
            this.reportPanel(this.reports[0])
          }
        } else {
          if (this.reports.length === 0) {
            this.sampleTrendPanel()
            this.sampleReportPanel()
          } else {
            this.trendPanel()
            this.reportPanel(this.reports[0])
          }
        }
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
            Text(this.monitoringDescription())
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
          Image(this.isMonitoring ? $rawfile('icons_sleep/ic_sleep_stop.svg') :
            $rawfile('icons_sleep/ic_play.svg'))
            .width(18)
            .height(18)
            .fillColor(Color.White)
          Text(this.isMonitoring ? '结束睡眠' : '开始睡眠')
            .fontFamily('MiSans')
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .fontColor(Color.White)
        }
        .width('100%')
        .height(48)
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

  @Builder
  private zeroEventSummary() {
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
        .fontSize(21)
        .fontColor(SleepColor.primary)
      Text(`${count}`)
        .fontSize(19)
        .fontWeight(FontWeight.Bold)
        .fontColor(SleepColor.textPrimary)
      Text(title)
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
  private zeroTrendPanel() {
    Column({ space: 14 }) {
      Text('睡眠趋势')
        .fontSize(SleepText.title3)
        .fontWeight(FontWeight.Medium)
        .fontColor(SleepColor.textPrimary)
        .width('100%')
      Row({ space: 8 }) {
        ForEach([0, 0, 0, 0, 0, 0, 0], (_value: number, index: number) => {
          Column({ space: 5 }) {
            Blank()
            Column()
              .width(16)
              .height(2)
              .backgroundColor('#C9D2F5')
              .borderRadius(1)
            Text(`${index + 1}`)
              .fontSize(10)
              .fontColor(SleepColor.textTertiary)
          }
          .height(116)
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Center)
        }, (_value: number, index: number) => `${index}`)
      }
      .width('100%')
      Row({ space: 12 }) {
        this.trendMetric('记录次数', '0 次')
        this.trendMetric('平均时长', '0 分钟')
        this.trendMetric('平均音量', '0 分贝')
      }
      Text('完成一次睡眠监测后，将显示您的真实睡眠数据。')
        .fontSize(SleepText.caption)
        .fontColor(SleepColor.textSecondary)
        .width('100%')
        .textAlign(TextAlign.Center)
    }
    .padding(16)
    .backgroundColor(SleepColor.secondaryBackground)
    .borderRadius(SleepRadius.card)
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
        this.trendMetric('记录次数', `${this.rangeReports().length} 次`)
        this.trendMetric('平均时长', this.averageDurationText())
        this.trendMetric('平均音量', this.averageNoiseText())
      }
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
      ForEach(this.rangeReports(), (report: SleepReport, index: number) => {
        Column({ space: 5 }) {
          Blank()
          Column()
            .width(16)
            .height(this.barHeight(report.durationSeconds))
            .backgroundColor(index === 0 ? SleepColor.primary : '#C9D2F5')
            .borderRadius(8)
          Text(this.dayText(report.startTime))
            .fontSize(10)
            .fontColor(SleepColor.textTertiary)
        }
        .height(142)
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)
      }, (report: SleepReport) => report.id)
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
        .fontSize(SleepText.subheadline)
        .fontWeight(FontWeight.Medium)
        .fontColor(SleepColor.textPrimary)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .layoutWeight(1)
    .padding(10)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor(SleepColor.tertiaryBackground)
    .borderRadius(SleepRadius.card)
  }

  @Builder
  private sampleTrendPanel() {
    Column({ space: 14 }) {
      Row() {
        Text('示例睡眠趋势')
          .fontSize(SleepText.title3)
          .fontWeight(FontWeight.Medium)
          .fontColor(SleepColor.textPrimary)
        Blank()
        Text('示例')
          .fontSize(11)
          .fontColor(SleepColor.primary)
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
          .backgroundColor('#EAF3FF')
          .borderRadius(8)
      }
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
      .height(140)
      .width('100%')
      Row({ space: 12 }) {
        this.trendMetric('平均评分', '86 分')
        this.trendMetric('打鼾', '2 次')
        this.trendMetric('磨牙', '1 次')
      }
      Text('以上仅用于展示报告样式，不是您的个人睡眠数据。')
        .fontSize(SleepText.caption)
        .fontColor('#D97706')
        .width('100%')
        .textAlign(TextAlign.Center)
    }
    .padding(16)
    .backgroundColor(SleepColor.secondaryBackground)
    .borderRadius(SleepRadius.card)
  }

  @Builder
  private sampleReportPanel() {
    Column({ space: 16 }) {
      Row() {
        Column({ space: 4 }) {
          Text('示例睡眠报告')
            .fontSize(SleepText.title3)
            .fontWeight(FontWeight.Medium)
            .fontColor(SleepColor.textPrimary)
          Text('非个人数据 · 完成监测后将替换为您的真实报告')
            .fontSize(SleepText.caption)
            .fontColor('#D97706')
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)
        Text('86')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor(SleepColor.primary)
        Text('分')
          .fontSize(SleepText.subheadline)
          .fontColor(SleepColor.textSecondary)
      }
      Row({ space: 12 }) {
        this.reportMetric('时长', '7小时36分')
        this.reportMetric('平均噪音', '38 dB')
        this.reportMetric('峰值', '62 dB')
      }
      Row({ space: 12 }) {
        this.reportMetric('睡眠效率', '92%')
        this.reportMetric('睡眠年龄', '27 岁')
        this.reportMetric('深睡时长', '142 分钟')
      }
      this.sampleEventList()
      this.sampleSleepDistribution()
      Text('参考来源：Sleep Foundation《Stages of Sleep》')
        .fontSize(SleepText.caption)
        .fontColor(SleepColor.primary)
        .width('100%')
      Text('参考来源：中国睡眠研究会')
        .fontSize(SleepText.caption)
        .fontColor(SleepColor.primary)
        .width('100%')
    }
    .padding(16)
    .backgroundColor(SleepColor.secondaryBackground)
    .border({ width: 1, color: '#F3D19E' })
    .borderRadius(SleepRadius.card)
  }

  @Builder
  private sampleEventList() {
    Column({ space: 10 }) {
      Text('事件列表示例')
        .fontSize(SleepText.headline)
        .fontWeight(FontWeight.Medium)
        .fontColor(SleepColor.textPrimary)
        .width('100%')
      this.sampleEventRow('打鼾咳嗽', '02:13', '86%')
      this.sampleEventRow('磨牙', '03:42', '79%')
      this.sampleEventRow('环境噪音', '04:18', '72%')
    }
    .padding(14)
    .backgroundColor(SleepColor.tertiaryBackground)
    .borderRadius(SleepRadius.card)
  }

  @Builder
  private sampleEventRow(title: string, time: string, confidence: string) {
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
  private sampleSleepDistribution() {
    Column({ space: 12 }) {
      Text('睡眠分布示例')
        .fontSize(SleepText.headline)
        .fontWeight(FontWeight.Medium)
        .fontColor(SleepColor.textPrimary)
        .width('100%')
      Row({ space: 16 }) {
        Stack() {
          Column()
            .width(120)
            .height(120)
            .backgroundColor('#DDE6FF')
            .borderRadius(60)
          Column()
            .width(76)
            .height(76)
            .backgroundColor(SleepColor.tertiaryBackground)
            .borderRadius(38)
          Text('7.6h')
            .fontSize(SleepText.headline)
            .fontWeight(FontWeight.Medium)
            .fontColor(SleepColor.textPrimary)
        }
        .width(120)
        .height(120)

        Column({ space: 8 }) {
          this.stageRow('深睡', '142 分钟', '31%', SleepColor.primary)
          this.stageRow('浅睡', '221 分钟', '48%', '#80D6FF')
          this.stageRow('做梦', '68 分钟', '15%', '#9B7BFF')
          this.stageRow('清醒', '27 分钟', '6%', '#FFB36B')
        }
        .layoutWeight(1)
      }
      Text('示例说明：深度睡眠 142 分钟，浅睡眠 221 分钟，做梦 68 分钟，清醒 27 分钟。')
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

  @Builder
  private reportPanel(report: SleepReport) {
    Column({ space: 16 }) {
      Column({ space: 5 }) {
        Text('最近一次睡眠报告')
          .fontSize(SleepText.title3)
          .fontWeight(FontWeight.Medium)
          .fontColor(SleepColor.textPrimary)
        Text(this.dateTimeText(report.startTime))
          .fontSize(SleepText.caption)
          .fontColor(SleepColor.textSecondary)
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)

      Row({ space: 12 }) {
        this.reportMetric('实际时长', this.durationText(report.durationSeconds))
        this.reportMetric('平均音量', this.noiseText(report.averageDbfs, report.hasNoiseData))
        this.reportMetric('峰值音量', this.noiseText(report.peakDbfs, report.hasNoiseData))
      }

      Column({ space: 8 }) {
        Text('监测时间')
          .fontSize(SleepText.headline)
          .fontWeight(FontWeight.Medium)
          .fontColor(SleepColor.textPrimary)
          .width('100%')
        Text(`${this.timeText(report.startTime)} - ${this.timeText(report.endTime)}`)
          .fontSize(SleepText.subheadline)
          .fontColor(SleepColor.textSecondary)
          .width('100%')
        Text('音量由设备麦克风监测，仅供睡眠环境参考。')
          .fontSize(SleepText.caption)
          .fontColor(SleepColor.textSecondary)
          .lineHeight(19)
      }
      .padding(14)
      .backgroundColor(SleepColor.tertiaryBackground)
      .borderRadius(SleepRadius.card)

      this.reportEventSummary()
      this.monitoringOverview(report)
      this.recordingControl()
    }
    .padding(16)
    .backgroundColor(SleepColor.secondaryBackground)
    .borderRadius(SleepRadius.card)
  }

  @Builder
  private reportEventSummary() {
    Column({ space: 10 }) {
      Text('睡眠声音事件')
        .fontSize(SleepText.headline)
        .fontWeight(FontWeight.Medium)
        .fontColor(SleepColor.textPrimary)
        .width('100%')
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
    }
    .padding(14)
    .backgroundColor(SleepColor.tertiaryBackground)
    .borderRadius(SleepRadius.card)
  }

  @Builder
  private monitoringOverview(report: SleepReport) {
    Column({ space: 12 }) {
      Text('监测数据')
        .fontSize(SleepText.headline)
        .fontWeight(FontWeight.Medium)
        .fontColor(SleepColor.textPrimary)
        .width('100%')
      Row({ space: 16 }) {
        Stack() {
          Column()
            .width(120)
            .height(120)
            .backgroundColor('#DDE6FF')
            .borderRadius(60)
          Column()
            .width(76)
            .height(76)
            .backgroundColor(SleepColor.tertiaryBackground)
            .borderRadius(38)
          Text(this.shortDurationText(report.durationSeconds))
            .fontSize(SleepText.headline)
            .fontWeight(FontWeight.Medium)
            .fontColor(SleepColor.textPrimary)
        }
        .width(120)
        .height(120)

        Column({ space: 10 }) {
          this.overviewRow('监测时长', this.durationText(report.durationSeconds), SleepColor.primary)
          this.overviewRow('平均音量', this.noiseText(report.averageDbfs, report.hasNoiseData), '#80D6FF')
          this.overviewRow('峰值音量', this.noiseText(report.peakDbfs, report.hasNoiseData), '#9B7BFF')
        }
        .layoutWeight(1)
      }
    }
    .padding(14)
    .backgroundColor(SleepColor.tertiaryBackground)
    .borderRadius(SleepRadius.card)
  }

  @Builder
  private overviewRow(title: string, value: string, color: string) {
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
      Text(value)
        .fontSize(SleepText.subheadline)
        .fontWeight(FontWeight.Medium)
        .fontColor(SleepColor.textPrimary)
    }
    .width('100%')
  }

  @Builder
  private reportMetric(title: string, value: string) {
    Column({ space: 6 }) {
      Text(title)
        .fontSize(10)
        .fontColor(SleepColor.textSecondary)
        .maxLines(1)
      Text(value)
        .fontSize(13)
        .fontWeight(FontWeight.Medium)
        .fontColor(SleepColor.textPrimary)
        .maxLines(2)
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
          Text('睡眠录音 · 数据来源：设备麦克风')
            .fontSize(SleepText.headline)
            .fontWeight(FontWeight.Medium)
            .fontColor(SleepColor.textPrimary)
          Text(this.recordingPaths.length > 0 ? `已保存 ${this.recordingPaths.length} 条录音` : '暂无录音')
            .fontSize(SleepText.caption)
            .fontColor(SleepColor.textSecondary)
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)
      }

      if (this.recordingPaths.length === 0) {
        Text('本次录音不可用')
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
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
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

  private monitoringDescription(): string {
    if (!this.isMonitoring) {
      return '开始后会记录真实睡眠时长、录音和环境音量';
    }
    const noise = this.hasCurrentNoise ? ` · 音量 ${Math.round(this.currentNoiseDbfs)} 分贝` : ' · 音量 0 分贝';
    return `已进行 ${this.durationText(this.elapsedSeconds)}${noise}`;
  }

  private rangeReports(): SleepReport[] {
    const limit = this.trendRange === 0 ? 7 : 30;
    return this.reports.slice(0, limit);
  }

  private averageDurationText(): string {
    const reports = this.rangeReports();
    if (reports.length === 0) {
      return '0 分钟';
    }
    const total = reports.reduce((sum: number, item: SleepReport): number => sum + item.durationSeconds, 0);
    return this.durationText(Math.round(total / reports.length));
  }

  private averageNoiseText(): string {
    const reports = this.rangeReports().filter((item: SleepReport): boolean => item.hasNoiseData);
    if (reports.length === 0) {
      return '0 分贝';
    }
    const total = reports.reduce((sum: number, item: SleepReport): number => sum + item.averageDbfs, 0);
    return `${Math.round(total / reports.length)} 分贝`;
  }

  private barHeight(durationSeconds: number): number {
    const hours = durationSeconds / 3600;
    return Math.max(8, Math.min(112, Math.round(hours / 10 * 112)));
  }

  private durationText(seconds: number): string {
    const hours = Math.floor(seconds / 3600);
    const minutes = Math.floor((seconds % 3600) / 60);
    const remainSeconds = seconds % 60;
    if (hours > 0) {
      return `${hours}小时${minutes}分`;
    }
    if (minutes > 0) {
      return `${minutes}分${remainSeconds}秒`;
    }
    return `${remainSeconds}秒`;
  }

  private shortDurationText(seconds: number): string {
    const hours = Math.floor(seconds / 3600);
    const minutes = Math.floor((seconds % 3600) / 60);
    if (hours > 0) {
      return `${hours}时${minutes}分`;
    }
    if (minutes > 0) {
      return `${minutes}分钟`;
    }
    return `${seconds % 60}秒`;
  }

  private noiseText(value: number, available: boolean): string {
    return available ? `${Math.round(value)} 分贝` : '0 分贝';
  }

  private dayText(timestamp: number): string {
    const date = new Date(timestamp);
    return `${date.getMonth() + 1}/${date.getDate()}`;
  }

  private dateTimeText(timestamp: number): string {
    const date = new Date(timestamp);
    return `${date.getFullYear()}年${date.getMonth() + 1}月${date.getDate()}日 ${this.timeText(timestamp)}`;
  }

  private timeText(timestamp: number): string {
    const date = new Date(timestamp);
    return `${this.two(date.getHours())}:${this.two(date.getMinutes())}:${this.two(date.getSeconds())}`;
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

  private two(value: number): string {
    return value < 10 ? `0${value}` : `${value}`;
  }

  private eventIcon(title: string): string {
    if (title === '打鼾咳嗽' || title === '打鼾') {
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
}
