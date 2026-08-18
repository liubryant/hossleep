import { common } from '@kit.AbilityKit';
import { SleepColor } from '../../common/SleepDesign';
import { MINDFULNESS_BANNERS, MINDFULNESS_ITEMS, MindfulnessBanner, MindfulnessItem, lastNatureScenes } from '../../models/MindfulnessData';
import { SoundSceneItem } from '../../models/SleepModels';
import { SoundPlayer } from '../../services/SoundPlayer';
import { SoundCoverImage } from '../common/CoverImages';

@Component
export struct MindfulnessHomePage {
  @Prop scenes: SoundSceneItem[] = [];
  @Prop downloadingSoundId: string = '';
  @Prop downloadProgress: number = -1;
  onBack: () => void = () => {};
  onOpenMeditation: (item: MindfulnessItem) => void = () => {};
  onOpenNature: (scene: SoundSceneItem) => void = () => {};
  @State private bannerIndex: number = 0;

  build() {
    Column() {
      this.topBar()
      Scroll() {
        Column({ space: 22 }) {
          this.hero()
          this.sectionTitle('正念冥想', '跟随声音，把注意力带回当下')
          this.meditationGrid()
          this.sectionTitle('大自然中入眠', '枕着山海风雨，慢慢沉入梦乡')
          this.natureGrid()
        }
        .padding({ bottom: 34 })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(SleepColor.background)
  }

  @Builder
  private topBar() {
    Row() {
      Stack() {
        Image($rawfile('icons_sleep/ic_back_modern.svg')).width(22).height(22)
      }
      .width(42).height(42).borderRadius(21).backgroundColor('#CCFFFFFF').onClick(this.onBack)
      Blank()
      Text('自在正念').fontSize(18).fontWeight(FontWeight.Medium).fontColor(SleepColor.textPrimary)
      Blank()
      Row().width(42)
    }
    .width('100%').height(60).padding({ left: 18, right: 18 })
    .backgroundColor(SleepColor.background)
  }

  @Builder
  private hero() {
    Column({ space: 10 }) {
      Swiper() {
        ForEach(MINDFULNESS_BANNERS, (banner: MindfulnessBanner) => {
          this.bannerCard(banner)
        })
      }
      .index(this.bannerIndex).autoPlay(true).interval(3000).loop(true).indicator(false)
      .duration(350).onChange((index: number) => this.bannerIndex = index)
      .width('100%').height(142)
      Row({ space: 7 }) {
        ForEach(MINDFULNESS_BANNERS, (bannerDot: MindfulnessBanner, index: number) => {
          Row().width(this.bannerIndex === index ? 20 : 7).height(7)
            .borderRadius(4).backgroundColor(this.bannerIndex === index ? '#B8111827' : '#2B111827')
        })
      }
    }
    .width('100%').padding({ left: 20, right: 20, top: 8 })
  }

  @Builder
  private bannerCard(banner: MindfulnessBanner) {
    Stack({ alignContent: Alignment.TopStart }) {
      Column().width('100%').height('100%')
        .linearGradient({ angle: 120, colors: [[banner.colors[0], 0], [banner.colors[1], 1]] })
      Column({ space: 10 }) {
        Text(banner.title).fontSize(18).fontWeight(FontWeight.Bold).fontColor(Color.White).maxLines(1)
        Text(banner.detail).fontSize(13).fontColor('#D9FFFFFF').lineHeight(20).maxLines(2)
      }
      .width('78%').alignItems(HorizontalAlign.Start).padding({ left: 24, top: 22 })
      Text('◌').fontSize(76).fontColor('#2EFFFFFF').position({ x: '76%', y: 36 })
    }
    .margin({ left: 6, right: 6 }).borderRadius(16).clip(true)
  }

  @Builder
  private sectionTitle(title: string, subtitle: string) {
    Column({ space: 4 }) {
      Text(title).fontSize(18).fontWeight(FontWeight.Medium).fontColor(SleepColor.textPrimary)
      Text(subtitle).fontSize(12).fontColor(SleepColor.textSecondary)
    }
    .width('100%').alignItems(HorizontalAlign.Start).padding({ left: 20, right: 20 })
  }

  @Builder
  private meditationGrid() {
    Scroll() {
      Row({ space: 12 }) {
        ForEach([0, 2, 4, 6], (startIndex: number) => {
          Column({ space: 12 }) {
            this.meditationCard(MINDFULNESS_ITEMS[startIndex])
            this.meditationCard(MINDFULNESS_ITEMS[startIndex + 1])
          }
        }, (startIndex: number) => `${startIndex}`)
      }
      .padding({ left: 20, right: 20 })
    }
    .width('100%').height(382).scrollable(ScrollDirection.Horizontal).scrollBar(BarState.Off)
  }

  @Builder
  private meditationCard(item: MindfulnessItem) {
    Column({ space: 8 }) {
      Stack({ alignContent: Alignment.BottomEnd }) {
        Image(`resource://RAWFILE/${item.cover}`).width(136).height(136)
          .objectFit(ImageFit.Cover).borderRadius(14).clip(true)
        Stack() { Image($rawfile('icons_sleep/ic_play.svg')).width(14).height(14).fillColor(Color.White) }
          .width(32).height(32).borderRadius(16).backgroundColor('#65000000').margin(9)
      }
      Text(item.title).width(136).fontSize(14).fontWeight(FontWeight.Medium).fontColor(SleepColor.textPrimary).maxLines(1)
      Text(item.subtitle).width(136).fontSize(11).fontColor(SleepColor.textSecondary).maxLines(1)
    }
    .width(136).height(185).alignItems(HorizontalAlign.Start).onClick(() => this.onOpenMeditation(item))
  }

  @Builder
  private natureGrid() {
    Scroll() {
      Row({ space: 12 }) {
        ForEach([0, 2, 4, 6, 8, 10, 12, 14, 16, 18], (startIndex: number) => {
          Column({ space: 12 }) {
            if (startIndex < this.natureItems().length) {
              this.natureCard(this.natureItems()[startIndex])
            }
            if (startIndex + 1 < this.natureItems().length) {
              this.natureCard(this.natureItems()[startIndex + 1])
            }
          }
        }, (startIndex: number) => `${startIndex}`)
      }
      .padding({ left: 20, right: 20 })
    }
    .width('100%').height(382).scrollable(ScrollDirection.Horizontal).scrollBar(BarState.Off)
  }

  @Builder
  private natureCard(scene: SoundSceneItem) {
    Column({ space: 8 }) {
      Stack({ alignContent: Alignment.BottomEnd }) {
        SoundCoverImage({ index: scene.index, directory: scene.directory ?? '', coverFile: scene.coverFile ?? 'cover.jpg', widthValue: 136, heightValue: 136, radius: 14 })
        if (this.downloadingSoundId === scene.id) {
          Text(`${Math.floor(Math.max(0, this.downloadProgress) * 100)}%`).fontSize(10).fontColor(Color.White)
            .width(38).height(38).textAlign(TextAlign.Center).backgroundColor('#88000000').borderRadius(19).margin(9)
        } else {
          Stack() {
            Image(SoundPlayer.isCached(getContext(this) as common.UIAbilityContext, scene) ?
              $rawfile('icons_sleep/ic_play.svg') : $rawfile('icons_sleep/ic_download.svg'))
              .width(14).height(14).fillColor(Color.White)
          }.width(32).height(32).borderRadius(16).backgroundColor('#65000000').margin(9)
        }
      }
      Text(scene.title).width(136).fontSize(14).fontWeight(FontWeight.Medium).fontColor(SleepColor.textPrimary).maxLines(1)
      Text(scene.subtitle.length > 0 ? scene.subtitle : '聆听自然，安然入眠').width(136).fontSize(11).fontColor(SleepColor.textSecondary).maxLines(1)
    }
    .width(136).height(185).alignItems(HorizontalAlign.Start).onClick(() => this.onOpenNature(scene))
  }

  private natureItems(): SoundSceneItem[] {
    return lastNatureScenes(this.scenes);
  }
}
