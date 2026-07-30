import { AbilityStage } from '@kit.AbilityKit';
import { InternalPlugin, preInit } from '@umeng/analytics';

export default class HossleepAbilityStage extends AbilityStage {
  onCreate(): void {
    // 仅完成 SDK 预初始化；此阶段不会开始采集或传输数据。
    // 真正的 init() 由用户同意隐私政策后的 UmengAnalytics.initialize() 触发。
    preInit({
      context: this.context.getApplicationContext(),
      plugins: [new InternalPlugin()]
    });
  }
}
