import { common } from '@kit.AbilityKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import { media } from '@kit.MediaKit';
import { http } from '@kit.NetworkKit';
import { resourceManager } from '@kit.LocalizationKit';
import { SoundSceneItem } from '../models/SleepModels';

export class SoundPlayer {
  private static player: media.AVPlayer | undefined = undefined;
  private static rawFd: resourceManager.RawFileDescriptor | undefined = undefined;
  private static file: fs.File | undefined = undefined;
  private static currentId: string = '';
  private static currentIndex: number = -1;
  private static playing: boolean = false;
  private static playToken: number = 0;

  static async toggle(context: common.UIAbilityContext, scene: SoundSceneItem,
    onProgress: (value: number) => void = () => {}): Promise<boolean> {
    if (SoundPlayer.currentId === scene.id && SoundPlayer.player) {
      if (SoundPlayer.playing) {
        await SoundPlayer.player.pause();
        SoundPlayer.playing = false;
      } else {
        await SoundPlayer.player.play();
        SoundPlayer.playing = true;
      }
      return SoundPlayer.playing;
    }
    await SoundPlayer.play(context, scene, onProgress);
    return true;
  }

  static isCached(context: common.UIAbilityContext, scene: SoundSceneItem): boolean {
    if (scene.isBundledAudio) {
      return true;
    }
    try {
      return fs.accessSync(SoundPlayer.cachedPath(context, scene));
    } catch (_) {
      return false;
    }
  }

  static async play(context: common.UIAbilityContext, scene: SoundSceneItem,
    onProgress: (value: number) => void): Promise<void> {
    const token = ++SoundPlayer.playToken;
    await SoundPlayer.releaseCurrent(context);
    let cachedPath = '';
    if (!scene.isBundledAudio) {
      cachedPath = SoundPlayer.cachedPath(context, scene);
      if (!SoundPlayer.isCached(context, scene)) {
        await SoundPlayer.download(scene, cachedPath, onProgress);
      }
    }
    if (token !== SoundPlayer.playToken) {
      return;
    }
    const player = await media.createAVPlayer();
    if (token !== SoundPlayer.playToken) {
      await player.release();
      return;
    }
    SoundPlayer.player = player;
    SoundPlayer.currentId = scene.id;
    SoundPlayer.currentIndex = scene.index;
    player.loop = true;
    player.on('stateChange', (state: string) => {
      if (state === 'initialized') {
        player.prepare();
      } else if (state === 'prepared') {
        player.play();
        SoundPlayer.playing = true;
      } else if (state === 'completed' || state === 'stopped' || state === 'error') {
        SoundPlayer.playing = false;
      }
    });
    if (scene.isBundledAudio) {
      const path = SoundPlayer.bundledFileName(scene.index);
      const fd = await context.resourceManager.getRawFd(path);
      SoundPlayer.rawFd = fd;
      player.fdSrc = { fd: fd.fd, offset: fd.offset, length: fd.length };
    } else {
      SoundPlayer.file = fs.openSync(cachedPath, fs.OpenMode.READ_ONLY);
      const stat = fs.statSync(cachedPath);
      player.fdSrc = { fd: SoundPlayer.file.fd, offset: 0, length: stat.size };
    }
  }

  static async stop(context: common.UIAbilityContext): Promise<void> {
    SoundPlayer.playToken++;
    await SoundPlayer.releaseCurrent(context);
  }

  private static async releaseCurrent(context: common.UIAbilityContext): Promise<void> {
    if (SoundPlayer.player) {
      await SoundPlayer.player.release();
      SoundPlayer.player = undefined;
    }
    if (SoundPlayer.rawFd) {
      context.resourceManager.closeRawFd(SoundPlayer.bundledFileName(SoundPlayer.currentIndex));
      SoundPlayer.rawFd = undefined;
    }
    if (SoundPlayer.file) {
      fs.closeSync(SoundPlayer.file);
      SoundPlayer.file = undefined;
    }
    SoundPlayer.currentId = '';
    SoundPlayer.currentIndex = -1;
    SoundPlayer.playing = false;
  }

  private static async download(scene: SoundSceneItem, destination: string,
    onProgress: (value: number) => void): Promise<void> {
    const directory = destination.substring(0, destination.lastIndexOf('/'));
    try {
      fs.mkdirSync(directory);
    } catch (_) {
    }
    const request = http.createHttp();
    let displayedProgress = 0;
    const progressTimer = setInterval(() => {
      if (displayedProgress < 0.9) {
        const step = displayedProgress < 0.25 ? 0.035 : displayedProgress < 0.65 ? 0.018 : 0.008;
        displayedProgress = Math.min(0.9, displayedProgress + step);
        onProgress(displayedProgress);
      }
    }, 250);
    request.on('dataReceiveProgress', (info: http.DataReceiveProgressInfo) => {
      if (info.totalSize > 0) {
        displayedProgress = Math.max(displayedProgress, info.receiveSize / info.totalSize);
      } else if (info.receiveSize > 0) {
        displayedProgress = Math.max(displayedProgress,
          Math.min(0.88, 0.08 + info.receiveSize / (info.receiveSize + 1024 * 1024)));
      }
      onProgress(Math.max(0.01, Math.min(0.95, displayedProgress)));
    });
    try {
      onProgress(0);
      const response = await request.request(`https://www.cjym123.cn/api/sounds/${scene.id}/download`, {
        method: http.RequestMethod.GET,
        expectDataType: http.HttpDataType.ARRAY_BUFFER,
        connectTimeout: 20000,
        readTimeout: 120000
      });
      if (response.responseCode < 200 || response.responseCode >= 300) {
        throw new Error(`声音下载失败（${response.responseCode}）`);
      }
      const file = fs.openSync(destination,
        fs.OpenMode.WRITE_ONLY | fs.OpenMode.CREATE | fs.OpenMode.TRUNC);
      fs.writeSync(file.fd, response.result as ArrayBuffer);
      fs.closeSync(file);
      onProgress(1);
    } finally {
      clearInterval(progressTimer);
      request.destroy();
    }
  }

  private static cachedPath(context: common.UIAbilityContext, scene: SoundSceneItem): string {
    const audioFile = scene.audioFile ?? 'sound.mp3';
    const extension = audioFile.substring(audioFile.lastIndexOf('.') + 1);
    return `${context.cacheDir}/Sounds/${scene.id}.${extension}`;
  }

  private static bundledFileName(index: number): string {
    const number = index < 10 ? `00${index}` : `0${index}`;
    return index === 2 || index === 14 ? `sounds/sound_${number}.m4a` : `sounds/sound_${number}.mp3`;
  }
}
