import { SleepColor } from '../../common/SleepDesign';
import { SoundSceneItem } from '../../models/SleepModels';
import { SoundPlayer } from '../../services/SoundPlayer';
import { SoundCoverImage } from '../common/CoverImages';

@Component
export struct NaturePlayerPage {
  @Prop scene: SoundSceneItem = { id: '', index: 1, title: '', subtitle: '', category: '', isBundledAudio: true };
  @Prop isPlaying: boolean = false;
  onBack: () => void = () => {};
  onToggle: () => void = () => {};
  @State private currentMs: number = 0;
  @State private durationMs: number = 1;
  @State private breathingLarge: boolean = false;
  private timer: number = -1;
  private breathTimer: number = -1;

  aboutToAppear(): void {
    this.timer = setInterval(() => {
      this.currentMs = SoundPlayer.currentTime();
      this.durationMs = Math.max(1, SoundPlayer.duration());
    }, 500);
    this.breathTimer = setInterval(() => this.breathingLarge = !this.breathingLarge, 3600);
  }

  aboutToDisappear(): void {
    if (this.timer >= 0) clearInterval(this.timer);
    if (this.breathTimer >= 0) clearInterval(this.breathTimer);
  }

  build() {
    Stack() {
      SoundCoverImage({ index: this.scene.index, directory: this.scene.directory ?? '', coverFile: this.scene.coverFile ?? 'cover.jpg', widthValue: '100%', heightValue: '100%', radius: 0 })
        .scale({ x: 1.25, y: 1.25 }).blur(34).opacity(0.72)
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      Column().width('100%').height('100%')
        .linearGradient({ angle: 135, colors: [['#B3254E56', 0], ['#C149767A', 0.55], ['#E620343C', 1]] })
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      Column() {
        Row() {
          Stack() { Image($rawfile('icons_sleep/ic_back.svg')).width(23).height(23).fillColor(Color.White) }
            .width(44).height(44).borderRadius(22).backgroundColor('#30FFFFFF')
            .border({ width: 1, color: '#28FFFFFF' }).onClick(this.onBack)
          Blank()
          Text(this.scene.title).fontSize(17).fontWeight(FontWeight.Medium).fontColor(Color.White)
          Blank()
          Row().width(44)
        }.height(62).width('100%')
        Blank()
        Stack() {
          Circle().width(274).height(274).border({ width: 1, color: '#24FFFFFF' })
          Circle().width(224).height(224).backgroundColor('#18FFFFFF')
          SoundCoverImage({ index: this.scene.index, directory: this.scene.directory ?? '', coverFile: this.scene.coverFile ?? 'cover.jpg', widthValue: 158, heightValue: 158, radius: 79 })
        }.scale({ x: this.isPlaying && this.breathingLarge ? 1.10 : 0.90, y: this.isPlaying && this.breathingLarge ? 1.10 : 0.90 })
          .animation({ duration: 3600, curve: Curve.EaseInOut })
        Blank()
        Column({ space: 18 }) {
          Row() {
            Column({ space: 6 }) {
              Text(this.scene.title).fontSize(19).fontWeight(FontWeight.Medium).fontColor(Color.White)
              Text(`${this.scene.subtitle.length > 0 ? this.scene.subtitle : '聆听自然，安然入眠'} · ${this.timeText(this.durationMs)}`)
                .fontSize(13).fontColor('#A8FFFFFF')
            }.alignItems(HorizontalAlign.Start)
            Blank()
            Stack() { Image(this.isPlaying ? $rawfile('icons_sleep/ic_pause.svg') : $rawfile('icons_sleep/ic_play.svg')).width(22).height(22).fillColor(SleepColor.primary) }
              .width(58).height(58).borderRadius(29).backgroundColor('#F2FFFFFF').onClick(this.onToggle)
          }.width('100%')
          Slider({ value: this.currentMs, min: 0, max: this.durationMs }).selectedColor(Color.White).trackColor('#50FFFFFF')
            .onChange((value: number, mode: SliderChangeMode) => { this.currentMs = value; if (mode === SliderChangeMode.End) SoundPlayer.seek(value); })
          Row() {
            Text(this.timeText(this.currentMs)).fontSize(11).fontColor('#9FFFFFFF')
            Blank()
            Text(`-${this.timeText(Math.max(0, this.durationMs - this.currentMs))}`).fontSize(11).fontColor('#9FFFFFFF')
          }.width('100%')
        }.padding(22).backgroundColor('#42FFFFFF').borderRadius(30).border({ width: 1, color: '#2AFFFFFF' })
      }.width('100%').height('100%').padding({ left: 22, right: 22, top: 26, bottom: 18 })
    }.width('100%').height('100%')
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }

  private timeText(milliseconds: number): string {
    const total = Math.floor(milliseconds / 1000); const seconds = total % 60;
    return `${Math.floor(total / 60)}:${seconds < 10 ? '0' : ''}${seconds}`;
  }
}
