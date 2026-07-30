import { common } from '@kit.AbilityKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import { media } from '@kit.MediaKit';

export class SleepRecorder {
  private static readonly MAX_RECORDINGS: number = 90;
  private static recorder: media.AVRecorder | undefined = undefined;
  private static recordFile: fs.File | undefined = undefined;
  private static outputPath: string = '';
  private static playback: media.AVPlayer | undefined = undefined;
  private static playbackFile: fs.File | undefined = undefined;
  private static playbackPath: string = '';
  private static playbackPlaying: boolean = false;

  static async start(context: common.UIAbilityContext): Promise<string> {
    await SleepRecorder.cancel();
    const directory = `${context.filesDir}/SleepRecords`;
    try {
      fs.mkdirSync(directory);
    } catch (_) {
    }
    const now = new Date();
    const name = `sleep_${now.getFullYear()}${SleepRecorder.two(now.getMonth() + 1)}${SleepRecorder.two(now.getDate())}_${SleepRecorder.two(now.getHours())}${SleepRecorder.two(now.getMinutes())}${SleepRecorder.two(now.getSeconds())}.m4a`;
    SleepRecorder.outputPath = `${directory}/${name}`;
    SleepRecorder.recordFile = fs.openSync(SleepRecorder.outputPath,
      fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE | fs.OpenMode.TRUNC);
    const recorder = await media.createAVRecorder();
    SleepRecorder.recorder = recorder;
    const profile: media.AVRecorderProfile = {
      audioBitrate: 64000,
      audioChannels: 1,
      audioCodec: media.CodecMimeType.AUDIO_AAC,
      audioSampleRate: 16000,
      fileFormat: media.ContainerFormatType.CFT_MPEG_4A
    };
    const config: media.AVRecorderConfig = {
      audioSourceType: media.AudioSourceType.AUDIO_SOURCE_TYPE_MIC,
      profile: profile,
      url: `fd://${SleepRecorder.recordFile.fd}`
    };
    await recorder.prepare(config);
    await recorder.start();
    return SleepRecorder.outputPath;
  }

  static async stop(): Promise<string> {
    const savedPath = SleepRecorder.outputPath;
    if (SleepRecorder.recorder) {
      await SleepRecorder.recorder.stop();
      await SleepRecorder.recorder.release();
      SleepRecorder.recorder = undefined;
    }
    if (SleepRecorder.recordFile) {
      fs.closeSync(SleepRecorder.recordFile);
      SleepRecorder.recordFile = undefined;
    }
    SleepRecorder.outputPath = '';
    return savedPath;
  }

  static async cancel(): Promise<void> {
    if (SleepRecorder.recorder) {
      try {
        await SleepRecorder.recorder.release();
      } catch (_) {
      }
      SleepRecorder.recorder = undefined;
    }
    if (SleepRecorder.recordFile) {
      fs.closeSync(SleepRecorder.recordFile);
      SleepRecorder.recordFile = undefined;
    }
    SleepRecorder.outputPath = '';
  }

  static async togglePlayback(path: string): Promise<boolean> {
    if (path.length === 0) {
      throw new Error('暂无可播放的睡眠录音');
    }
    if (SleepRecorder.playback && SleepRecorder.playbackPath === path) {
      if (SleepRecorder.playbackPlaying) {
        await SleepRecorder.playback.pause();
        SleepRecorder.playbackPlaying = false;
      } else {
        await SleepRecorder.playback.play();
        SleepRecorder.playbackPlaying = true;
      }
      return SleepRecorder.playbackPlaying;
    }
    await SleepRecorder.stopPlayback();
    const file = fs.openSync(path, fs.OpenMode.READ_ONLY);
    const stat = fs.statSync(path);
    const player = await media.createAVPlayer();
    SleepRecorder.playback = player;
    SleepRecorder.playbackFile = file;
    SleepRecorder.playbackPath = path;
    player.on('stateChange', (state: string) => {
      if (state === 'initialized') {
        player.prepare();
      } else if (state === 'prepared') {
        player.play();
        SleepRecorder.playbackPlaying = true;
      } else if (state === 'completed' || state === 'stopped' || state === 'error') {
        SleepRecorder.playbackPlaying = false;
      }
    });
    player.fdSrc = { fd: file.fd, offset: 0, length: stat.size };
    return true;
  }

  static listRecordings(context: common.UIAbilityContext): string[] {
    const directory = `${context.filesDir}/SleepRecords`;
    try {
      const paths = fs.listFileSync(directory)
        .filter((name: string): boolean => name.endsWith('.m4a'))
        .sort((left: string, right: string): number => right.localeCompare(left))
        .map((name: string): string => `${directory}/${name}`);
      paths.slice(SleepRecorder.MAX_RECORDINGS).forEach((path: string) => {
        SleepRecorder.deleteRecording(path);
      });
      return paths.slice(0, SleepRecorder.MAX_RECORDINGS);
    } catch (_) {
      return [];
    }
  }

  static async clearAll(context: common.UIAbilityContext): Promise<void> {
    await SleepRecorder.stopPlayback();
    const directory = `${context.filesDir}/SleepRecords`;
    try {
      fs.listFileSync(directory)
        .filter((name: string): boolean => name.endsWith('.m4a'))
        .forEach((name: string) => SleepRecorder.deleteRecording(`${directory}/${name}`));
    } catch (_) {
    }
  }

  static deleteRecording(path: string): void {
    if (path.length === 0) {
      return;
    }
    try {
      fs.unlinkSync(path);
    } catch (_) {
    }
  }

  static async stopPlayback(): Promise<void> {
    if (SleepRecorder.playback) {
      await SleepRecorder.playback.release();
      SleepRecorder.playback = undefined;
    }
    if (SleepRecorder.playbackFile) {
      fs.closeSync(SleepRecorder.playbackFile);
      SleepRecorder.playbackFile = undefined;
    }
    SleepRecorder.playbackPath = '';
    SleepRecorder.playbackPlaying = false;
  }

  private static two(value: number): string {
    return value < 10 ? `0${value}` : `${value}`;
  }
}
