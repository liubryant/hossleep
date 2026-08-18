import { common } from '@kit.AbilityKit';
import { media } from '@kit.MediaKit';
import { resourceManager } from '@kit.LocalizationKit';

export class MindfulnessPlayer {
  private static player: media.AVPlayer | undefined = undefined;
  private static rawFd: resourceManager.RawFileDescriptor | undefined = undefined;
  private static rawPath: string = '';
  private static playing: boolean = false;

  static async play(context: common.UIAbilityContext, rawPath: string): Promise<void> {
    await MindfulnessPlayer.stop(context);
    const player = await media.createAVPlayer();
    MindfulnessPlayer.player = player;
    MindfulnessPlayer.rawPath = rawPath;
    // 正念冥想资源采用单曲循环，播放结束后自动从头继续。
    player.loop = true;
    player.on('stateChange', (state: string) => {
      if (state === 'initialized') {
        player.prepare();
      } else if (state === 'prepared') {
        player.play();
        MindfulnessPlayer.playing = true;
      } else if (state === 'completed' || state === 'stopped' || state === 'error') {
        MindfulnessPlayer.playing = false;
      }
    });
    const fd = await context.resourceManager.getRawFd(rawPath);
    MindfulnessPlayer.rawFd = fd;
    player.fdSrc = { fd: fd.fd, offset: fd.offset, length: fd.length };
  }

  static async toggle(): Promise<boolean> {
    if (!MindfulnessPlayer.player) {
      return false;
    }
    if (MindfulnessPlayer.playing) {
      await MindfulnessPlayer.player.pause();
      MindfulnessPlayer.playing = false;
    } else {
      await MindfulnessPlayer.player.play();
      MindfulnessPlayer.playing = true;
    }
    return MindfulnessPlayer.playing;
  }

  static async seek(milliseconds: number): Promise<void> {
    if (MindfulnessPlayer.player) {
      await MindfulnessPlayer.player.seek(milliseconds);
    }
  }

  static currentTime(): number {
    return MindfulnessPlayer.player ? MindfulnessPlayer.player.currentTime : 0;
  }

  static duration(): number {
    return MindfulnessPlayer.player ? MindfulnessPlayer.player.duration : 0;
  }

  static isPlaying(): boolean {
    return MindfulnessPlayer.playing;
  }

  static async stop(context: common.UIAbilityContext): Promise<void> {
    if (MindfulnessPlayer.player) {
      await MindfulnessPlayer.player.release();
      MindfulnessPlayer.player = undefined;
    }
    if (MindfulnessPlayer.rawFd) {
      context.resourceManager.closeRawFd(MindfulnessPlayer.rawPath);
      MindfulnessPlayer.rawFd = undefined;
    }
    MindfulnessPlayer.rawPath = '';
    MindfulnessPlayer.playing = false;
  }
}
