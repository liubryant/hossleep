import { StringUtils } from '../../utils/StringUtils';
import { Context } from '@kit.AbilityKit';
import { get_utdid_native } from 'libutdid_native.so';
import { UtdidUploadTask } from '../upload/UtdidUploadTask';

const DEFAULT_UTDID = 'ffffffffffffffffffffffff';

export class UTDevice {
  private static mUtdid: string = '';

  // 同步Get方法
  static getUtdid(context?: Context | undefined | null): string {
    try {
        // 判断缓存中是否已经有值
        if (StringUtils.isEmpty(UTDevice.mUtdid)) {
          // context可以为空 传入context兼容历史入参 当前方案不需要将context传入c层
          let res: string = get_utdid_native();
          console.debug("[UTDID]get_utdid_native:" + res);
          // 判断返回值是否合法
          if (StringUtils.isValidUtdid(res)) {
            UTDevice.mUtdid = res;
            UtdidUploadTask.getInstance().upload();

            return UTDevice.mUtdid;
          } else {
            return DEFAULT_UTDID;
          }
        } else {
          console.debug("[UTDID]getUtdidFromCache:" + UTDevice.mUtdid);
          return UTDevice.mUtdid;
        }
    } catch (e) {
      console.debug(`[UTDID]error in getUtdid: ${e.message}`);
      return DEFAULT_UTDID;
    }
  }

  static getCacheUtdid(): string {
    return UTDevice.mUtdid;
  }
}