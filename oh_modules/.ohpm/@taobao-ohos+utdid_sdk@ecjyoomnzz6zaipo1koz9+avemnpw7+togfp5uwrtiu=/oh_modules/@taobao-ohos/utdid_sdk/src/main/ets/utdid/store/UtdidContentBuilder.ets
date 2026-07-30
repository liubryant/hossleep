import { StringUtils } from "../../utils/StringUtils";
import { bundleManager } from "@kit.AbilityKit";
import { UtdidLogger } from "../../utils/UtdidLogger";
import { Variables } from "../Variables";

export class UtdidContentBuilder {
  private static readonly MODULE_AUDID: string = "audid";
  private static readonly MODULE_UTDID: string = "utdid";
  private static readonly MODULE_APPKEY: string = "appkey";
  private static readonly MODULE_APPNAME: string = "appName";
  private static readonly TYPE_AUDID: string = "audid";
  private static readonly BODY: string = '{"type":"%s","timestamp":%s,"data":%s}';
  static bundleName: string = "";

  static buildUDID(utdid: string): string {
    let dataBody = UtdidContentBuilder.BODY.replace('%s', UtdidContentBuilder.TYPE_AUDID)
      .replace('%s', Variables.getInstance().getCurrentTimeMillisString())
      .replace('%s', UtdidContentBuilder._buildAudidDataJsonString(utdid, null, "", UtdidContentBuilder._getBundleName()));

    return StringUtils.getStringWithoutBlank(dataBody);
  }

  private static _getBundleName(): string {
    let bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT;

    try {
      let data = bundleManager.getBundleInfoForSelfSync(bundleFlags);
      UtdidContentBuilder.bundleName = data.name;
    } catch (err) {
      UtdidLogger.e("getBundleInfoForSelfSync failed:" + err.message);
    }
    return UtdidContentBuilder.bundleName;
  }

  private static _buildAudidDataJsonString(utdid: string, audid: string | null, appkey: string, appname: string): string {
    let map = new Map<string, string | null>();
    map.set(UtdidContentBuilder.MODULE_AUDID, audid);
    map.set(UtdidContentBuilder.MODULE_UTDID, utdid);
    map.set(UtdidContentBuilder.MODULE_APPKEY, appkey);
    map.set(UtdidContentBuilder.MODULE_APPNAME, appname);
    return StringUtils.convertMapToJSONString(map, true);
  }

  static getPackageName(): string {
    return UtdidContentBuilder.bundleName;
  }
}