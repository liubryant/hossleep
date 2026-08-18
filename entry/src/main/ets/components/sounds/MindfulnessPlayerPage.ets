import { common } from '@kit.AbilityKit';
import { promptAction } from '@kit.ArkUI';
import { MindfulnessItem } from '../../models/MindfulnessData';
import { MindfulnessPlayer } from '../../services/MindfulnessPlayer';

@Component
export struct MindfulnessPlayerPage {
  @Prop item: MindfulnessItem = { id: '', title: '', subtitle: '', cover: '', audio: '', colors: ['#294F57', '#3B686B'] };
  onBack: () => void = () => {};
  @State private isPlaying: boolean = false;
  @State private isFavorite: boolean = false;
  @State private currentMs: number = 0;
  @State private durationMs: number = 1;
  @State private breathingLarge: boolean = false;
  @State private timerRemainingSeconds: number = 0;
  private progressTimer: number = -1;
  private breathTimer: number = -1;
  private stopTimer: number = -1;

  aboutToAppear(): void {
    MindfulnessPlayer.play(getContext(this) as common.UIAbilityContext, this.item.audio).then(() => {
      this.isPlaying = true;
    }).catch(() => promptAction.showToast({ message: '音频加载失败' }));
    this.progressTimer = setInterval(() => {
      this.currentMs = MindfulnessPlayer.currentTime();
      this.durationMs = Math.max(1, MindfulnessPlayer.duration());
      this.isPlaying = MindfulnessPlayer.isPlaying();
    }, 500);
    this.breathTimer = setInterval(() => this.breathingLarge = !this.breathingLarge, 3600);
  }

  aboutToDisappear(): void {
    if (this.progressTimer >= 0) clearInterval(this.progressTimer);
    if (this.breathTimer >= 0) clearInterval(this.breathTimer);
    this.clearStopTimer();
    MindfulnessPlayer.stop(getContext(this) as common.UIAbilityContext);
  }

  build() {
    Stack() {
      Image(`resource://RAWFILE/${this.item.cover}`)
        .width('100%').height('100%').objectFit(ImageFit.Cover)
        .scale({ x: 1.25, y: 1.25 }).blur(34).opacity(0.72)
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      Column().width('100%').height('100%')
        .linearGradient({ angle: 135, colors: [['#B3264650', 0], ['#C13C6269', 0.52], ['#E620343C', 1]] })
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      Column() {
        this.topBar()
        Blank()
        this.breathingArtwork()
        Blank()
        this.playerPanel()
      }
      .width('100%').height('100%').padding({ left: 22, right: 22, top: 26, bottom: 18 })
    }
    .width('100%').height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }

  @Builder
  private topBar() {
    Row() {
      Stack() { Image($rawfile('icons_sleep/ic_back_white.svg')).width(23).height(23) }
        .width(44).height(44).borderRadius(22).backgroundColor('#30FFFFFF')
        .border({ width: 1, color: '#28FFFFFF' }).onClick(this.onBack)
      Blank()
      Text(this.item.title).fontSize(17).fontWeight(FontWeight.Medium).fontColor(Color.White)
      Blank()
      Row().width(44)
    }.width('100%').height(62)
  }

  @Builder
  private breathingArtwork() {
    Stack() {
      Stack()
        .width(250).height(250)
        .borderRadius(125)
        .border({ width: 1, color: '#14FFFFFF' })
      Stack()
        .width(210).height(210)
        .borderRadius(105)
        .backgroundColor('#0FFFFFFF')
        .border({ width: 1, color: '#2EFFFFFF' })
      Stack()
        .width(150).height(150)
        .borderRadius(75)
        .linearGradient({ angle: 135, colors: [['#4DFFFFFF', 0], ['#2AB8E7D5', 1]] })
        .shadow({ radius: 28, color: '#30000000', offsetY: 16 })
      Column({ space: 9 }) {
        Image($rawfile('icons_sleep/category_mindfulness.svg')).width(52).height(52).opacity(0.9)
        Column({ space: 4 }) {
          Text(this.isPlaying ? '跟随声音' : '片刻暂停').fontSize(13).fontWeight(FontWeight.Medium).fontColor('#D6FFFFFF')
          Text(this.isPlaying ? '回到当下' : '保持觉察').fontSize(13).fontWeight(FontWeight.Medium).fontColor('#D6FFFFFF')
        }
      }
    }
    .width(250).height(250)
    .scale({ x: this.isPlaying && this.breathingLarge ? 1.10 : 0.90, y: this.isPlaying && this.breathingLarge ? 1.10 : 0.90 })
    .animation({ duration: 3600, curve: Curve.EaseInOut })
  }

