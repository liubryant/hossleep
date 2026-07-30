export class UtdidLogger {
  private static readonly TAG_LOG_PREFIX: string = "[UTDID]"

  static d(...args: string[]) {
    console.debug(UtdidLogger.TAG_LOG_PREFIX, ...args);
  }

  static e(...args: string[]) {
    console.error(UtdidLogger.TAG_LOG_PREFIX, ...args);
  }
}