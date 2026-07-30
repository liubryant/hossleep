/**
 * @author liuzheng
 * @mail bryant_liu24@126.com
 */
import { SleepColor, SleepText } from '../common/SleepDesign';
import { common } from '@kit.AbilityKit';
import { abilityAccessCtrl, Permissions } from '@kit.AbilityKit';
import { promptAction, window } from '@kit.ArkUI';
import { util } from '@kit.ArkTS';
import { BottomTabBar } from '../components/app/BottomTabBar';
import { PrivacyAgreementDialog } from '../components/app/PrivacyAgreementDialog';
import { StartupGatePage } from '../components/app/StartupGatePage';
import { CommonNavBar } from '../components/common/CommonNavBar';
import { ConfirmDialog } from '../components/common/ConfirmDialog';
import { SoundCoverImage, StoryCoverImage } from '../components/common/CoverImages';
import { LoginPage } from '../components/profile/LoginPage';
import { LegalWebPage } from '../components/profile/LegalWebPage';
import { ProfilePage } from '../components/profile/ProfilePage';
import { SleepHomePage } from '../components/sleep/SleepHomePage';
import { SoundHomePage } from '../components/sounds/SoundHomePage';
import { StoryHomePage } from '../components/stories/StoryHomePage';
import { RotatingStoryCover } from '../components/stories/RotatingStoryCover';
import { VipMembershipPage } from '../components/vip/VipMembershipPage';
import { SOUND_SCENES, STORY_ITEMS } from '../models/SleepData';
import { SoundSceneItem, StoryListItem } from '../models/SleepModels';
import { AppSettings, SavedSettings } from '../services/AppSettings';
import { AuthService } from '../services/AuthService';
import { MediaSessionService } from '../services/MediaSessionService';
import { RemoteContentConfig } from '../services/RemoteContentConfig';
import { SoundPlayer } from '../services/SoundPlayer';
import { SleepRecorder } from '../services/SleepRecorder';
import { StoryCatalog } from '../services/StoryCatalog';
import { StoryNotificationService } from '../services/StoryNotificationService';
import { StorySpeaker } from '../services/StorySpeaker';
import { UmengAnalytics } from '../services/UmengAnalytics';

@Entry
@Component
struct Index {
  @StorageLink('notificationStoryIndex') @Watch('onNotificationStoryChanged')
  private notificationStoryIndex: number = 0;
  @State private agreementAccepted: boolean = false;
  @State private agreementChecked: boolean = false;
  @State private activeTab: number = 0;
  @State private soundCategory: number = 0;
  @State private activeSoundId: string = '';
  @State private soundPlaying: boolean = false;
  @State private currentSound: SoundSceneItem = SOUND_SCENES[0];
  @State private downloadingSoundId: string = '';
  @State private soundDownloadProgress: number = -1;
  @State private favoriteSoundIds: string[] = [];
  @State private favoriteStoryIds: string[] = [];
  @State private storyReminderEnabled: boolean = false;
  @State private storyReminderAsked: boolean = false;
  @State private sleepSensitiveConsent: boolean = false;
  @State private storySwitch: number = 0;
  @State private storyListTab: number = 0;
  @State private storyAllScrollOffset: number = 0;
  @State private storyFavoriteScrollOffset: number = 0;
  @State private activeStoryIndex: number = -1;
  @State private activeStory: StoryListItem = STORY_ITEMS[0];
  @State private storyPlaying: boolean = false;
  @State private activeStoryLine: number = -1;
  @State private storySeekProgress: number = 0;
  @State private storyElapsedSeconds: number = 0;
  @State private storyPlaybackMinutes: number = 0;
  @State private isSeekingStory: boolean = false;
  @State private currentStoryContent: string = '';
  @State private sleepPage: number = 0;
  @State private trendRange: number = 0;
  @State private isMonitoring: boolean = false;
  @State private sleepElapsedSeconds: number = 0;
  @State private sleepRecordingPath: string = '';
  @State private sleepRecordingPaths: string[] = [];
  @State private sleepRecordingPlaying: boolean = false;
  @State private isLoggedIn: boolean = false;
  @State private saveClips: boolean = true;
  @State private sensitivity: number = 65;
  @State private phoneNumber: string = '';
  @State private accessToken: string = '';
  @State private isVip: boolean = false;
  @State private loginMode: number = 0;
  @State private route: string = 'home';
  @State private legalReturnRoute: string = 'home';
  @State private dialogMode: string = '';
  @State private securityCode: string = '';
  @State private newPassword: string = '';
  @State private securityMessage: string = '';
  @State private securityBusy: boolean = false;
  @State private vipSoundPromptVisible: boolean = false;
  private sleepTimer: number = -1;
  private storyPlaybackTimer: number = -1;
  private storyClockTimer: number = -1;
  private storyLoadToken: number = 0;
  private storyCatalog: StoryListItem[] = STORY_ITEMS;
  private storyTextScroller: Scroller = new Scroller();

  aboutToAppear(): void {
    this.restoreSettings();
  }

  aboutToDisappear(): void {
    this.stopSleepTimer();
    if (this.storyClockTimer >= 0) {
      clearInterval(this.storyClockTimer);
      this.storyClockTimer = -1;
    }
  }

  onBackPress(): boolean {
    if (this.route === 'storyPlayer') {
      this.route = 'home';
      this.activeTab = 2;
      this.setStoryImmersiveMode(false);
      return true;
    }
    return false;
  }

