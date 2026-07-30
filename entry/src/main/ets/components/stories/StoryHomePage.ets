/**
 * @author liuzheng
 * @mail bryant_liu24@126.com
 */
import { SleepColor, SleepText } from '../../common/SleepDesign';
import { common } from '@kit.AbilityKit';
import { util } from '@kit.ArkTS';
import { STORY_ITEMS } from '../../models/SleepData';
import { StoryListItem } from '../../models/SleepModels';
import { StoryCard } from './StoryCard';

@Component
export struct StoryHomePage {
  @Prop activeStoryId: string = '';
  @Prop favoriteStoryIds: string[] = [];
  @Prop selectedTab: number = 0;
  @Prop allScrollOffset: number = 0;
  @Prop favoriteScrollOffset: number = 0;
  @Prop @Watch('onArticleSwitchChanged') articleEnabled: boolean = false;
  onOpenStory: (story: StoryListItem) => void = () => {};
  onToggleFavorite: (id: string) => void = () => {};
  onSelectTab: (index: number) => void = () => {};
  onScrollOffsetChange: (index: number, offset: number) => void = () => {};
  @State private stories: StoryListItem[] = STORY_ITEMS;
  @State private showTopButton: boolean = false;
  @State private searchKeyword: string = '';
  private allScroller: Scroller = new Scroller();
  private favoriteScroller: Scroller = new Scroller();

  aboutToAppear(): void {
    this.loadArticles();
    this.showTopButton = this.currentOffset() > 80;
    setTimeout(() => {
      this.restoreScrollPositions();
    }, 0);
  }

  private onArticleSwitchChanged(): void {
    this.loadArticles();
  }

  build() {
    Stack({ alignContent: Alignment.BottomEnd }) {
      Column({ space: 0 }) {
        Row({ space: 42 }) {
          this.storyTab('全部', 0)
          this.storyTab('收藏', 1)
        }
        .height(52)
        .width('100%')
        .justifyContent(FlexAlign.Center)

        this.searchBar()

        Swiper() {
          this.storyPage(0, this.allScroller)
          this.storyPage(1, this.favoriteScroller)
        }
        .index(this.selectedTab)
        .indicator(false)
        .loop(false)
        .duration(260)
        .onChange((index: number) => {
          this.onSelectTab(index);
          this.showTopButton =
            (index === 0 ? this.allScroller.currentOffset().yOffset :
              this.favoriteScroller.currentOffset().yOffset) > 80;
        })
        .layoutWeight(1)
      }
      .width('100%')
      .height('100%')

      if (this.showTopButton) {
        Column({ space: 1 }) {
          Text('↑')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
          Text('TOP')
            .fontSize(9)
            .fontColor(Color.White)
        }
        .width(52)
        .height(52)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .backgroundColor(SleepColor.primary)
        .borderRadius(26)
        .shadow({ radius: 10, color: '#28000000', offsetY: 3 })
        .margin({ right: 18, bottom: 104 })
        .onClick(() => {
          this.scrollCurrentPageToTop();
        })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(SleepColor.background)
  }

  @Builder
  private searchBar() {
    Row({ space: 8 }) {
      Image($rawfile('icons_sleep/ic_search_new.svg'))
        .width(19)
        .height(19)
        .fillColor(SleepColor.textSecondary)

      TextInput({ text: this.searchKeyword, placeholder: '搜索故事' })
        .fontSize(SleepText.subheadline)
        .fontColor(SleepColor.textPrimary)
        .placeholderColor(SleepColor.textTertiary)
        .caretColor(SleepColor.primary)
        .backgroundColor(Color.Transparent)
        .padding(0)
        .layoutWeight(1)
        .onChange((value: string) => {
          this.searchKeyword = value;
          this.resetCurrentScroll();
        })

      if (this.searchKeyword.length > 0) {
        Text('×')
          .fontSize(22)
          .fontColor(SleepColor.textSecondary)
          .width(26)
          .height(26)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.searchKeyword = '';
            this.resetCurrentScroll();
          })
      }
    }
    .height(40)
    .width('100%')
    .padding({ left: 12, right: 8 })
    .backgroundColor(SleepColor.secondaryBackground)
    .borderRadius(8)
    .margin({ left: 16, right: 16, bottom: 8 })
  }

