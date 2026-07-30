import { connection } from "@kit.NetworkKit";
import { StringUtils } from "../../utils/StringUtils";
import { UtdidLogger } from "../../utils/UtdidLogger";
import { UTDevice } from "../device/UTDevice";
import { UtdidResponse } from "./UtdidResponse";
import { UtdidContentBuilder } from "../store/UtdidContentBuilder";
import { UtdidContentUtil } from "../store/UtdidContentUtil";
import { HttpUtils } from "./HttpUtils";

export class UtdidUploadTask {
  private static readonly DELAY_TIME: number = 5000; // 5s
  private static readonly POST_HTTP_URL: string = "https://audid-api.taobao.com/v2.0/a/audid/req/";
  private static mInstance: UtdidUploadTask | null = null;
  private mIsConnectInternet: boolean = false;
  private mIsRunning: boolean = false;

  static getInstance(): UtdidUploadTask {
    if (UtdidUploadTask.mInstance == null) {
      UtdidUploadTask.mInstance = new UtdidUploadTask();
    }
    return UtdidUploadTask.mInstance;
  }

  upload(): void {
    if (!this._ifConnectInternet()) {
      return;
    }
    if (this.mIsRunning) {
      return;
    }
    this.mIsRunning = true;
    setTimeout(async () => {
      await this._uploadFromCache();
      // this.mIsRunning = false;
    }, UtdidUploadTask.DELAY_TIME)
  }

  private _ifConnectInternet(): boolean {
    try {
      if (canIUse('SystemCapability.Communication.NetManager.Core')) {
        const netHandle = connection.getDefaultNetSync();
        const netCapabilities = connection.getNetCapabilitiesSync(netHandle);
        const networkCap = netCapabilities.networkCap || [];
        this.mIsConnectInternet = networkCap.includes(connection.NetCap.NET_CAPABILITY_VALIDATED);
      } else {
        this.mIsConnectInternet = true;
      }
    } catch (e) {
      UtdidLogger.e('error in ifNetworkValidated is:' + e.message);
      this.mIsConnectInternet = true;
    }
    return this.mIsConnectInternet;
  }

  private async _uploadFromCache(): Promise<void> {
    let postData: string = this._buildPostData();
    if (StringUtils.isEmpty(postData)) {
      UtdidLogger.d("postData is empty");
      return;
    }
    let isSendSuccess = await this._reqServer(postData);
    if (isSendSuccess) {
      UtdidLogger.d("upload success");
    } else {
      UtdidLogger.d("upload fail");
    }
  }

  private _buildPostData(): string {
    let cacheUtdid: string = UTDevice.getCacheUtdid();
    // let cacheUtdid: string = "YPliVYyVyt0DAHnMqy7xkWi+";
    if (StringUtils.isEmpty(cacheUtdid)) {
      return "";
    }
    let udid = UtdidContentBuilder.buildUDID(cacheUtdid);
    return UtdidContentUtil.getEncodedContent(udid);
  }

  private async _reqServer(postData: string): Promise<boolean> {
    HttpUtils.initHttpRequest();
    let response = await HttpUtils.sendRequest(UtdidUploadTask.POST_HTTP_URL, postData);
    if (response == null) {
      return false;
    }

    return UtdidResponse.response(response);
  }
}