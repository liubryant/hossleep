/**
 * 与 Android AuthRepository 保持一致的登录接口。
 */
import { http } from '@kit.NetworkKit';

const AUTH_BASE_URL: string = 'https://www.cjym123.cn';

interface ApiResponseData {
  code: number;
  msg: string;
  data?: LoginResponseData | SmsCodeResponseData;
}

interface LoginResponseData {
  phone: string;
  newUser: boolean;
  accessToken?: string;
  token?: string;
}

interface SmsCodeResponseData {
  expiresIn: number;
}

export class LoginResult {
  phone: string;
  newUser: boolean;
  accessToken: string;

  constructor(phone: string, newUser: boolean, accessToken: string = '') {
    this.phone = phone;
    this.newUser = newUser;
    this.accessToken = accessToken;
  }
}

class PhoneRequest {
  phone: string;
  constructor(phone: string) {
    this.phone = phone;
  }
}

class LoginCodeRequest {
  phone: string;
  code: string;
  deviceModel: string = 'HarmonyOS Device';
  osVersion: string = 'HarmonyOS';
  appName: string = 'timesleep';
  constructor(phone: string, code: string) {
    this.phone = phone;
    this.code = code;
  }
}

class LoginPasswordRequest {
  phone: string;
  password: string;
  deviceModel: string = 'HarmonyOS Device';
  osVersion: string = 'HarmonyOS';
  appName: string = 'timesleep';
  constructor(phone: string, password: string) {
    this.phone = phone;
    this.password = password;
  }
}

class SetPasswordRequest {
  phone: string;
  code: string;
  password: string;
  constructor(phone: string, code: string, password: string) {
    this.phone = phone;
    this.code = code;
    this.password = password;
  }
}

class DeleteAccountRequest {
  phone: string;
  code: string;
  constructor(phone: string, code: string) {
    this.phone = phone;
    this.code = code;
  }
}

export class AuthService {
  static async requestVerificationCode(phone: string): Promise<number> {
    const result = await AuthService.post('/im/bot/login-code', new PhoneRequest(phone));
    const data = result.data as SmsCodeResponseData | undefined;
    return data?.expiresIn ?? 300;
  }

  static async loginByCode(phone: string, code: string): Promise<LoginResult> {
    const result = await AuthService.post('/im/bot/login-by-code', new LoginCodeRequest(phone, code));
    return AuthService.loginResult(result);
  }

  static async loginByPassword(phone: string, password: string): Promise<LoginResult> {
    const result = await AuthService.post('/im/bot/login-by-password', new LoginPasswordRequest(phone, password));
    return AuthService.loginResult(result);
  }

  static async setPassword(phone: string, code: string, password: string): Promise<LoginResult> {
    const result = await AuthService.post('/im/bot/set-password', new SetPasswordRequest(phone, code, password));
    return AuthService.loginResult(result);
  }

  static async deleteAccount(phone: string, code: string): Promise<void> {
    await AuthService.post('/im/bot/remove_account', new DeleteAccountRequest(phone, code));
  }

  private static loginResult(response: ApiResponseData): LoginResult {
    const data = response.data as LoginResponseData | undefined;
    if (!data || !data.phone) {
      throw new Error('登录失败，请稍后重试');
    }
    return new LoginResult(data.phone, data.newUser,
      data.accessToken && data.accessToken.length > 0 ? data.accessToken : (data.token ?? ''));
  }

  private static async post(path: string, body: object): Promise<ApiResponseData> {
    const request = http.createHttp();
    try {
      const response = await request.request(`${AUTH_BASE_URL}${path}`, {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json'
        },
        extraData: JSON.stringify(body),
        connectTimeout: 20000,
        readTimeout: 20000
      });
      if (response.responseCode < 200 || response.responseCode >= 300) {
        throw new Error('网络异常，请稍后重试');
      }
      const parsed = JSON.parse(response.result as string) as ApiResponseData;
      if (parsed.code !== 0) {
        throw new Error(parsed.msg || '请求失败，请稍后重试');
      }
      return parsed;
    } catch (error) {
      const message = error instanceof Error ? error.message : '网络异常，请稍后重试';
      throw new Error(message);
    } finally {
      request.destroy();
    }
  }
}
