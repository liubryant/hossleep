/**
 * @author liuzheng
 * @mail bryant_liu24@126.com
 */
import { SleepColor, SleepText } from '../../common/SleepDesign';
import { common } from '@kit.AbilityKit';
import { util } from '@kit.ArkTS';
import { SOUND_CATEGORIES, SOUND_SCENES } from '../../models/SleepData';
import { SoundSceneItem } from '../../models/SleepModels';
import { SoundPlayer } from '../../services/SoundPlayer';
import { SoundCard } from './SoundCard';

interface SoundManifestItem {
  id: string;
  index: number;
  directory: string;
  title: string;
  subtitle: string;
  category: string;
  coverFile: string;
  audioFile: string;
}

@Component
export struct SoundHomePage {
  @Prop selectedCategory: number = 0;
  @Prop activeSoundId: string = '';
  @Prop downloadingSoundId: string = '';
  @Prop downloadProgress: number = -1;
  @Prop favoriteSoundIds: string[] = [];
  onSelectCategory: (index: number) => void = () => {};
  onOpenStories: () => void = () => {};
  onPlaySound: (scene: SoundSceneItem) => void = () => {};
  onToggleFavorite: (id: string) => void = () => {};
  @State private scenes: SoundSceneItem[] = SOUND_SCENES;
  @State private searchKeyword: string = '';

  aboutToAppear(): void {
    this.loadScenes();
  }

