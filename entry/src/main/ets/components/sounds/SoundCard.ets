/**
 * @author liuzheng
 * @mail bryant_liu24@126.com
 */
import { SleepColor, SleepRadius, SleepText } from '../../common/SleepDesign';
import { SoundSceneItem } from '../../models/SleepModels';
import { SoundCoverImage } from '../common/CoverImages';

@Component
export struct SoundCard {
  @Prop scene: SoundSceneItem = { id: '', index: 1, title: '', subtitle: '', category: '', isBundledAudio: true };
  @Prop isPlaying: boolean = false;
  @Prop isFavorite: boolean = false;
  @Prop isCached: boolean = true;
  @Prop downloadProgress: number = -1;
  onToggle: () => void = () => {};
  onFavorite: () => void = () => {};

  build() {
    Stack({ alignContent: Alignment.BottomEnd }) {
      Column({ space: 10 }) {
        Stack({ alignContent: Alignment.TopEnd }) {
          SoundCoverImage({
            index: this.scene.index,
            directory: this.scene.directory ?? '',
            coverFile: this.scene.coverFile ?? 'cover.jpg',
            widthValue: '100%',
            heightValue: 136,
            radius: SleepRadius.card
          })

          Stack() {
            Image(this.isFavorite ?
              $rawfile('icons_sleep/ic_heart_red.svg') : $rawfile('icons_sleep/ic_heart_outline.svg'))
              .width(16)
              .height(16)
          }
          .width(30)
          .height(30)
          .backgroundColor('#40000000')
          .borderRadius(15)
          .margin({ top: 7, right: 7 })
          .hitTestBehavior(HitTestMode.Block)
          .onClick(() => {
            this.onFavorite();
          })

          if (this.downloadProgress >= 0) {
            Column({ space: 10 }) {
              Text('正在下载')
                .fontFamily('MiSans')
                .fontSize(13)
                .fontColor(Color.White)
                .fontWeight(FontWeight.Medium)
              Progress({ value: this.downloadProgress, total: 1, type: ProgressType.Linear })
                .width('76%')
                .height(6)
                .color(Color.White)
                .backgroundColor('#50FFFFFF')
                .borderRadius(3)
              Text(`${Math.floor(this.downloadProgress * 100)}%`)
                .fontFamily('MiSans')
                .fontSize(12)
                .fontColor(Color.White)
                .fontWeight(FontWeight.Bold)
            }
            .width('100%')
            .height('100%')
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
            .backgroundColor('#99000000')
            .borderRadius(SleepRadius.card)
            .align(Alignment.Center)
            .zIndex(5)
          } else if (!this.scene.isBundledAudio && !this.isCached) {
            Stack() {
              Image($rawfile('icons_sleep/ic_download.svg'))
                .width(18)
                .height(18)
                .fillColor(Color.White)
            }
            .width(34)
            .height(34)
            .backgroundColor('#59000000')
            .borderRadius(17)
            .align(Alignment.BottomEnd)
            .margin({ right: 8, bottom: 8 })
          }
        }
        .width('100%')
        .height(136)

        Column({ space: 4 }) {
          Text(this.scene.title)
            .fontSize(SleepText.headline)
            .fontWeight(FontWeight.Medium)
            .fontColor(SleepColor.textPrimary)
            .maxLines(1)

          Text(this.scene.subtitle.length === 0 ? '助眠声音' : this.scene.subtitle)
            .fontSize(SleepText.caption)
            .fontColor(SleepColor.textSecondary)
            .lineHeight(17)
            .maxLines(2)
            .height(34)
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
      }
      .padding(10)
      .backgroundColor(SleepColor.secondaryBackground)
      .borderRadius(SleepRadius.card)
      .onClick(() => {
        this.onToggle();
      })

      if (this.isPlaying) {
        Stack() {
          Image($rawfile('icons_sleep/sound_wave_playing.gif'))
            .width(22)
            .height(22)
            .objectFit(ImageFit.Contain)
        }
        .width(34)
        .height(34)
        .backgroundColor(Color.Transparent)
        .borderRadius(17)
        .margin({ right: 14, bottom: 14 })
      }
    }
    .width('100%')
    .height(220)
  }
}
