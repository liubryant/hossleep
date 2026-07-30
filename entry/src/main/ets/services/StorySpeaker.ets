import { textToSpeech } from '@kit.CoreSpeechKit';

class EngineParams implements textToSpeech.CreateEngineParams {
  language: string = 'zh-CN';
  person: number = 0;
  online: number = 1;
}

class SpeakParams implements textToSpeech.SpeakParams {
  requestId: string;
  constructor(requestId: string) {
    this.requestId = requestId;
  }
}

class StorySpeakListener implements textToSpeech.SpeakListener {
  onStart(requestId: string): void {
    StorySpeaker.handleLineStarted(requestId);
  }
  onComplete(requestId: string): void {
    StorySpeaker.handleLineComplete(requestId);
  }
  onStop(): void {}
  onError(requestId: string): void {
    StorySpeaker.handleError(requestId);
  }
}

export class StorySpeaker {
  private static engine: textToSpeech.TextToSpeechEngine | undefined = undefined;
  private static speaking: boolean = false;
  private static lines: string[] = [];
  private static lineIndex: number = 0;
  private static session: number = 0;
  private static currentRequestId: string = '';
  private static onLineChanged: (index: number) => void = () => {};
  private static onFinished: () => void = () => {};

  static async toggle(text: string, onLineChanged?: (index: number) => void,
    onFinished?: () => void): Promise<boolean> {
    if (StorySpeaker.speaking && StorySpeaker.engine) {
      StorySpeaker.engine.stop();
      StorySpeaker.speaking = false;
      StorySpeaker.session++;
      return false;
    }
    if (!StorySpeaker.engine) {
      StorySpeaker.engine = await textToSpeech.createEngine(new EngineParams());
      StorySpeaker.engine.setListener(new StorySpeakListener());
    }
    StorySpeaker.lines = text.split('\n').map((line: string) => line.trim())
      .filter((line: string) => line.length > 0);
    StorySpeaker.lineIndex = 0;
    StorySpeaker.session++;
    StorySpeaker.onLineChanged = onLineChanged ?? (() => {});
    StorySpeaker.onFinished = onFinished ?? (() => {});
    StorySpeaker.speaking = true;
    StorySpeaker.speakCurrentLine();
    return true;
  }

  static async seek(text: string, lineIndex: number, onLineChanged?: (index: number) => void,
    onFinished?: () => void): Promise<boolean> {
    if (StorySpeaker.engine) {
      StorySpeaker.engine.stop();
    } else {
      StorySpeaker.engine = await textToSpeech.createEngine(new EngineParams());
      StorySpeaker.engine.setListener(new StorySpeakListener());
    }
    StorySpeaker.lines = text.split('\n').map((line: string) => line.trim())
      .filter((line: string) => line.length > 0);
    if (StorySpeaker.lines.length === 0) {
      StorySpeaker.speaking = false;
      return false;
    }
    StorySpeaker.lineIndex = Math.max(0, Math.min(lineIndex, StorySpeaker.lines.length - 1));
    StorySpeaker.session++;
    StorySpeaker.onLineChanged = onLineChanged ?? (() => {});
    StorySpeaker.onFinished = onFinished ?? (() => {});
    StorySpeaker.speaking = true;
    StorySpeaker.speakCurrentLine();
    return true;
  }

  static stop(): void {
    if (StorySpeaker.engine && StorySpeaker.speaking) {
      StorySpeaker.engine.stop();
    }
    StorySpeaker.session++;
    StorySpeaker.speaking = false;
    StorySpeaker.currentRequestId = '';
  }

  static handleLineStarted(requestId: string): void {
    if (!StorySpeaker.speaking || requestId !== StorySpeaker.currentRequestId) {
      return;
    }
    StorySpeaker.onLineChanged(StorySpeaker.lineIndex);
  }

  static handleLineComplete(requestId: string): void {
    if (!StorySpeaker.speaking || requestId !== StorySpeaker.currentRequestId) {
      return;
    }
    StorySpeaker.lineIndex++;
    if (StorySpeaker.lineIndex >= StorySpeaker.lines.length) {
      StorySpeaker.speaking = false;
      StorySpeaker.onFinished();
      return;
    }
    const currentSession = StorySpeaker.session;
    setTimeout(() => {
      if (StorySpeaker.speaking && StorySpeaker.session === currentSession) {
        StorySpeaker.speakCurrentLine();
      }
    }, 0);
  }

  static handleError(requestId: string): void {
    if (requestId !== StorySpeaker.currentRequestId) {
      return;
    }
    StorySpeaker.speaking = false;
    StorySpeaker.currentRequestId = '';
    StorySpeaker.onFinished();
  }

  private static speakCurrentLine(): void {
    if (!StorySpeaker.engine || !StorySpeaker.speaking ||
      StorySpeaker.lineIndex >= StorySpeaker.lines.length) {
      return;
    }
    const requestId = `story-${StorySpeaker.session}-${StorySpeaker.lineIndex}`;
    StorySpeaker.currentRequestId = requestId;
    StorySpeaker.engine.speak(StorySpeaker.lines[StorySpeaker.lineIndex], new SpeakParams(requestId));
  }
}
