import { common } from '@kit.AbilityKit';
import { avSession } from '@kit.AVSessionKit';

export class MediaSessionService {
  private static session: avSession.AVSession | undefined = undefined;
  private static onPlay: () => void = () => {};
  private static onPause: () => void = () => {};
  private static onPrevious: () => void = () => {};
  private static onNext: () => void = () => {};

  static async initialize(context: common.UIAbilityContext, onPlay: () => void,
    onPause: () => void, onPrevious: () => void, onNext: () => void): Promise<void> {
    MediaSessionService.onPlay = onPlay;
    MediaSessionService.onPause = onPause;
    MediaSessionService.onPrevious = onPrevious;
    MediaSessionService.onNext = onNext;
    if (MediaSessionService.session) {
      return;
    }
    try {
      const session = await avSession.createAVSession(context, 'TimeSleepPlayer', 'audio');
      session.on('play', () => MediaSessionService.onPlay());
      session.on('pause', () => MediaSessionService.onPause());
      session.on('playPrevious', () => MediaSessionService.onPrevious());
      session.on('playNext', () => MediaSessionService.onNext());
      await session.activate();
      MediaSessionService.session = session;
    } catch (_) {
    }
  }

  static async showStory(index: number, title: string, playing: boolean, coverFile: string = ''): Promise<void> {
    await MediaSessionService.update(
      `story-${index}`,
      title,
      '时光睡眠 · 睡前故事',
      coverFile.length > 0
        ? `resource://RAWFILE/${coverFile}`
        : `resource://RAWFILE/ios_story_covers/story_${MediaSessionService.pad2(index)}.jpg`,
      playing
    );
  }

  static async showSound(index: number, title: string, playing: boolean): Promise<void> {
    await MediaSessionService.update(
      `sound-${index}`,
      title,
      '时光睡眠 · 助眠声音',
      `resource://RAWFILE/ios_sound_covers/sound_${MediaSessionService.pad2(index)}.jpg`,
      playing
    );
  }

  static async setPlaying(playing: boolean): Promise<void> {
    if (!MediaSessionService.session) {
      return;
    }
    try {
      await MediaSessionService.session.setAVPlaybackState({
        state: playing ? avSession.PlaybackState.PLAYBACK_STATE_PLAY :
          avSession.PlaybackState.PLAYBACK_STATE_PAUSE,
        speed: playing ? 1 : 0
      });
    } catch (_) {
    }
  }

  static async stop(): Promise<void> {
    if (!MediaSessionService.session) {
      return;
    }
    try {
      await MediaSessionService.session.setAVPlaybackState({
        state: avSession.PlaybackState.PLAYBACK_STATE_STOP,
        speed: 0
      });
    } catch (_) {
    }
  }

  private static async update(assetId: string, title: string, subtitle: string,
    cover: string, playing: boolean): Promise<void> {
    if (!MediaSessionService.session) {
      return;
    }
    try {
      await MediaSessionService.session.setAVMetadata({
        assetId: assetId,
        title: title,
        artist: '时光睡眠',
        album: subtitle,
        subtitle: subtitle,
        description: '让温柔的声音陪你入睡',
        mediaImage: cover
      });
      await MediaSessionService.setPlaying(playing);
    } catch (_) {
    }
  }

  private static pad2(value: number): string {
    return value < 10 ? `0${value}` : `${value}`;
  }
}