  build() {
    Column({ space: 0 }) {
      this.topBar()
      this.featureCategories()
      this.searchBar()

      if (this.displayedScenes().length === 0) {
        this.emptyState()
      } else {
        Grid() {
          ForEach(this.displayedScenes(), (scene: SoundSceneItem) => {
            GridItem() {
              SoundCard({
                scene: scene,
                isPlaying: this.activeSoundId === scene.id,
                isFavorite: this.favoriteSoundIds.includes(scene.id),
                isCached: SoundPlayer.isCached(getContext(this) as common.UIAbilityContext, scene),
                downloadProgress: this.downloadingSoundId === scene.id ? this.downloadProgress : -1,
                onToggle: () => {
                  this.onPlaySound(scene);
                },
                onFavorite: () => {
                  this.onToggleFavorite(scene.id);
                }
              })
              .width('100%')
              .height(220)
            }
            .height(220)
          }, (scene: SoundSceneItem) => scene.id)
        }
        .columnsTemplate('1fr 1fr')
        .columnsGap(12)
        .rowsGap(6)
        .padding({ left: 16, right: 16, top: 4, bottom: 108 })
        .layoutWeight(1)
        .scrollBar(BarState.Off)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(SleepColor.background)
  }

  @Builder
  private featureCategories() {
    Grid() {
      GridItem() {
        this.featureItem('白噪音', $rawfile('icons_sleep/category_white_noise.svg'), 0,
          () => this.onSelectCategory(0))
      }
      GridItem() {
        this.featureItem('舒眠放松', $rawfile('icons_sleep/category_relax.svg'), 4,
          () => this.onSelectCategory(4))
      }
      GridItem() {
        this.featureItem('我的收藏', $rawfile('icons_sleep/category_dream.svg'), 2,
          () => this.onSelectCategory(2))
      }
      GridItem() {
        this.featureItem('睡前故事', $rawfile('icons_sleep/category_story.svg'), -1,
          () => this.onOpenStories())
      }
      GridItem() {
        this.featureItem('自然之声', $rawfile('icons_sleep/category_nature.svg'), 5,
          () => this.onSelectCategory(5))
      }
      GridItem() {
        this.featureItem('沉浸学习', $rawfile('icons_sleep/category_focus.svg'), 6,
          () => this.onSelectCategory(6))
      }
      GridItem() {
        this.featureItem('自在正念', $rawfile('icons_sleep/category_mindfulness.svg'), 9,
          () => this.onSelectCategory(9))
      }
      GridItem() {
        this.featureItem('冥想专题', $rawfile('icons_sleep/category_meditation.svg'), 3,
          () => this.onSelectCategory(3))
      }
    }
    .columnsTemplate('1fr 1fr 1fr 1fr')
    .rowsTemplate('1fr 1fr')
    .columnsGap(4)
    .rowsGap(10)
    .width('100%')
    .height(156)
    .padding({ left: 12, right: 12, bottom: 8 })
  }

  @Builder
  private featureItem(title: string, icon: ResourceStr, categoryIndex: number, onClick: () => void) {
    Column({ space: 4 }) {
      Stack() {
        Image(icon)
          .width(48)
          .height(48)
      }
      .width(56)
      .height(54)
      .alignContent(Alignment.Center)
      .backgroundColor(this.selectedCategory === categoryIndex ? '#141677FF' : '#00000000')
      .borderRadius(16)

      Text(title)
        .fontFamily('MiSans')
        .fontSize(12)
        .fontWeight(this.selectedCategory === categoryIndex ? FontWeight.Medium : FontWeight.Normal)
        .fontColor(this.selectedCategory === categoryIndex ? SleepColor.primary : SleepColor.textSecondary)
        .maxLines(1)
    }
    .width('100%')
    .height(72)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .onClick(onClick)
  }

  @Builder
  private topBar() {
    Row() {
      Row({ space: 12 }) {
        Image($r('app.media.app_icon'))
          .width(36)
          .height(36)
          .borderRadius(9)

        Text(`${this.timeGreeting()}，时光睡眠！`)
          .fontSize(SleepText.title3)
          .fontWeight(FontWeight.Medium)
          .fontColor(SleepColor.textPrimary)
      }

      Blank()

      Stack() {
        Image($rawfile('icons_sleep/ic_sliders.svg'))
          .width(21)
          .height(21)
          .fillColor(SleepColor.textPrimary)
      }
      .width(38)
      .height(38)
      .backgroundColor(SleepColor.secondaryBackground)
      .borderRadius(19)
      .bindMenu([
        { value: '全部声音', action: () => this.onSelectCategory(0) },
        { value: '推荐声音', action: () => this.onSelectCategory(1) },
        { value: '我的收藏', action: () => this.onSelectCategory(2) }
      ])
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 22, bottom: 18 })
  }

  private timeGreeting(): string {
    const hour = new Date().getHours();
    if (hour >= 5 && hour < 11) {
      return '早上好';
    }
    if (hour >= 11 && hour < 14) {
      return '中午好';
    }
    if (hour >= 14 && hour < 18) {
      return '下午好';
    }
    if (hour >= 18 && hour < 23) {
      return '晚上好';
    }
    return '夜深了';
  }

  @Builder
  private searchBar() {
    Row({ space: 8 }) {
      Image($rawfile('icons_sleep/ic_search_new.svg'))
        .width(19)
        .height(19)
        .fillColor(SleepColor.textSecondary)

      TextInput({ text: this.searchKeyword, placeholder: '搜索雨声、森林、海浪' })
        .fontSize(SleepText.subheadline)
        .fontColor(SleepColor.textPrimary)
        .placeholderColor(SleepColor.textTertiary)
        .caretColor(SleepColor.textPrimary)
        .backgroundColor(Color.Transparent)
        .border({ width: 0 })
        .padding(0)
        .layoutWeight(1)
        .onChange((value: string) => {
          this.searchKeyword = value;
        })
    }
    .height(40)
    .width('100%')
    .padding({ left: 12, right: 12 })
    .backgroundColor(SleepColor.secondaryBackground)
    .borderRadius(8)
    .margin({ left: 16, right: 16, top: 14, bottom: 4 })
  }

  @Builder
  private categoryBar() {
    Scroll() {
      Row({ space: 8 }) {
        ForEach(SOUND_CATEGORIES, (title: string, index: number) => {
          Row() {
            Text(title)
              .fontSize(SleepText.subheadline)
              .fontWeight(this.selectedCategory === index ? FontWeight.Medium : FontWeight.Normal)
              .fontColor(this.selectedCategory === index ? Color.White : SleepColor.textPrimary)
              .textAlign(TextAlign.Center)
          }
            .width(this.categoryWidth(title))
            .height(34)
            .justifyContent(FlexAlign.Center)
            .alignItems(VerticalAlign.Center)
            .backgroundColor(this.selectedCategory === index ? SleepColor.primary : SleepColor.secondaryBackground)
            .borderRadius(17)
            .onClick(() => {
              this.onSelectCategory(index);
            })
        }, (title: string) => title)
      }
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
    }
    .width('100%')
    .height(50)
    .scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off)
  }

