import { SoundSceneItem } from '../models/SleepModels';

export const FREE_MINDFULNESS_COUNT: number = 4;
export const FREE_SOUND_COUNT: number = 30;

export class VipAccessPolicy {
  static mindfulnessRequiresVip(index: number): boolean {
    return index >= FREE_MINDFULNESS_COUNT;
  }

  static soundRequiresVip(scene: SoundSceneItem): boolean {
    // 使用资源清单中的稳定 index，避免搜索、收藏或分类后权限顺序变化。
    return scene.index > FREE_SOUND_COUNT;
  }
}