  @Builder
  private playerPanel() {
    Column({ space: 18 }) {
      Row({ space: 14 }) {
        Column({ space: 6 }) {
          Text(this.item.title).fontSize(19).fontWeight(FontWeight.Medium).fontColor(Color.White)
          Text(`${this.item.subtitle} · ${this.timeText(this.durationMs)}`).fontSize(13).fontColor('#A8FFFFFF')
        }.alignItems(HorizontalAlign.Start)
        Blank()
        Stack() {
          Image(this.isPlaying ? $rawfile('icons_sleep/ic_pause.svg') : $rawfile('icons_sleep/ic_play.svg'))
            .width(22).height(22).fillColor(this.item.colors[0])
        }.width(58).height(58).borderRadius(29).backgroundColor('#F2FFFFFF').onClick(() => this.toggle())
      }.width('100%')

      Column({ space: 5 }) {
        Slider({ value: this.currentMs, min: 0, max: this.durationMs })
          .selectedColor(Color.White).trackColor('#50FFFFFF').trackThickness(4)
          .onChange((value: number, mode: SliderChangeMode) => {
            this.currentMs = value;
            if (mode === SliderChangeMode.End) MindfulnessPlayer.seek(value);
          })
        Row() {
          Text(this.timeText(this.currentMs)).fontSize(11).fontColor('#9FFFFFFF')
          Blank()
          Text(`-${this.timeText(Math.max(0, this.durationMs - this.currentMs))}`).fontSize(11).fontColor('#9FFFFFFF')
        }.width('100%')
      }

      Row({ space: 9 }) {
        this.actionButton(this.isFavorite ? '已收藏' : '收藏', this.isFavorite ? '♥' : '♡', () => this.isFavorite = !this.isFavorite)
        this.timerButton()
        this.actionButton('后退15秒', '↶', () => this.skip(-15000))
        this.actionButton('前进15秒', '↷', () => this.skip(15000))
      }.width('100%')
    }
    .width('100%').padding(22).backgroundColor('#42FFFFFF').borderRadius(30)
    .border({ width: 1, color: '#2AFFFFFF' })
  }

  @Builder
  private actionButton(title: string, icon: string, action: () => void) {
    Column({ space: 6 }) {
      Text(icon).fontSize(20).fontColor(Color.White)
      Text(title).fontSize(10).fontColor('#D6FFFFFF').maxLines(1)
    }
    .layoutWeight(1).height(62).justifyContent(FlexAlign.Center).backgroundColor('#15FFFFFF').borderRadius(17).onClick(action)
  }

  @Builder
  private timerButton() {
    Column({ space: 6 }) {
      Text('◷').fontSize(20).fontColor(Color.White)
      Text(this.timerRemainingSeconds > 0 ? `${Math.ceil(this.timerRemainingSeconds / 60)}分钟` : '定时')
        .fontSize(10).fontColor('#D6FFFFFF').maxLines(1)
    }
    .layoutWeight(1)
    .height(62)
    .justifyContent(FlexAlign.Center)
    .backgroundColor(this.timerRemainingSeconds > 0 ? '#32FFFFFF' : '#15FFFFFF')
    .borderRadius(17)
    .bindMenu([
      { value: '15分钟后停止', action: () => this.startStopTimer(15) },
      { value: '30分钟后停止', action: () => this.startStopTimer(30) },
      { value: '45分钟后停止', action: () => this.startStopTimer(45) },
      { value: '60分钟后停止', action: () => this.startStopTimer(60) },
      { value: '取消定时', action: () => this.cancelStopTimer() }
    ])
  }

  private toggle(): void {
    MindfulnessPlayer.toggle().then((playing: boolean) => this.isPlaying = playing);
  }

  private skip(delta: number): void {
    const target = Math.max(0, Math.min(this.durationMs, this.currentMs + delta));
    this.currentMs = target;
    MindfulnessPlayer.seek(target);
  }

  private startStopTimer(minutes: number): void {
    this.clearStopTimer();
    this.timerRemainingSeconds = minutes * 60;
    this.stopTimer = setInterval(() => {
      this.timerRemainingSeconds = Math.max(0, this.timerRemainingSeconds - 1);
      if (this.timerRemainingSeconds === 0) {
        this.clearStopTimer();
        if (MindfulnessPlayer.isPlaying()) {
          MindfulnessPlayer.toggle().then(() => this.isPlaying = false);
        }
        promptAction.showToast({ message: '定时播放已结束' });
      }
    }, 1000);
    promptAction.showToast({ message: `将在${minutes}分钟后停止播放` });
  }

  private cancelStopTimer(): void {
    const wasActive = this.timerRemainingSeconds > 0;
    this.clearStopTimer();
    if (wasActive) {
      promptAction.showToast({ message: '已取消定时停止' });
    }
  }

  private clearStopTimer(): void {
    if (this.stopTimer >= 0) {
      clearInterval(this.stopTimer);
      this.stopTimer = -1;
    }
    this.timerRemainingSeconds = 0;
  }

  private timeText(milliseconds: number): string {
    const total = Math.floor(milliseconds / 1000);
    const seconds = total % 60;
    return `${Math.floor(total / 60)}:${seconds < 10 ? '0' : ''}${seconds}`;
  }
}
