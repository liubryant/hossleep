import { SleepColor, SleepText } from '../../common/SleepDesign';
import { PROFILE_ABOUT_ROWS } from '../../models/SleepData';
import { ProfileRowItem } from '../../models/SleepModels';

@Component
export struct ProfilePage {
  @Prop isLoggedIn: boolean = false;
  @Prop saveClips: boolean = true;
  @Prop sensitivity: number = 65;
  @Prop userPhone: string = '';
  @Prop isVip: boolean = false;
  onLogin: () => void = () => {};
  onLogout: () => void = () => {};
  onToggleSaveClips: () => void = () => {};
  onSensitivityChange: (value: number) => void = () => {};
  onOpenAction: (action: string) => void = () => {};
  @State private accountDialogVisible: boolean = false;

  build() {
    Stack() {
      Scroll() {
        Column({ space: 18 }) {
          Text('我的')
            .fontFamily('MiSans')
            .fontSize(26)
            .fontWeight(FontWeight.Bold)
            .fontColor(SleepColor.textPrimary)
            .width('100%')
            .textAlign(TextAlign.Start)
            .padding({ left: 4 })

          this.header()
          this.permissionCard()
          this.monitorCard()
          this.dataCard()
          this.linkSection('关于', PROFILE_ABOUT_ROWS)
        }
        .padding({ left: 16, right: 16, top: 16, bottom: 112 })
      }
      .width('100%')
      .height('100%')
      .backgroundColor(SleepColor.background)
      .scrollBar(BarState.Off)

      if (this.accountDialogVisible) {
        this.accountDialog()
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(SleepColor.background)
  }

  @Builder
  private vipCard() {
    Column({ space: 12 }) {
      Row({ space: 11 }) {
        Text('✦')
          .fontFamily('MiSans')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#4B2A12')
          .width(38)
          .height(38)
          .textAlign(TextAlign.Center)
          .backgroundColor('#F4CF8A')
          .borderRadius(19)

        Column({ space: 4 }) {
          Text(this.isVip ? '时光睡眠 VIP 会员' : '开通 VIP 会员')
            .fontFamily('MiSans')
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFF2D2')
          Text(this.isVip ? '会员权益已生效，可继续续费' : '解锁全部声音、故事与睡眠报告')
            .fontFamily('MiSans')
            .fontSize(11)
            .fontColor('#C8A97E')
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        Text(this.isVip ? '立即续费' : '立即开通')
          .fontFamily('MiSans')
          .fontSize(11)
          .fontWeight(FontWeight.Bold)
          .fontColor('#4F2D16')
          .height(30)
          .padding({ left: 12, right: 12 })
          .textAlign(TextAlign.Center)
          .backgroundColor('#F4CF8A')
          .borderRadius(15)
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)

      Divider().color('#22FFFFFF')

      Row() {
        this.vipBenefit('✦ 全部助眠声音')
        Divider().vertical(true).height(12).color('#33FFFFFF')
        this.vipBenefit('✦ 全部睡前故事')
        Divider().vertical(true).height(12).color('#33FFFFFF')
        this.vipBenefit('✦ 专属睡眠报告')
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .height(132)
    .padding({ left: 18, right: 18, top: 13, bottom: 11 })
    .justifyContent(FlexAlign.SpaceBetween)
    .linearGradient({
      angle: 135,
      colors: [['#34251B', 0], ['#17100C', 1]] as [string, number][]
    })
    .border({ width: 1, color: '#765437' })
    .borderRadius(16)
    .onClick(() => this.onOpenAction('vip'))
  }

  @Builder
  private vipBenefit(title: string) {
    Text(title)
      .fontFamily('MiSans')
      .fontSize(9)
      .fontColor('#EECC9A')
      .textAlign(TextAlign.Center)
      .layoutWeight(1)
  }

  @Builder
  private header() {
    Row({ space: 16 }) {
      Stack() {
        Column()
          .width(64)
          .height(64)
          .linearGradient({
            angle: 135,
            colors: [['#1677FF', 0], ['#66B2FF', 1]] as [string, number][]
          })
          .borderRadius(32)

        Image($rawfile('icons_sleep/ic_profile_agentclaw.svg'))
          .width(38)
          .height(38)
      }
      .width(64)
      .height(64)

      Column({ space: 5 }) {
        Text(this.isLoggedIn ? this.userPhone : '登录时光睡眠')
          .fontFamily('MiSans-DemiBold')
          .fontSize(19)
          .fontColor('#19191F')
          .maxLines(1)
        Text(this.isLoggedIn ? '账号已登录' : '同步账号，解锁更多功能')
          .fontFamily('MiSans')
          .fontSize(12)
          .fontColor('#73727E')
          .maxLines(1)
      }
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Center)
      .layoutWeight(1)

      Text(this.isLoggedIn ? '账号' : '登录')
        .fontFamily('MiSans')
        .fontSize(13)
        .fontColor(Color.White)
        .height(38)
        .constraintSize({ minWidth: 72 })
        .padding({ left: 16, right: 16 })
        .textAlign(TextAlign.Center)
        .linearGradient({
          angle: 0,
          colors: [['#1677FF', 0], ['#4C9AFF', 1]] as [string, number][]
        })
        .borderRadius(19)
        .hitTestBehavior(HitTestMode.Block)
        .onClick(() => {
          if (this.isLoggedIn) {
            this.accountDialogVisible = true;
          } else {
            this.onLogin();
          }
        })
    }
    .width('100%')
    .height(116)
    .padding({ left: 18, right: 18 })
    .alignItems(VerticalAlign.Center)
    .backgroundColor('#EAF3FF')
    .border({ width: 1, color: '#263392FF' })
    .borderRadius(24)
    .onClick(() => {
      if (this.isLoggedIn) {
        this.accountDialogVisible = true;
      } else {
        this.onLogin();
      }
    })
  }

  @Builder
  private permissionCard() {
    Column({ space: 9 }) {
      this.sectionTitle('权限')
      Row({ space: 10 }) {
        this.iconBox($rawfile('icons_sleep/ic_mic_solid.svg'), SleepColor.primary)
        Text('麦克风')
          .fontFamily('MiSans')
          .fontSize(15)
          .fontColor(SleepColor.textPrimary)
        Blank()
        Text('使用时申请')
          .fontFamily('MiSans')
          .fontSize(14)
          .fontColor(SleepColor.textSecondary)
      }
      .width('100%')
      .height(54)
      .padding({ left: 16, right: 16 })
      .backgroundColor(Color.White)
      .borderRadius(12)
    }
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  private monitorCard() {
    Column({ space: 9 }) {
      this.sectionTitle('睡眠监测')
      Column() {
        Row() {
          Text('保存识别片段')
            .fontFamily('MiSans')
            .fontSize(15)
            .fontColor(SleepColor.textPrimary)
          Blank()
          Toggle({ type: ToggleType.Switch, isOn: this.saveClips })
            .selectedColor(SleepColor.primary)
            .onChange(() => this.onToggleSaveClips())
        }
        .width('100%')
        .height(52)
        Divider().color(SleepColor.divider)
        Column({ space: 10 }) {
          Row() {
            Text('识别灵敏度')
              .fontFamily('MiSans')
              .fontSize(15)
              .fontColor(SleepColor.textPrimary)
            Blank()
            Text(`${Math.round(this.sensitivity)}%`)
              .fontFamily('MiSans')
              .fontSize(14)
              .fontColor(SleepColor.textSecondary)
          }
          .width('100%')
          Slider({ value: this.sensitivity, min: 30, max: 95 })
            .selectedColor(SleepColor.primary)
            .trackColor('#E3E5EB')
            .onChange((value: number) => this.onSensitivityChange(value))
        }
        .padding({ top: 13, bottom: 13 })
      }
      .width('100%')
      .padding({ left: 16, right: 16 })
      .backgroundColor(Color.White)
      .borderRadius(12)
    }
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  private dataCard() {
    Column({ space: 9 }) {
      this.sectionTitle('数据')
      Column() {
        Row({ space: 10 }) {
          this.iconBox($rawfile('icons_sleep/ic_storage_solid.svg'), SleepColor.primary)
          Text('数据大小')
            .fontFamily('MiSans')
            .fontSize(15)
            .fontColor(SleepColor.textPrimary)
          Blank()
          Text('12.6 MB')
            .fontFamily('MiSans')
            .fontSize(14)
            .fontColor(SleepColor.textSecondary)
        }
        .width('100%')
        .height(54)
        Divider().color(SleepColor.divider)
        Row({ space: 10 }) {
          this.iconBox($rawfile('icons_sleep/ic_delete_solid.svg'), SleepColor.destructive)
          Text('清除数据')
            .fontFamily('MiSans')
            .fontSize(15)
            .fontColor(SleepColor.destructive)
          Blank()
          this.chevron()
        }
        .width('100%')
        .height(54)
        .onClick(() => this.onOpenAction('clearData'))
      }
      .width('100%')
      .padding({ left: 16, right: 16 })
      .backgroundColor(Color.White)
      .borderRadius(12)
    }
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  private linkSection(title: string, rows: ProfileRowItem[]) {
    Column({ space: 9 }) {
      this.sectionTitle(title)
      Column() {
        ForEach(rows, (row: ProfileRowItem, index: number) => {
          Row() {
            Text(row.title)
              .fontFamily('MiSans')
              .fontSize(15)
              .fontColor(row.destructive ? SleepColor.destructive : SleepColor.textPrimary)
            Blank()
            if (row.value.length > 0) {
              Text(row.value)
                .fontFamily('MiSans')
                .fontSize(14)
                .fontColor(SleepColor.textSecondary)
            } else {
              this.chevron()
            }
          }
          .width('100%')
          .height(52)
          .onClick(() => {
            if (row.action.length > 0) {
              this.onOpenAction(row.action);
            }
          })
          if (index < rows.length - 1) {
            Divider().color(SleepColor.divider)
          }
        }, (row: ProfileRowItem) => row.title)
      }
      .width('100%')
      .padding({ left: 16, right: 16 })
      .backgroundColor(Color.White)
      .borderRadius(12)
    }
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  private sectionTitle(title: string) {
    Text(title)
      .fontFamily('MiSans')
      .fontSize(13)
      .fontWeight(FontWeight.Medium)
      .fontColor(SleepColor.primary)
      .padding({ left: 4 })
  }

  @Builder
  private iconBox(source: ResourceStr, color: string) {
    Image(source)
      .width(20)
      .height(20)
      .fillColor(color)
  }

  @Builder
  private chevron() {
    Image($rawfile('icons_sleep/ic_chevron_right.svg'))
      .width(20)
      .height(20)
  }

  @Builder
  private accountDialog() {
    Stack() {
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('#33000000')
        .onClick(() => {
          this.accountDialogVisible = false;
        })

      Column({ space: 0 }) {
        Row() {
          Column({ space: 5 }) {
            Text('登录时光睡眠')
              .fontFamily('MiSans-DemiBold')
              .fontSize(22)
              .fontColor(SleepColor.textPrimary)
            Text('管理当前登录账号')
              .fontFamily('MiSans')
              .fontSize(13)
              .fontColor(SleepColor.textSecondary)
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)

          Stack() {
            Image($rawfile('icons_sleep/ic_close.svg'))
              .width(16)
              .height(16)
              .fillColor(SleepColor.textPrimary)
          }
          .width(34)
          .height(34)
          .backgroundColor(SleepColor.secondaryBackground)
          .borderRadius(17)
          .onClick(() => {
            this.accountDialogVisible = false;
          })
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)

        Text(`已登录账号：${this.userPhone}`)
          .fontFamily('MiSans-DemiBold')
          .fontSize(15)
          .fontColor(SleepColor.textPrimary)
          .width('100%')
          .margin({ top: 22, bottom: 16 })

        Text('设置密码')
          .fontFamily('MiSans-DemiBold')
          .fontSize(15)
          .fontColor(Color.White)
          .width('100%')
          .height(46)
          .textAlign(TextAlign.Center)
          .linearGradient({
            angle: 0,
            colors: [['#1677FF', 0], ['#4C9AFF', 1]] as [string, number][]
          })
          .borderRadius(10)
          .onClick(() => {
            this.accountDialogVisible = false;
            this.onOpenAction('password');
          })

        Text('退出登录')
          .fontFamily('MiSans-DemiBold')
          .fontSize(15)
          .fontColor(SleepColor.destructive)
          .width('100%')
          .height(46)
          .textAlign(TextAlign.Center)
          .backgroundColor('#FFF2F2')
          .borderRadius(10)
          .margin({ top: 10 })
          .onClick(() => {
            this.accountDialogVisible = false;
            this.onLogout();
          })
      }
      .width('92%')
      .padding({ left: 28, right: 28, top: 24, bottom: 24 })
      .backgroundColor(Color.White)
      .borderRadius(20)
      .shadow({ radius: 24, color: '#26000000', offsetY: 8 })
    }
    .width('100%')
    .height('100%')
    .alignContent(Alignment.Center)
  }
}
