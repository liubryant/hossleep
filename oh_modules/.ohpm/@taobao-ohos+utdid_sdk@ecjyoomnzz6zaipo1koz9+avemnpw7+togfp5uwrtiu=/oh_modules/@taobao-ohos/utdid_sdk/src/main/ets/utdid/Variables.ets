import { systemDateTime } from "@kit.BasicServicesKit";

export class Variables {
  private static mInstance: Variables | null = null;
  private mDeltaTime: number = 0;

  static getInstance(): Variables {
    if (Variables.mInstance == null) {
      Variables.mInstance = new Variables();
    }
    return Variables.mInstance;
  }

  setSystemTime(time: number): void {
    this.mDeltaTime = time - systemDateTime.getTime();
  }

  getCurrentTimeMillis(): number {
    return systemDateTime.getTime() + this.mDeltaTime;
  }

  getCurrentTimeMillisString(): string {
    return this.getCurrentTimeMillis().toString();
  }
}