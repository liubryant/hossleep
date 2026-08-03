/**
 * @author liuzheng
 * @mail bryant_liu24@126.com
 */
import { SleepColor, SleepRadius, SleepText } from '../../common/SleepDesign';
import { StoryListItem } from '../../models/SleepModels';
import { StoryCoverImage } from '../common/CoverImages';

@Component
export struct StoryCard {
  @Prop story: StoryListItem = { id: '', index: 1, title: '', durationText: '', isBundled: true };
  @Prop isPlaying: boolean = false;
  @Prop isFavorite: boolean = false;
  onOpen: () => void = () => {};
  onFavorite: () => void = () => {};

  build() {
    Column({ space: 6 }) {
      Stack({ alignContent: Alignment.TopEnd }) {
        StoryCoverImage({
          index: this.story.index,
          coverFile: this.story.coverFile ?? '',
          widthValue: '100%',
          heightValue: 120,
          radius: SleepRadius.card
        })

        Stack() {
          Image(this.isFavorite
            ? $rawfile('icons_sleep/ic_heart_red.svg')
            : $rawfile('icons_sleep/ic_heart_outline.svg'))
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
      }
      .width('100%')
      .height(120)

      Row({ space: 8 }) {
        Column({ space: 2 }) {
          Text(this.displayTitle())
            .fontFamily('MiSans')
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor(SleepColor.textPrimary)
            .textAlign(TextAlign.Start)
            .width('100%')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

        }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)

        if (this.isPlaying) {
          Image($rawfile('icons_sleep/sound_wave_playing.gif'))
            .width(22)
            .height(22)
            .objectFit(ImageFit.Contain)
        }
      }
      .width('100%')
      .height(34)
      .alignItems(VerticalAlign.Center)
    }
    .padding(8)
    .width('100%')
    .height(176)
    .backgroundColor(SleepColor.secondaryBackground)
    .borderRadius(SleepRadius.card)
    .onClick(() => {
      this.onOpen();
    })
  }

  private displayTitle(): string {
    const author = (this.story.author ?? '').trim();
    let title = this.story.title.trim();
    if (author.length > 0 && title.endsWith(author)) {
      title = title.substring(0, title.length - author.length)
        .replace(/[·•｜|—–\-：:，,\s]+$/, '')
        .trim();
    }
    return title.length > 0 ? title : this.story.title;
  }
}