  @Builder
  private emptyState() {
    Column({ space: 12 }) {
      Stack() {
        Column()
          .width(68)
          .height(68)
          .backgroundColor('#EAF3FF')
          .borderRadius(34)
        Image($rawfile('icons_sleep/ic_heart_outline.svg'))
          .width(27)
          .height(27)
          .fillColor(SleepColor.primary)
      }
      .width(68)
      .height(68)

      Text('暂无收藏')
        .fontFamily('MiSans')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .fontColor(SleepColor.textPrimary)

      Text('喜欢的声音会出现在这里')
        .fontFamily('MiSans')
        .fontSize(13)
        .fontColor(SleepColor.textSecondary)

      Row({ space: 5 }) {
        Text('去发现声音')
          .fontFamily('MiSans')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor(SleepColor.primary)
        Text('→')
          .fontFamily('MiSans')
          .fontSize(17)
          .fontColor(SleepColor.primary)
      }
      .height(38)
      .padding({ left: 16, right: 16 })
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .backgroundColor('#EAF3FF')
      .borderRadius(19)
      .margin({ top: 8 })
      .onClick(() => this.onSelectCategory(0))
    }
    .layoutWeight(1)
    .width('100%')
    .padding({ bottom: 112 })
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  private displayedScenes(): SoundSceneItem[] {
    let result: SoundSceneItem[];
    if (this.selectedCategory === 2) {
      result = this.scenes.filter((scene: SoundSceneItem): boolean => this.favoriteSoundIds.includes(scene.id));
    } else if (this.selectedCategory === 0 || this.selectedCategory === 1) {
      result = this.scenes;
    } else {
      const category = SOUND_CATEGORIES[this.selectedCategory];
      result = this.scenes.filter((scene: SoundSceneItem): boolean => scene.category === category);
    }
    const keyword = this.searchKeyword.trim().toLowerCase();
    if (keyword.length === 0) {
      return result;
    }
    return result.filter((scene: SoundSceneItem): boolean =>
      scene.title.toLowerCase().includes(keyword) ||
      scene.subtitle.toLowerCase().includes(keyword) ||
      scene.category.toLowerCase().includes(keyword));
  }

  private categoryWidth(title: string): number {
    return title.length > 3 ? 78 : 62;
  }

  private async loadScenes(): Promise<void> {
    try {
      const context = getContext(this) as common.UIAbilityContext;
      const bytes = await context.resourceManager.getRawFileContent('SoundResources/sounds_manifest.json');
      const text = util.TextDecoder.create('utf-8').decodeToString(bytes);
      const manifest = JSON.parse(text) as SoundManifestItem[];
      this.scenes = manifest.map((item: SoundManifestItem): SoundSceneItem => {
        return {
          id: item.id,
          index: item.index,
          directory: item.directory,
          title: item.title,
          subtitle: item.subtitle,
          category: this.categoryName(item),
          coverFile: item.coverFile,
          audioFile: item.audioFile,
          isBundledAudio: item.index <= 20
        };
      });
    } catch (_) {
      this.scenes = SOUND_SCENES;
    }
  }

  private categoryName(item: SoundManifestItem): string {
    const original = SOUND_SCENES.find((scene: SoundSceneItem): boolean => scene.index === item.index);
    if (original) {
      return original.category;
    }
    const value = item.category;
    const title = item.title;
    if (value === 'meditation' || this.hasKeyword(title,
      ['冥想', '禅', '寺', '经', '颂', '钵', '瑜伽', '梵音', '静坐'])) {
      return '冥想';
    }
    if (value === 'nature' || this.hasKeyword(title,
      ['雨', '海', '湖', '江', '河', '溪', '泉', '瀑', '林', '竹', '风', '山', '谷', '雷', '雪', '虫', '鸟', '港'])) {
      return '自然';
    }
    if (value === 'mindfulness' || this.hasKeyword(title,
      ['正念', '呼吸', '觉察', '放空', '平静', '内观', '当下', '疗愈', '专注'])) {
      return '正念';
    }
    if (value === 'ear' || this.hasKeyword(title,
      ['键盘', '铅笔', '翻书', '写字', '切菜', '煲汤', '餐厅', '咖啡', '麻将', '乒乓', '车', '钟', '风铃', '八音盒'])) {
      return '耳畔';
    }
    if (value === 'dream') {
      return '梦境';
    }
    if (value === 'white_noise') {
      const group = item.index % 3;
      return group === 0 ? '自然' : group === 1 ? '耳畔' : '正念';
    }
    return '助眠';
  }

  private hasKeyword(title: string, keywords: string[]): boolean {
    return keywords.some((keyword: string): boolean => title.includes(keyword));
  }
}