  @Builder
  private storyTab(title: string, index: number) {
    Column({ space: 7 }) {
      Text(title)
        .fontSize(16)
        .fontWeight(this.selectedTab === index ? FontWeight.Bold : FontWeight.Regular)
        .fontColor(this.selectedTab === index ? SleepColor.primary : SleepColor.textSecondary)
      Column()
        .width(28)
        .height(3)
        .backgroundColor(this.selectedTab === index ? SleepColor.primary : Color.Transparent)
        .borderRadius(2)
    }
      .width(64)
      .height(44)
      .justifyContent(FlexAlign.End)
      .alignItems(HorizontalAlign.Center)
      .onClick(() => {
        this.onSelectTab(index);
      })
  }

  @Builder
  private storyPage(index: number, scroller: Scroller) {
    Stack({ alignContent: Alignment.Center }) {
      Grid(scroller) {
        ForEach(this.displayedStories(index), (story: StoryListItem) => {
          GridItem() {
            StoryCard({
              story: story,
              isPlaying: this.activeStoryId === story.id,
              isFavorite: this.favoriteStoryIds.includes(story.id),
              onOpen: () => {
                this.onOpenStory(story);
              },
              onFavorite: () => {
                this.onToggleFavorite(story.id);
              }
            })
            .width('100%')
            .height(186)
          }
        }, (story: StoryListItem) => story.id)
      }
      .columnsTemplate('1fr 1fr')
      .columnsGap(16)
      .rowsGap(16)
      .padding({ left: 16, right: 16, top: 8, bottom: 104 })
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Off)
      .onScroll(() => {
        const yOffset = scroller.currentOffset().yOffset;
        this.onScrollOffsetChange(index, yOffset);
        if (index === this.selectedTab) {
          this.showTopButton = yOffset > 80;
        }
      })

      if (this.displayedStories(index).length === 0) {
        Column({ space: 10 }) {
          Text(this.searchKeyword.trim().length > 0 ? '未找到相关故事' : '暂无收藏故事')
            .fontSize(16)
            .fontColor(SleepColor.textPrimary)
          Text(this.searchKeyword.trim().length > 0
            ? '换个故事试试'
            : '点击故事封面右上角的爱心即可收藏')
            .fontSize(13)
            .fontColor(SleepColor.textSecondary)
        }
        .alignItems(HorizontalAlign.Center)
      }
    }
    .width('100%')
    .height('100%')
  }

  private displayedStories(index: number): StoryListItem[] {
    let result = this.stories;
    if (index === 1) {
      result = result.filter((story: StoryListItem): boolean =>
        this.favoriteStoryIds.includes(story.id));
    }
    const keyword = this.searchKeyword.trim().toLowerCase();
    if (keyword.length === 0) {
      return result;
    }
    return result.filter((story: StoryListItem): boolean =>
      story.title.toLowerCase().includes(keyword) ||
      (story.author ?? '').toLowerCase().includes(keyword) ||
      (story.summary ?? '').toLowerCase().includes(keyword));
  }

  private currentOffset(): number {
    return this.selectedTab === 0 ? this.allScrollOffset : this.favoriteScrollOffset;
  }

  private restoreScrollPositions(): void {
    this.allScroller.scrollTo({ xOffset: 0, yOffset: this.allScrollOffset, animation: false });
    this.favoriteScroller.scrollTo({ xOffset: 0, yOffset: this.favoriteScrollOffset, animation: false });
  }

  private scrollCurrentPageToTop(): void {
    const scroller = this.selectedTab === 0 ? this.allScroller : this.favoriteScroller;
    scroller.scrollTo({ xOffset: 0, yOffset: 0, animation: true });
    this.onScrollOffsetChange(this.selectedTab, 0);
    this.showTopButton = false;
  }

  private resetCurrentScroll(): void {
    const scroller = this.selectedTab === 0 ? this.allScroller : this.favoriteScroller;
    scroller.scrollTo({ xOffset: 0, yOffset: 0, animation: false });
    this.onScrollOffsetChange(this.selectedTab, 0);
    this.showTopButton = false;
  }

  private async loadArticles(): Promise<void> {
    if (!this.articleEnabled) {
      this.stories = STORY_ITEMS;
      return;
    }
    try {
      const context = getContext(this) as common.UIAbilityContext;
      const bytes = await context.resourceManager
        .getRawFileContent('StoryResources/contemporary_articles.json');
      const text = util.TextDecoder.create('utf-8').decodeToString(bytes);
      const articles = JSON.parse(text) as StoryListItem[];
      this.stories = [...STORY_ITEMS, ...articles];
      setTimeout(() => {
        this.restoreScrollPositions();
      }, 0);
    } catch (_) {
      this.stories = STORY_ITEMS;
    }
  }
}