  build() {
    Stack() {
      if (!this.agreementAccepted && this.route !== 'legalUser' && this.route !== 'legalPrivacy') {
        StartupGatePage()
        PrivacyAgreementDialog({
          isChecked: this.agreementChecked,
          onToggleChecked: () => {
            this.agreementChecked = !this.agreementChecked;
          },
          onAgree: () => {
            if (this.agreementChecked) {
              this.acceptPrivacyAgreement();
            }
          },
          onDisagree: () => {
            this.dialogMode = 'privacyExit';
          },
          onOpenUserAgreement: () => {
            this.legalReturnRoute = 'privacyGate';
            this.route = 'legalUser';
          },
          onOpenPrivacyPolicy: () => {
            this.legalReturnRoute = 'privacyGate';
            this.route = 'legalPrivacy';
          }
        })
      } else if (this.route === 'login') {
        this.homeShell()
        LoginPage({
          mode: this.loginMode,
          onBack: () => {
            this.route = 'home';
          },
          onSwitchMode: () => {
            this.loginMode = this.loginMode === 0 ? 1 : 0;
          },
          onLoginSuccess: (phone: string, accessToken: string) => {
            this.isLoggedIn = true;
            this.phoneNumber = phone;
            this.accessToken = accessToken;
            AppSettings.login(this.context(), phone, accessToken);
            this.activeTab = 3;
            this.route = this.legalReturnRoute === 'vip' ? 'vip' : 'home';
          },
          onOpenLegal: (type: string) => {
            this.legalReturnRoute = 'login';
            this.route = type === 'user' ? 'legalUser' : 'legalPrivacy';
          }
        })
      } else if (this.route === 'storyPlayer') {
        this.storyPlayerPage()
      } else if (this.route === 'legalUser') {
        this.legalPage('用户协议')
      } else if (this.route === 'legalPrivacy') {
        this.legalPage('隐私政策')
      } else if (this.route === 'password') {
        this.passwordPage()
      } else if (this.route === 'deleteAccount') {
        this.deleteAccountPage()
      } else if (this.route === 'vip') {
        VipMembershipPage({
          isLoggedIn: this.isLoggedIn,
          phoneNumber: this.phoneNumber,
          accessToken: this.accessToken,
          onClose: () => {
            this.route = 'home';
            this.activeTab = 3;
          },
          onRequireLogin: () => {
            this.legalReturnRoute = 'vip';
            this.route = 'login';
          },
          onOpenWebView: (_url: string, _title: string) => {
            this.legalReturnRoute = 'vip';
            this.route = 'legalVip';
          },
          onMembershipChanged: (active: boolean) => {
            this.isVip = active;
          }
        })
      } else if (this.route === 'legalVip') {
        LegalWebPage({
          title: '会员服务协议',
          url: 'https://www.cjym123.cn/agreement_agentclaw_vip.html',
          onBack: () => {
            this.route = 'vip';
          }
        })
      } else {
        this.homeShell()
      }

      if (this.dialogMode.length > 0) {
        this.confirmationDialog()
      }
      if (this.vipSoundPromptVisible) {
        this.vipSoundPrompt()
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(SleepColor.background)
  }

  @Builder
  private homeShell() {
    Stack({ alignContent: Alignment.Bottom }) {
      if (this.activeTab === 0) {
        SoundHomePage({
          selectedCategory: this.soundCategory,
          activeSoundId: this.activeStoryIndex >= 0 ? '' : this.activeSoundId,
          downloadingSoundId: this.downloadingSoundId,
          downloadProgress: this.soundDownloadProgress,
          favoriteSoundIds: this.favoriteSoundIds,
          onSelectCategory: (index: number) => {
            this.soundCategory = index;
          },
          onOpenStories: () => {
            this.activeTab = 2;
          },
          onToggleFavorite: (id: string) => {
            if (this.favoriteSoundIds.includes(id)) {
              this.favoriteSoundIds = this.favoriteSoundIds.filter((value: string): boolean => value !== id);
              AppSettings.setFavoriteSoundIds(this.context(), this.favoriteSoundIds);
              promptAction.showToast({ message: '已取消收藏' });
            } else {
              this.favoriteSoundIds = [...this.favoriteSoundIds, id];
              AppSettings.setFavoriteSoundIds(this.context(), this.favoriteSoundIds);
              promptAction.showToast({ message: '已添加到收藏' });
            }
          },
          onPlaySound: (scene: SoundSceneItem) => {
            if (this.downloadingSoundId.length > 0) {
              promptAction.showToast({ message: '当前声音正在下载，请稍候' });
              return;
            }
            this.currentSound = scene;
            this.activeSoundId = scene.id;
            const wasDownloading = !scene.isBundledAudio && !SoundPlayer.isCached(this.context(), scene);
            this.downloadingSoundId = wasDownloading ? scene.id : '';
            this.soundDownloadProgress = this.downloadingSoundId.length > 0 ? 0 : -1;
            SoundPlayer.toggle(this.context(), scene, (progress: number) => {
              this.soundDownloadProgress = progress;
            }).then((playing: boolean) => {
              this.soundPlaying = playing;
              MediaSessionService.showSound(scene.index, scene.title, playing);
              this.downloadingSoundId = '';
              this.soundDownloadProgress = -1;
              if (wasDownloading) {
                promptAction.showToast({ message: '下载完成，正在播放' });
              }
            }).catch(() => {
              this.soundPlaying = false;
              MediaSessionService.setPlaying(false);
              this.activeSoundId = '';
              this.downloadingSoundId = '';
              this.soundDownloadProgress = -1;
              promptAction.showToast({ message: '声音下载或播放失败，请检查网络后重试' });
            });
            this.activeStoryIndex = -1;
            this.storyPlaying = false;
          }
        })
      } else if (this.activeTab === 1) {
        SleepHomePage({
          selectedPage: this.sleepPage,
          isMonitoring: this.isMonitoring,
          elapsedSeconds: this.sleepElapsedSeconds,
          trendRange: this.trendRange,
          recordingPath: this.sleepRecordingPath,
          recordingPaths: this.sleepRecordingPaths,
          isRecordingPlaying: this.sleepRecordingPlaying,
          onSelectPage: (index: number) => {
            this.sleepPage = index;
          },
          onToggleMonitoring: () => {
            this.toggleMonitoring();
          },
          onSelectTrendRange: (index: number) => {
            this.trendRange = index;
          },
          onToggleRecording: (path: string) => {
            this.sleepRecordingPath = path;
            SoundPlayer.stop(this.context());
            this.soundPlaying = false;
            SleepRecorder.togglePlayback(this.sleepRecordingPath)
              .then((playing: boolean) => {
                this.sleepRecordingPlaying = playing;
              })
              .catch(() => {
                this.sleepRecordingPlaying = false;
                promptAction.showToast({ message: '录音播放失败，请稍后重试' });
              });
          }
        })
      } else if (this.activeTab === 2) {
        StoryHomePage({
          activeStoryId: this.activeStoryIndex > 0 ? this.activeStory.id : '',
          favoriteStoryIds: this.favoriteStoryIds,
          selectedTab: this.storyListTab,
          allScrollOffset: this.storyAllScrollOffset,
          favoriteScrollOffset: this.storyFavoriteScrollOffset,
          articleEnabled: this.storySwitch === 1,
          onSelectTab: (index: number) => {
            this.storyListTab = index;
          },
          onScrollOffsetChange: (index: number, offset: number) => {
            if (index === 0) {
              this.storyAllScrollOffset = offset;
            } else {
              this.storyFavoriteScrollOffset = offset;
            }
          },
          onToggleFavorite: (id: string) => {
            if (this.favoriteStoryIds.includes(id)) {
              this.favoriteStoryIds = this.favoriteStoryIds
                .filter((value: string): boolean => value !== id);
              AppSettings.setFavoriteStoryIds(this.context(), this.favoriteStoryIds);
              promptAction.showToast({ message: '已取消收藏' });
            } else {
              this.favoriteStoryIds = [...this.favoriteStoryIds, id];
              AppSettings.setFavoriteStoryIds(this.context(), this.favoriteStoryIds);
              promptAction.showToast({ message: '已添加到收藏' });
            }
          },
          onOpenStory: (story: StoryListItem) => {
            SoundPlayer.stop(this.context());
            this.soundPlaying = false;
            this.activeStoryIndex = story.index;
            this.activeStory = story;
            this.activeSoundId = '';
            this.route = 'storyPlayer';
            this.setStoryImmersiveMode(true);
            this.openStory(story.index);
          }
        })
      } else {
        ProfilePage({
          isLoggedIn: this.isLoggedIn,
          saveClips: this.saveClips,
          sensitivity: this.sensitivity,
          storyReminderEnabled: this.storyReminderEnabled,
          userPhone: this.maskPhone(this.phoneNumber),
          isVip: this.isVip,
          onLogin: () => {
            this.legalReturnRoute = 'home';
            this.route = 'login';
          },
          onLogout: () => {
            this.dialogMode = 'logout';
          },
          onToggleSaveClips: () => {
            this.saveClips = !this.saveClips;
            AppSettings.setSaveAudioClips(this.context(), this.saveClips);
          },
          onSensitivityChange: (value: number) => {
            this.sensitivity = value;
            AppSettings.setSensitivity(this.context(), value / 100);
          },
          onToggleStoryReminder: () => {
            this.toggleStoryReminder();
          },
          onOpenAction: (action: string) => {
            this.openProfileAction(action);
          }
        })
      }

      if (this.activeSoundId.length > 0 || this.activeStoryIndex > 0) {
        this.miniPlayer()
      }

      BottomTabBar({
        activeIndex: this.activeTab,
        onSelect: (index: number) => {
          this.activeTab = index;
        }
      })
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  private miniPlayer() {
    Row({ space: 12 }) {
      if (this.activeStoryIndex > 0) {
        StoryCoverImage({
          index: this.activeStoryIndex,
          coverFile: this.currentStory().coverFile ?? '',
          widthValue: 48,
          heightValue: 48,
          radius: 8
        })
      } else {
        SoundCoverImage({
          index: this.currentSound.index,
          directory: this.currentSound.directory ?? '',
          coverFile: this.currentSound.coverFile ?? 'cover.jpg',
          widthValue: 48,
          heightValue: 48,
          radius: 8
        })
      }

      Column({ space: 4 }) {
        Text(this.activeStoryIndex > 0 ? this.currentStory().title : this.currentSound.title)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor(SleepColor.textPrimary)
          .maxLines(1)
        Text(this.activeStoryIndex > 0 ? '睡前故事' : '助眠声音')
          .fontSize(12)
          .fontColor(SleepColor.textSecondary)
          .maxLines(1)
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      Stack() {
        if ((this.activeStoryIndex > 0 && !this.storyPlaying) ||
          (this.activeStoryIndex < 0 && !this.soundPlaying)) {
          Image($rawfile('icons_sleep/ic_play.svg'))
            .width(17)
            .height(17)
            .fillColor(Color.White)
        } else {
          Image($rawfile('icons_sleep/ic_pause.svg'))
            .width(17)
            .height(17)
            .fillColor(Color.White)
        }
      }
        .width(36)
        .height(36)
        .backgroundColor(SleepColor.primary)
        .borderRadius(18)
        .onClick(() => {
          if (this.activeStoryIndex > 0) {
            StorySpeaker.toggle(this.currentStoryText(), (index: number) => {
              this.updateActiveStoryLine(index);
            }, () => this.handleStoryFinished()).then((playing: boolean) => {
              this.storyPlaying = playing;
            }).catch(() => {
              this.storyPlaying = false;
            });
          } else {
            SoundPlayer.toggle(this.context(), this.currentSound).then((playing: boolean) => {
              this.soundPlaying = playing;
            });
          }
        })

      Stack() {
        Image($rawfile('icons_sleep/ic_close.svg'))
          .width(18)
          .height(18)
          .fillColor(SleepColor.textSecondary)
      }
        .width(30)
        .height(30)
        .onClick(() => {
          this.activeSoundId = '';
          SoundPlayer.stop(this.context());
          this.soundPlaying = false;
          this.activeStoryIndex = -1;
          this.storyPlaying = false;
          StorySpeaker.stop();
        })
    }
    .width('92%')
    .padding(12)
    .margin({ bottom: 74 })
    .backgroundColor('#F7FFFFFF')
    .borderRadius(16)
    .shadow({ radius: 16, color: '#20000000', offsetY: 6 })
  }

  @Builder
  private storyPlayerPage() {
    Stack({ alignContent: Alignment.TopStart }) {
      Image(this.storyBackgroundSource())
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)
        .scale({ x: 1.22, y: 1.22 })
        .blur(32)
        .opacity(0.9)
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])

      Column()
        .width('100%')
        .height('100%')
        .linearGradient({
          angle: 180,
          colors: [['#50071126', 0], ['#B8151830', 0.56], ['#F20A1022', 1]] as [string, number][]
        })
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])

      Column({ space: 10 }) {
        Row() {
          Column()
            .width(58)
            .height(44)

          Text(this.currentStory().title)
            .fontFamily('MiSans-DemiBold')
            .fontSize(20)
            .fontColor(Color.White)
            .textAlign(TextAlign.Center)
            .layoutWeight(1)
            .height(44)
            .lineHeight(44)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          Row({ space: 3 }) {
            Image($rawfile('icons_sleep/ic_story_timer.svg'))
              .width(19)
              .height(19)
            if (this.storyPlaybackMinutes > 0) {
              Text(`${this.storyPlaybackMinutes}`)
                .fontSize(11)
                .fontColor(Color.White)
            }
          }
          .width(58)
          .height(36)
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)
          .backgroundColor(this.storyPlaybackMinutes > 0 ? '#706FA8FF' : '#30FFFFFF')
          .borderRadius(18)
          .bindMenu([
            { value: '连续播放30分钟', action: () => this.setStoryPlaybackTimer(30) },
            { value: '连续播放60分钟', action: () => this.setStoryPlaybackTimer(60) },
            { value: '连续播放90分钟', action: () => this.setStoryPlaybackTimer(90) },
            { value: '连续播放120分钟', action: () => this.setStoryPlaybackTimer(120) },
            { value: '取消定时播放', action: () => this.cancelStoryPlaybackTimer(true) }
          ])
        }
        .width('100%')
        .height(44)
        .alignItems(VerticalAlign.Center)

        RotatingStoryCover({
          index: this.currentStory().index,
          coverFile: this.currentStory().coverFile ?? '',
          isPlaying: this.storyPlaying,
          diameter: 176
        })
          .margin({ top: 2, bottom: 2 })

        if (this.currentStoryContent.length === 0) {
          Scroll() {
            Column() {
              Text('正在加载故事内容…')
                .fontSize(SleepText.body)
                .fontColor('#CCFFFFFF')
                .width('100%')
                .textAlign(TextAlign.Center)
                .padding({ top: 30 })
            }
            .padding(16)
          }
          .layoutWeight(1)
          .width('100%')
          .backgroundColor('#20FFFFFF')
          .borderRadius(18)
        } else {
          List({ space: 7, scroller: this.storyTextScroller }) {
            ForEach(this.currentStoryLines(), (line: string, index: number) => {
              ListItem() {
                this.storyTextLine(line, index === this.activeStoryLine)
              }
            }, (line: string, index: number) => `${this.activeStoryLine}-${index}-${line}`)
          }
          .padding({ left: 12, right: 12, top: 10, bottom: 10 })
          .layoutWeight(1)
          .width('100%')
          .backgroundColor('#20FFFFFF')
          .border({ width: 1, color: '#22FFFFFF' })
          .borderRadius(18)
          .scrollBar(BarState.Off)
          .contentStartOffset(48)
          .contentEndOffset(48)
        }

        Column({ space: 6 }) {
          Slider({
            value: this.isSeekingStory ? this.storySeekProgress : this.storyProgress(),
            min: 0,
            max: 100
          })
            .selectedColor(Color.White)
            .trackColor('#55FFFFFF')
            .trackThickness(4)
            .width('100%')
            .onChange((value: number, mode: SliderChangeMode) => {
              if (mode === SliderChangeMode.Begin || mode === SliderChangeMode.Moving) {
                this.isSeekingStory = true;
                this.storySeekProgress = value;
                this.updateActiveStoryLine(this.storyLineAtProgress(value));
                return;
              }
              this.storySeekProgress = value;
              this.isSeekingStory = false;
              this.seekStoryToProgress(value);
            })
          Row() {
            Text(this.storyCurrentTime())
              .fontSize(12)
              .fontColor('#BFFFFFFF')
            Blank()
            Text(this.storyTotalTime())
              .fontSize(12)
              .fontColor('#BFFFFFFF')
          }
          .width('100%')
          Row() {
            Stack() {
              Image($rawfile('icons_sleep/ic_previous.svg'))
                .width(34)
                .height(34)
            }
            .width(56)
            .height(56)
            .borderRadius(28)
            .onClick(() => this.switchStory(-1))

            Stack() {
              Column()
                .width(64)
                .height(64)
                .backgroundColor(Color.White)
                .borderRadius(32)
                .shadow({ radius: 18, color: '#44000000', offsetY: 6 })
              if (this.storyPlaying) {
                Image($rawfile('icons_sleep/ic_pause.svg'))
                  .width(25)
                  .height(25)
                  .fillColor('#111827')
              } else {
                Image($rawfile('icons_sleep/ic_play.svg'))
                  .width(27)
                  .height(27)
                  .fillColor('#111827')
                  .translate({ x: 2 })
              }
            }
            .width(74)
            .height(70)
            .onClick(() => {
              StorySpeaker.toggle(this.currentStoryText(), (index: number) => {
                this.updateActiveStoryLine(index);
              }, () => this.handleStoryFinished()).then((playing: boolean) => {
                this.storyPlaying = playing;
                if (!playing) {
                  this.activeStoryLine = -1;
                }
              }).catch(() => {
                this.storyPlaying = false;
                this.activeStoryLine = -1;
              });
            })

            Stack() {
              Image($rawfile('icons_sleep/ic_next.svg'))
                .width(34)
                .height(34)
            }
            .width(56)
            .height(56)
            .borderRadius(28)
            .onClick(() => this.switchStory(1))
          }
          .width('100%')
          .height(72)
          .justifyContent(FlexAlign.SpaceAround)
          .alignItems(VerticalAlign.Center)
        }
        .width('100%')
        .padding({ left: 14, right: 14, top: 8, bottom: 8 })
        .backgroundColor('#1FFFFFFF')
        .border({ width: 1, color: '#24FFFFFF' })
        .borderRadius(22)
      }
      .padding({ left: 18, right: 18, top: 38, bottom: 30 })
      .width('100%')
      .height('100%')

      Stack() {
        Image($rawfile('icons_sleep/ic_back_modern.svg'))
          .width(24)
          .height(24)
          .objectFit(ImageFit.Contain)
      }
      .width(44)
      .height(44)
      .margin({ left: 8, top: 38 })
      .backgroundColor('#38FFFFFF')
      .borderRadius(22)
      .onClick(() => {
        this.route = 'home';
        this.activeTab = 2;
        this.setStoryImmersiveMode(false);
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#111827')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }

  @Builder
  private legalPage(title: string) {
    LegalWebPage({
      title: title,
      url: title === '用户协议' ? 'https://www.cjym123.cn/agreement_sleep.html' :
        'https://www.cjym123.cn/privacy_sleep.html',
      onBack: () => {
          if (this.legalReturnRoute === 'privacyGate') {
            this.route = 'home';
          } else {
            this.route = this.legalReturnRoute;
            if (this.route === 'home') {
              this.activeTab = 3;
            }
          }
      }
    })
  }

  @Builder
  private storyTextLine(text: string, highlighted: boolean) {
    Text(text)
      .fontSize(SleepText.body)
      .fontColor(highlighted ? Color.White : '#D9FFFFFF')
      .lineHeight(28)
      .width('100%')
      .padding({ left: 10, right: 10, top: 7, bottom: 7 })
      .backgroundColor(highlighted ? '#406FA8FF' : '#00000000')
      .borderRadius(9)
  }

  @Builder
  private simplePage(title: string, desc: string, action: string) {
    Column({ space: 0 }) {
      CommonNavBar({
        title: title,
        onBack: () => {
          this.route = 'home';
          this.activeTab = 3;
        }
      })
      Column({ space: 18 }) {
        Text(desc)
          .fontSize(SleepText.subheadline)
          .fontColor(SleepColor.textSecondary)
          .lineHeight(24)
          .width('100%')
        Text('请输入')
          .fontSize(SleepText.subheadline)
          .fontColor(SleepColor.textSecondary)
          .width('100%')
          .height(50)
          .lineHeight(50)
          .padding({ left: 16 })
          .backgroundColor(SleepColor.secondaryBackground)
          .borderRadius(8)
        Text(action)
          .fontSize(SleepText.body)
          .fontWeight(FontWeight.Medium)
          .fontColor(Color.White)
          .width('100%')
          .height(48)
          .lineHeight(48)
          .textAlign(TextAlign.Center)
          .backgroundColor(action === '确认注销' ? SleepColor.destructive : SleepColor.primary)
          .borderRadius(8)
      }
      .padding(20)
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(SleepColor.background)
  }

  @Builder
  private passwordPage() {
    Column({ space: 0 }) {
      CommonNavBar({
        title: '修改密码',
        onBack: () => {
          this.route = 'home';
          this.activeTab = 3;
        }
      })
      Column({ space: 22 }) {
        Text(`验证手机号 ${this.maskPhone(this.phoneNumber)} 后修改密码，之后可使用密码登录`)
          .fontSize(SleepText.subheadline)
          .fontColor(SleepColor.textSecondary)
          .textAlign(TextAlign.Center)
          .lineHeight(21)
          .width('100%')
        Row({ space: 12 }) {
          TextInput({ text: this.securityCode, placeholder: '请输入验证码' })
            .type(InputType.Number)
            .maxLength(8)
            .height(50)
            .layoutWeight(1)
            .backgroundColor(SleepColor.secondaryBackground)
            .borderRadius(8)
            .onChange((value: string) => {
              this.securityCode = value;
              this.securityMessage = '';
            })
          this.securityCodeButton()
        }
        TextInput({ text: this.newPassword, placeholder: '请输入新密码（至少6位）' })
          .type(InputType.Password)
          .height(50)
          .backgroundColor(SleepColor.secondaryBackground)
          .borderRadius(8)
          .onChange((value: string) => {
            this.newPassword = value;
            this.securityMessage = '';
          })
        if (this.securityMessage.length > 0) {
          Text(this.securityMessage)
            .fontSize(SleepText.caption)
            .fontColor(SleepColor.destructive)
            .width('100%')
        }
        Text(this.securityBusy ? '提交中…' : '确认设置')
          .fontSize(SleepText.body)
          .fontWeight(FontWeight.Medium)
          .fontColor(Color.White)
          .width('100%')
          .height(48)
          .lineHeight(48)
          .textAlign(TextAlign.Center)
          .backgroundColor(SleepColor.primary)
          .borderRadius(8)
          .onClick(() => {
            this.changePassword();
          })
        Blank()
      }
      .padding({ left: 16, right: 16 })
      .layoutWeight(1)
      .width('100%')
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(SleepColor.background)
  }

  @Builder
  private deleteAccountPage() {
    Column({ space: 0 }) {
      CommonNavBar({
        title: '注销账号',
        onBack: () => {
          this.route = 'home';
          this.activeTab = 3;
        }
      })
      Column({ space: 22 }) {
        Text(`验证手机号 ${this.maskPhone(this.phoneNumber)} 后将永久注销账号`)
          .fontSize(SleepText.subheadline)
          .fontColor(SleepColor.textSecondary)
          .textAlign(TextAlign.Center)
          .lineHeight(21)
          .width('100%')
        Column({ space: 8 }) {
          Text('注销账号前请确认：')
            .fontSize(SleepText.subheadline)
            .fontWeight(FontWeight.Medium)
            .fontColor(SleepColor.textPrimary)
          Text('• 账号信息、睡眠记录及设置将被永久删除，无法恢复')
            .fontSize(SleepText.caption)
            .fontColor(SleepColor.textSecondary)
          Text('• 本机保存的监测数据也会一并清除')
            .fontSize(SleepText.caption)
            .fontColor(SleepColor.textSecondary)
          Text('• 注销后该手机号可重新注册新账号')
            .fontSize(SleepText.caption)
            .fontColor(SleepColor.textSecondary)
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        .padding(16)
        .backgroundColor(SleepColor.secondaryBackground)
        .borderRadius(12)
        Row({ space: 12 }) {
          TextInput({ text: this.securityCode, placeholder: '请输入验证码' })
            .type(InputType.Number)
            .maxLength(8)
            .height(50)
            .layoutWeight(1)
            .backgroundColor(SleepColor.secondaryBackground)
            .borderRadius(8)
            .onChange((value: string) => {
              this.securityCode = value;
              this.securityMessage = '';
            })
          this.securityCodeButton()
        }
        if (this.securityMessage.length > 0) {
          Text(this.securityMessage)
            .fontSize(SleepText.caption)
            .fontColor(SleepColor.destructive)
            .width('100%')
        }
        Row() {
          Text(this.securityBusy ? '处理中…' : '确认注销')
            .fontSize(SleepText.body)
            .fontWeight(FontWeight.Medium)
            .fontColor(Color.White)
            .textAlign(TextAlign.Center)
        }
          .width('100%')
          .height(48)
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)
          .backgroundColor(SleepColor.destructive)
          .borderRadius(8)
          .onClick(() => {
            this.deleteAccount();
          })
        Blank()
      }
      .padding({ left: 16, right: 16 })
      .layoutWeight(1)
      .width('100%')
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(SleepColor.background)
  }

  @Builder
  private fullInput(text: string) {
    Text(text)
      .fontSize(SleepText.subheadline)
      .fontColor(SleepColor.textTertiary)
      .width('100%')
      .height(50)
      .lineHeight(50)
      .padding({ left: 16 })
      .backgroundColor(SleepColor.secondaryBackground)
      .borderRadius(8)
  }

  @Builder
  private smallBorderButton(text: string) {
    Text(text)
      .fontSize(SleepText.subheadline)
      .fontColor(SleepColor.textPrimary)
      .width(96)
      .height(50)
      .lineHeight(50)
      .textAlign(TextAlign.Center)
      .backgroundColor(SleepColor.tertiaryBackground)
      .border({ width: 1, color: SleepColor.divider })
      .borderRadius(8)
  }

  @Builder
  private securityCodeButton() {
    Row() {
      Text(this.securityBusy ? '请稍候' : '获取验证码')
        .fontSize(SleepText.subheadline)
        .fontColor(SleepColor.primary)
        .textAlign(TextAlign.Center)
    }
      .width(96)
      .height(50)
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .backgroundColor(SleepColor.tertiaryBackground)
      .border({ width: 1, color: SleepColor.divider })
      .borderRadius(8)
      .onClick(() => {
        this.sendSecurityCode();
      })
  }

  @Builder
  private primaryAction(text: string, color: string) {
    Text(text)
      .fontSize(SleepText.body)
      .fontWeight(FontWeight.Medium)
      .fontColor(Color.White)
      .width('100%')
      .height(48)
      .lineHeight(48)
      .textAlign(TextAlign.Center)
      .backgroundColor(color)
      .borderRadius(8)
  }

  private currentStory(): StoryListItem {
    return this.activeStoryIndex > 0 ? this.activeStory : STORY_ITEMS[0];
  }

  private currentSoundIndex(): number {
    if (this.activeSoundId.length < 9) {
      return 1;
    }
    const raw = Number(this.activeSoundId.substring(6));
    return raw >= 1 && raw <= 20 ? raw : 1;
  }

  private currentSoundTitle(): string {
    const titles: string[] = [
      '夏威夷海滩', '悠长假日', '声音浴', '四天王寺', '千岛湖',
      '假日', '26.5℃', '西餐厅', '猫的午后', '热带雨林',
      '春雨', '须臾', '樱花', '轴韵', '远山',
      '古镇清晨', '磨砚', '山泉', '蒲公英', '冥想'
    ];
    return titles[this.currentSoundIndex() - 1] ?? '助眠声音';
  }

  private currentStoryText(): string {
    return this.currentStoryContent;
  }

  private currentStoryLines(): string[] {
    return this.currentStoryText().split('\n').filter((line: string) => line.trim().length > 0);
  }

  private storyProgress(): number {
    const count = this.currentStoryLines().length;
    return this.activeStoryLine < 0 || count === 0 ? 0 : ((this.activeStoryLine + 1) * 100 / count);
  }

  private storyLineAtProgress(progress: number): number {
    const count = this.currentStoryLines().length;
    if (count === 0) {
      return 0;
    }
    return Math.max(0, Math.min(count - 1, Math.floor(progress * count / 100)));
  }

  private seekStoryToProgress(progress: number): void {
    if (this.currentStoryLines().length === 0) {
      return;
    }
    const targetLine = this.storyLineAtProgress(progress);
    this.storyElapsedSeconds = Math.floor(this.currentStoryLines().length * 18 * progress / 100);
    this.updateActiveStoryLine(targetLine);
    StorySpeaker.seek(this.currentStoryText(), targetLine, (index: number) => {
      this.updateActiveStoryLine(index);
    }, () => this.handleStoryFinished()).then((playing: boolean) => {
      this.storyPlaying = playing;
    }).catch(() => {
      this.storyPlaying = false;
      promptAction.showToast({ message: '跳转播放失败，请重试' });
    });
  }

  private storyCurrentTime(): string {
    return this.formatStoryTime(this.storyElapsedSeconds);
  }

  private storyTotalTime(): string {
    return this.formatStoryTime(this.currentStoryLines().length * 18);
  }

  private formatStoryTime(seconds: number): string {
    const minute = Math.floor(seconds / 60);
    const second = seconds % 60;
    return `${minute < 10 ? '0' : ''}${minute}:${second < 10 ? '0' : ''}${second}`;
  }

  private updateActiveStoryLine(index: number): void {
    this.activeStoryLine = index;
    this.storyElapsedSeconds = Math.max(this.storyElapsedSeconds, index * 18);
    setTimeout(() => {
      if (this.route === 'storyPlayer') {
        this.storyTextScroller.scrollToIndex(index, true, ScrollAlign.CENTER);
      }
    }, 0);
  }

  private async openStory(index: number): Promise<void> {
    const loadToken = ++this.storyLoadToken;
    StorySpeaker.stop();
    this.storyPlaying = false;
    this.activeStoryLine = -1;
    this.storyElapsedSeconds = 0;
    this.storySeekProgress = 0;
    this.isSeekingStory = false;
    this.currentStoryContent = '';
    try {
      const bytes = await this.context().resourceManager
        .getRawFileContent(
          (this.currentStory().textFile ?? '').length > 0
            ? this.currentStory().textFile ?? ''
            : `story_texts/story_${this.pad3(index)}.txt`
        );
      if (loadToken !== this.storyLoadToken || this.activeStoryIndex !== index) {
        return;
      }
      let text = util.TextDecoder.create('utf-8').decodeToString(bytes).trim();
      const paragraphs = text.split(/\r?\n/).filter((line: string) => line.trim().length > 0);
      if (paragraphs.length > 0 && paragraphs[0].trim() === this.currentStory().title) {
        paragraphs.shift();
      }
      text = paragraphs.join('').replace(/([。！？!?])/g, '$1\n');
      this.currentStoryContent = text.split('\n')
        .map((line: string) => line.trim())
        .filter((line: string) => line.length > 0)
        .join('\n');
      const playing = await StorySpeaker.toggle(this.currentStoryText(), (lineIndex: number) => {
        this.updateActiveStoryLine(lineIndex);
      }, () => this.handleStoryFinished());
      this.storyPlaying = playing;
      MediaSessionService.showStory(
        this.currentStory().index,
        this.currentStory().title,
        playing,
        this.currentStory().coverFile ?? ''
      );
    } catch (_) {
      this.currentStoryContent = '故事内容加载失败，请稍后重试。';
      this.storyPlaying = false;
      MediaSessionService.setPlaying(false);
      promptAction.showToast({ message: '故事内容加载失败' });
    }
  }

  private switchStory(direction: number): void {
    const current = this.storyCatalog.findIndex((story: StoryListItem): boolean =>
      story.index === this.currentStory().index);
    const currentPosition = current >= 0 ? current : 0;
    const target = (currentPosition + direction + this.storyCatalog.length) % this.storyCatalog.length;
    const story = this.storyCatalog[target];
    this.activeStoryIndex = story.index;
    this.activeStory = story;
    this.activeStoryLine = -1;
    this.storyElapsedSeconds = 0;
    this.storySeekProgress = 0;
    this.isSeekingStory = false;
    this.activeSoundId = '';
    this.route = 'storyPlayer';
    this.setStoryImmersiveMode(true);
    this.openStory(story.index);
  }

  private setStoryPlaybackTimer(minutes: number): void {
    this.cancelStoryPlaybackTimer(false);
    this.storyPlaybackMinutes = minutes;
    this.storyPlaybackTimer = setTimeout(() => {
      this.storyPlaybackTimer = -1;
      this.storyPlaybackMinutes = 0;
      StorySpeaker.stop();
      this.storyPlaying = false;
      this.activeStoryLine = -1;
      MediaSessionService.setPlaying(false);
      promptAction.showToast({ message: '定时播放已结束' });
    }, minutes * 60 * 1000);
    if (!this.storyPlaying && this.currentStoryContent.length > 0) {
      this.handleMediaPlay();
    }
    promptAction.showToast({ message: `将连续播放${minutes}分钟` });
  }

  private cancelStoryPlaybackTimer(showMessage: boolean): void {
    if (this.storyPlaybackTimer >= 0) {
      clearTimeout(this.storyPlaybackTimer);
      this.storyPlaybackTimer = -1;
    }
    const wasActive = this.storyPlaybackMinutes > 0;
    this.storyPlaybackMinutes = 0;
    if (showMessage && wasActive) {
      promptAction.showToast({ message: '已取消定时播放' });
    }
  }

  private handleStoryFinished(): void {
    this.storyPlaying = false;
    this.activeStoryLine = -1;
    MediaSessionService.setPlaying(false);
    setTimeout(() => {
      if (this.route === 'storyPlayer' && this.activeStoryIndex > 0) {
        this.switchStory(1);
      }
    }, 250);
  }

  private storyBackgroundSource(): ResourceStr {
    const coverFile = this.currentStory().coverFile ?? '';
    if (coverFile.length > 0) {
      return `resource://RAWFILE/${coverFile}`;
    }
    return `resource://RAWFILE/ios_story_covers/story_${this.pad2(this.currentStory().index)}.jpg`;
  }

  private pad2(value: number): string {
    return value < 10 ? `0${value}` : `${value}`;
  }

  private switchSound(direction: number): void {
    const current = Math.max(0, this.currentSound.index - 1);
    const target = (current + direction + SOUND_SCENES.length) % SOUND_SCENES.length;
    const scene = SOUND_SCENES[target];
    this.currentSound = scene;
    this.activeSoundId = scene.id;
    SoundPlayer.play(this.context(), scene, () => {}).then(() => {
      this.soundPlaying = true;
      MediaSessionService.showSound(scene.index, scene.title, true);
    }).catch(() => {
      this.soundPlaying = false;
      MediaSessionService.setPlaying(false);
    });
  }

  private handleMediaPlay(): void {
    if (this.activeStoryIndex > 0 && !this.storyPlaying) {
      StorySpeaker.toggle(this.currentStoryText(), (index: number) => {
        this.updateActiveStoryLine(index);
      }, () => this.handleStoryFinished()).then((playing: boolean) => {
        this.storyPlaying = playing;
        MediaSessionService.setPlaying(playing);
      });
    } else if (this.activeSoundId.length > 0 && !this.soundPlaying) {
      SoundPlayer.toggle(this.context(), this.currentSound).then((playing: boolean) => {
        this.soundPlaying = playing;
        MediaSessionService.setPlaying(playing);
      });
    }
  }

  private handleMediaPause(): void {
    if (this.activeStoryIndex > 0 && this.storyPlaying) {
      StorySpeaker.stop();
      this.storyPlaying = false;
    } else if (this.activeSoundId.length > 0 && this.soundPlaying) {
      SoundPlayer.toggle(this.context(), this.currentSound);
      this.soundPlaying = false;
    }
    MediaSessionService.setPlaying(false);
  }

  private handleMediaPrevious(): void {
    if (this.activeStoryIndex > 0) {
      this.switchStory(-1);
    } else if (this.activeSoundId.length > 0) {
      this.switchSound(-1);
    }
  }

  private handleMediaNext(): void {
    if (this.activeStoryIndex > 0) {
      this.switchStory(1);
    } else if (this.activeSoundId.length > 0) {
      this.switchSound(1);
    }
  }

  private onNotificationStoryChanged(): void {
    this.consumeNotificationStory();
  }

  private consumeNotificationStory(): void {
    const index = this.notificationStoryIndex;
    if (index < 1 || !this.agreementAccepted) {
      return;
    }
    this.notificationStoryIndex = 0;
    this.openNotificationStory(index);
  }

  private async openNotificationStory(index: number): Promise<void> {
    const story = await StoryCatalog.find(this.context(), index);
    if (!story) {
      return;
    }
    this.storyCatalog = await StoryCatalog.load(this.context());
    SoundPlayer.stop(this.context());
    this.soundPlaying = false;
    this.activeSoundId = '';
    this.activeTab = 2;
    this.activeStoryIndex = story.index;
    this.activeStory = story;
    this.route = 'storyPlayer';
    this.setStoryImmersiveMode(true);
    this.openStory(story.index);
  }

  private async setStoryImmersiveMode(enabled: boolean): Promise<void> {
    try {
      const appWindow = await window.getLastWindow(this.context());
      await appWindow.setWindowLayoutFullScreen(enabled);
      await appWindow.setWindowSystemBarProperties({
        statusBarColor: enabled ? '#00000000' : '#F2F2F7',
        statusBarContentColor: enabled ? '#FFFFFFFF' : '#111827',
        navigationBarColor: enabled ? '#00000000' : '#FFFFFF',
        navigationBarContentColor: enabled ? '#FFFFFFFF' : '#111827'
      });
    } catch (_) {
    }
  }

  private pad3(value: number): string {
    if (value < 10) {
      return `00${value}`;
    }
    if (value < 100) {
      return `0${value}`;
    }
    return `${value}`;
  }

  private openProfileAction(action: string): void {
    if (action === 'userAgreement') {
      this.legalReturnRoute = 'home';
      this.route = 'legalUser';
    } else if (action === 'privacyPolicy') {
      this.legalReturnRoute = 'home';
      this.route = 'legalPrivacy';
    } else if (action === 'password') {
      this.route = 'password';
    } else if (action === 'deleteAccount') {
      if (this.isLoggedIn) {
        this.route = 'deleteAccount';
      } else {
        promptAction.showToast({ message: '请先登录后再注销账号' });
      }
    } else if (action === 'clearData') {
      this.dialogMode = 'clearData';
    } else if (action === 'vip') {
      this.route = 'vip';
    }
  }

  @Builder
  private confirmationDialog() {
    ConfirmDialog({
      title: this.dialogTitle(),
      message: this.dialogMessage(),
      confirmText: this.dialogConfirmText(),
      destructive: this.dialogMode !== 'microphone' &&
        this.dialogMode !== 'sleepConsent' &&
        this.dialogMode !== 'storyReminder',
      onCancel: () => {
        if (this.dialogMode === 'storyReminder') {
          this.storyReminderAsked = true;
          AppSettings.markStoryReminderAsked(this.context());
        }
        this.dialogMode = '';
      },
      onConfirm: () => {
        this.confirmDialogAction();
      }
    })
  }

  private dialogTitle(): string {
    if (this.dialogMode === 'logout') {
      return '退出登录';
    }
    if (this.dialogMode === 'clearData') {
      return '清除本地数据';
    }
    if (this.dialogMode === 'microphone') {
      return '需要麦克风权限';
    }
    if (this.dialogMode === 'sleepConsent') {
      return '睡眠监测信息处理确认';
    }
    if (this.dialogMode === 'storyReminder') {
      return '开启故事提醒';
    }
    return '不同意隐私协议';
  }

  private dialogMessage(): string {
    if (this.dialogMode === 'logout') {
      return '退出后仍可使用助眠声音和睡眠监测，本机数据不会被删除。';
    }
    if (this.dialogMode === 'clearData') {
      return '将清除本机睡眠记录、缓存和监测片段，此操作无法撤销。';
    }
    if (this.dialogMode === 'microphone') {
      return '睡眠监测需要使用麦克风采集环境声音。音频仅在本机分析，拒绝授权不会影响其他功能。';
    }
    if (this.dialogMode === 'sleepConsent') {
      return '开启后将使用麦克风采集环境声音，并在本机生成录音和睡眠报告。数据仅保存在应用私有目录，不会上传；睡眠不足30分钟不保存，最多保留最近90条，您可在“我的-清除数据”随时删除。是否同意开启？';
    }
    if (this.dialogMode === 'storyReminder') {
      return '是否接收每日精选故事？开启后将在每天 11:00、16:00、20:00 提醒，点击通知可直接播放。您也可以随时在“我的-故事提醒”中关闭。';
    }
    return '不同意用户协议和隐私政策将无法继续使用时光睡眠。';
  }

  private dialogConfirmText(): string {
    if (this.dialogMode === 'logout') {
      return '退出';
    }
    if (this.dialogMode === 'clearData') {
      return '确认清除';
    }
    if (this.dialogMode === 'microphone') {
      return '知道了';
    }
    if (this.dialogMode === 'sleepConsent') {
      return '同意并开启';
    }
    if (this.dialogMode === 'storyReminder') {
      return '开启提醒';
    }
    return '退出应用';
  }

  private confirmDialogAction(): void {
    const action = this.dialogMode;
    this.dialogMode = '';
    if (action === 'logout') {
      this.isLoggedIn = false;
      this.accessToken = '';
      this.isVip = false;
      AppSettings.logout(this.context());
    } else if (action === 'clearData') {
      this.activeSoundId = '';
      this.activeStoryIndex = -1;
      this.storyPlaying = false;
      this.isMonitoring = false;
      SleepRecorder.clearAll(this.context()).then(() => {
        this.sleepRecordingPath = '';
        this.sleepRecordingPaths = [];
        this.sleepRecordingPlaying = false;
        promptAction.showToast({ message: '本地睡眠录音和缓存数据已清除' });
      });
    } else if (action === 'microphone') {
      return;
    } else if (action === 'sleepConsent') {
      this.sleepSensitiveConsent = true;
      AppSettings.acceptSleepSensitiveConsent(this.context()).then(() => {
        this.toggleMonitoring();
      });
    } else if (action === 'storyReminder') {
      this.storyReminderAsked = true;
      AppSettings.markStoryReminderAsked(this.context());
      this.enableStoryReminder();
    } else {
      this.context().terminateSelf();
    }
  }

  private async restoreSettings(): Promise<void> {
    const saved: SavedSettings = await AppSettings.load(this.context());
    this.agreementAccepted = saved.agreementAccepted;
    if (saved.agreementAccepted) {
      await UmengAnalytics.initialize();
      await this.initializeAfterPrivacyConsent();
      await this.loadRemoteStorySwitch();
    }
    this.isLoggedIn = saved.isLoggedIn;
    this.phoneNumber = saved.phoneNumber;
    this.accessToken = saved.accessToken;
    this.saveClips = saved.saveAudioClips;
    this.sensitivity = saved.sensitivity * 100;
    this.favoriteSoundIds = saved.favoriteSoundIds;
    this.favoriteStoryIds = saved.favoriteStoryIds;
    this.storyReminderEnabled = saved.storyReminderEnabled;
    this.storyReminderAsked = saved.storyReminderAsked;
    this.sleepSensitiveConsent = saved.sleepSensitiveConsent;
    if (saved.agreementAccepted) {
      this.offerStoryReminderIfNeeded();
    }
  }

  private async acceptPrivacyAgreement(): Promise<void> {
    await AppSettings.acceptAgreement(this.context());
    this.agreementAccepted = true;
    await UmengAnalytics.initialize();
    await this.initializeAfterPrivacyConsent();
    await this.loadRemoteStorySwitch();
    this.consumeNotificationStory();
    this.offerStoryReminderIfNeeded();
  }

  private async loadRemoteStorySwitch(): Promise<void> {
    this.storySwitch = await RemoteContentConfig.fetchStorySwitch();
    StoryCatalog.setArticlesEnabled(this.storySwitch === 1);
    this.storyCatalog = await StoryCatalog.load(this.context());
  }

  private async initializeAfterPrivacyConsent(): Promise<void> {
    this.sleepRecordingPaths = SleepRecorder.listRecordings(this.context());
    this.storyCatalog = await StoryCatalog.load(this.context());
    await MediaSessionService.initialize(
      this.context(),
      () => this.handleMediaPlay(),
      () => this.handleMediaPause(),
      () => this.handleMediaPrevious(),
      () => this.handleMediaNext()
    );
    if (this.storyClockTimer < 0) {
      this.storyClockTimer = setInterval(() => {
        if (this.storyPlaying) {
          this.storyElapsedSeconds = Math.min(
            this.storyElapsedSeconds + 1,
            this.currentStoryLines().length * 18
          );
        }
      }, 1000);
    }
    setTimeout(() => this.consumeNotificationStory(), 300);
  }

  private async toggleStoryReminder(): Promise<void> {
    if (this.storyReminderEnabled) {
      await StoryNotificationService.disable();
      this.storyReminderEnabled = false;
      await AppSettings.setStoryReminderEnabled(this.context(), false);
      promptAction.showToast({ message: '故事提醒已关闭' });
      return;
    }
    await this.enableStoryReminder();
  }

  private async enableStoryReminder(): Promise<void> {
    const enabled = await StoryNotificationService.enable(this.context());
    this.storyReminderEnabled = enabled;
    await AppSettings.setStoryReminderEnabled(this.context(), enabled);
    promptAction.showToast({ message: enabled ? '故事提醒已开启' : '未获得通知权限，故事提醒未开启' });
  }

  private offerStoryReminderIfNeeded(): void {
    if (this.storyReminderAsked || this.storyReminderEnabled) {
      return;
    }
    setTimeout(() => {
      if (this.agreementAccepted && this.route === 'home' && this.dialogMode.length === 0) {
        this.dialogMode = 'storyReminder';
      }
    }, 600);
  }

  private context(): common.UIAbilityContext {
    return getContext(this) as common.UIAbilityContext;
  }

  private maskPhone(phone: string): string {
    if (phone.length !== 11) {
      return phone;
    }
    return `${phone.substring(0, 3)}****${phone.substring(7)}`;
  }

  private async sendSecurityCode(): Promise<void> {
    if (this.securityBusy || this.phoneNumber.length !== 11) {
      return;
    }
    this.securityBusy = true;
    try {
      await AuthService.requestVerificationCode(this.phoneNumber);
      this.securityMessage = '验证码已发送';
    } catch (error) {
      this.securityMessage = `${error}`;
    } finally {
      this.securityBusy = false;
    }
  }

  private async changePassword(): Promise<void> {
    if (this.securityBusy || this.securityCode.length < 4 || this.newPassword.length < 6) {
      this.securityMessage = '请输入正确验证码，新密码至少为6位';
      return;
    }
    this.securityBusy = true;
    try {
      await AuthService.setPassword(this.phoneNumber, this.securityCode, this.newPassword);
      this.securityCode = '';
      this.newPassword = '';
      this.securityMessage = '';
      this.route = 'home';
      this.activeTab = 3;
    } catch (error) {
      this.securityMessage = `${error}`;
    } finally {
      this.securityBusy = false;
    }
  }

  private async deleteAccount(): Promise<void> {
    if (this.securityBusy || this.securityCode.length < 4) {
      this.securityMessage = '请输入正确的验证码';
      return;
    }
    this.securityBusy = true;
    try {
      await AuthService.deleteAccount(this.phoneNumber, this.securityCode);
      await AppSettings.clearAccount(this.context());
      this.isLoggedIn = false;
      this.phoneNumber = '';
      this.accessToken = '';
      this.isVip = false;
      this.securityCode = '';
      this.securityMessage = '';
      this.route = 'home';
      this.activeTab = 3;
    } catch (error) {
      this.securityMessage = `${error}`;
    } finally {
      this.securityBusy = false;
    }
  }

  private async toggleMonitoring(): Promise<void> {
    if (this.isMonitoring) {
      try {
        const path = await SleepRecorder.stop();
        this.sleepRecordingPlaying = false;
        this.isMonitoring = false;
        this.stopSleepTimer();
        if (this.sleepElapsedSeconds < 30 * 60) {
          SleepRecorder.deleteRecording(path);
          this.sleepRecordingPath = '';
          this.sleepRecordingPaths = SleepRecorder.listRecordings(this.context());
          promptAction.showToast({ message: '睡眠时长不足30分钟，本次记录未保存' });
          return;
        }
        this.sleepRecordingPath = path;
        this.sleepRecordingPaths = SleepRecorder.listRecordings(this.context());
        promptAction.showToast({ message: `睡眠录音已保存：${path.substring(path.lastIndexOf('/') + 1)}` });
      } catch (_) {
        this.isMonitoring = false;
        this.stopSleepTimer();
        promptAction.showToast({ message: '结束录音失败，请稍后重试' });
      }
      return;
    }
    if (!this.sleepSensitiveConsent) {
      this.dialogMode = 'sleepConsent';
      return;
    }
    const manager = abilityAccessCtrl.createAtManager();
    const permissions: Array<Permissions> = ['ohos.permission.MICROPHONE'];
    const result = await manager.requestPermissionsFromUser(this.context(), permissions);
    if (result.authResults.length > 0 && result.authResults[0] === 0) {
      try {
        await SleepRecorder.start(this.context());
        this.sleepElapsedSeconds = 0;
        this.isMonitoring = true;
        this.startSleepTimer();
        promptAction.showToast({ message: '睡眠监测已开始，正在录音' });
      } catch (_) {
        this.isMonitoring = false;
        this.stopSleepTimer();
        promptAction.showToast({ message: '录音启动失败，请检查麦克风是否被占用' });
      }
    } else {
      this.dialogMode = 'microphone';
    }
  }

  private startSleepTimer(): void {
    this.stopSleepTimer();
    this.sleepTimer = setInterval(() => {
      this.sleepElapsedSeconds++;
    }, 1000);
  }

  private stopSleepTimer(): void {
    if (this.sleepTimer >= 0) {
      clearInterval(this.sleepTimer);
      this.sleepTimer = -1;
    }
  }

  @Builder
  private vipSoundPrompt() {
    Stack() {
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('#78000000')
        .onClick(() => {
          this.vipSoundPromptVisible = false;
        })

      Column({ space: 0 }) {
        Stack() {
          Column()
            .width(78)
            .height(78)
            .linearGradient({
              angle: 135,
              colors: [['#FFF2C7', 0], ['#E9B85D', 1]] as [string, number][]
            })
            .borderRadius(39)
          Text('♛')
            .fontFamily('MiSans')
            .fontSize(38)
            .fontWeight(FontWeight.Bold)
            .fontColor('#704317')
        }
        .width(78)
        .height(78)
        .margin({ top: 24, bottom: 15 })

        Text('解锁 VIP 助眠声音')
          .fontFamily('MiSans')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFF1CE')

        Text('第 41 个及后续声音为会员专享\n开通后即可下载并无限畅听')
          .fontFamily('MiSans')
          .fontSize(14)
          .fontColor('#D7BC91')
          .lineHeight(22)
          .textAlign(TextAlign.Center)
          .margin({ top: 10, bottom: 20 })

        Row({ space: 8 }) {
          Text('海量助眠声')
            .fontFamily('MiSans')
            .fontSize(11)
            .fontColor('#F2D29E')
          Text('高速下载')
            .fontFamily('MiSans')
            .fontSize(11)
            .fontColor('#F2D29E')
          Text('会员专享')
            .fontFamily('MiSans')
            .fontSize(11)
            .fontColor('#F2D29E')
        }
        .margin({ bottom: 22 })

        Text('立即开通 VIP')
          .fontFamily('MiSans')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#553112')
          .width('100%')
          .height(48)
          .textAlign(TextAlign.Center)
          .backgroundColor('#F4CF8A')
          .borderRadius(24)
          .onClick(() => {
            this.vipSoundPromptVisible = false;
            this.route = 'vip';
          })

        Text('暂不开通')
          .fontFamily('MiSans')
          .fontSize(13)
          .fontColor('#A98C67')
          .height(44)
          .width('100%')
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.vipSoundPromptVisible = false;
          })
      }
      .width('84%')
      .padding({ left: 22, right: 22, bottom: 8 })
      .alignItems(HorizontalAlign.Center)
      .linearGradient({
        angle: 145,
        colors: [['#38281D', 0], ['#17100C', 1]] as [string, number][]
      })
      .border({ width: 1, color: '#8A633D' })
      .borderRadius(24)
      .shadow({ radius: 30, color: '#55000000', offsetY: 12 })
    }
    .width('100%')
    .height('100%')
    .alignContent(Alignment.Center)
    .zIndex(100)
  }

  private pad(value: number): string {
    return value < 10 ? `00${value}` : `0${value}`;
  }
}
