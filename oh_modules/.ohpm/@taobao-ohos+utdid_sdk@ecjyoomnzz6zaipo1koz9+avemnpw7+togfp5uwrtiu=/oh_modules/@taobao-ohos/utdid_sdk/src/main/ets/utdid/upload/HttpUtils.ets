import { StringUtils } from "../../utils/StringUtils";
import { HttpResponse } from "./HttpResponse";
import { url } from '@kit.ArkTS';
import { UtdidLogger } from "../../utils/UtdidLogger";
import { http } from "@kit.NetworkKit";
import { UtdidContentBuilder } from "../store/UtdidContentBuilder";
import { MD5Utils } from "../../utils/MD5Utils";
import { ByteUtils } from "../../utils/ByteUtils";
import { systemDateTime } from '@kit.BasicServicesKit';
import { Variables } from "../Variables";

export class HttpUtils {
  /**
   * 最大超时时间
   */
  private static readonly MAX_CONNECTION_TIME_OUT: number = 10000;
  /**
   * 最大读取数据的
   */
  private static readonly MAX_READ_CONNECTION_STREAM_TIME_OUT: number = 10000;

  private static readonly TIME_SCOPE: number = 30 * 60 * 1000;
  private static httpInstance: http.HttpRequest | null = null;
  private static readonly SDK_VERSION: string = "1.2.5";

  static initHttpRequest(): void {
    if (HttpUtils.httpInstance == null) {
      // 每一个httpRequest对应一个HTTP请求任务，不可复用
      HttpUtils.httpInstance = http.createHttp();
    }
  }

  static async sendRequest(aUrl: string, body: string): Promise<HttpResponse> {
    const response = new HttpResponse();
    if (StringUtils.isEmpty(aUrl)) {
      return response;
    }
    let curUrl: url.URL;
    try {
      curUrl = url.URL.parseURL(aUrl);
      if (StringUtils.isEmpty(curUrl.host)) {
        return response;
      }
    } catch (e) {
      UtdidLogger.e(e.message);
      return response;
    }
    let stringBuilder = "";
    let appname = UtdidContentBuilder.getPackageName();
    let timestamp: string = Variables.getInstance().getCurrentTimeMillisString();
    let streamInfo: http.HttpRequestOptions = {
      method: http.RequestMethod.POST,
      // 当使用POST请求时此字段用于传递请求体内容，具体格式与服务端协商确定
      extraData: body,
      usingCache: false,

      connectTimeout: HttpUtils.MAX_CONNECTION_TIME_OUT,
      readTimeout: HttpUtils.MAX_READ_CONNECTION_STREAM_TIME_OUT,
      header: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Charset": "UTF-8",
        "x-audid-appkey": "",
        "x-audid-sdk": HttpUtils.SDK_VERSION,
        "x-audid-timestamp": timestamp,
        "x-audid-appname": encodeURIComponent(appname)
      }
    };
    stringBuilder += `${appname}${HttpUtils.SDK_VERSION}${timestamp}${body}`;
    let md5 = MD5Utils.getHmacMd5Hex(stringBuilder);
    if (streamInfo.header != null) {
      let res = ByteUtils.toBase64String(ByteUtils.utf8Encode(md5));
      streamInfo.header["signature"] = res;
    }
    let initResponse: http.HttpResponse | null = null;
    // 建立链接
    let now = systemDateTime.getTime();
    try {
      if (HttpUtils.httpInstance != null) {
        initResponse = await HttpUtils.httpInstance.request(aUrl, streamInfo);
      }
    } catch (e) {
      response.rt = systemDateTime.getTime() - now;
      UtdidLogger.e(e.message);
      return response;
    }
    if (initResponse != null) {
      response.httpResponseCode = initResponse.responseCode;
      response.signature = initResponse.header["signature"];
      response.timestamp = initResponse.header["x-audid-timestamp"];
      let currentTime = Variables.getInstance().getCurrentTimeMillis();
      if (response.timestamp > 0
        && (response.timestamp > currentTime + HttpUtils.TIME_SCOPE
          || response.timestamp < currentTime - HttpUtils.TIME_SCOPE)) {
        Variables.getInstance().setSystemTime(response.timestamp);
      }
      response.rt = systemDateTime.getTime() - now;
      if (typeof initResponse.result  == 'string') {
        response.data = ByteUtils.utf8Encode(initResponse.result);
      } else {
        response.data = initResponse.result as Uint8Array;
      }
    }
    return response;
  }
}