export interface RegisterReflectionFuncModel {
    name: string;
    func: Function;
}
export const setAppContext: (ctx: Object) => boolean;
export const initBlueShieldManger: (authName?: string, extConfig?: Map<string, string>) => number;
export const ScpInvokeNative: (proto: number, ...args: Object[]) => Object;
export const nativeRegisterReflectionFunc: (funcList: RegisterReflectionFuncModel[]) => number;
export const registerRpcInterceptor: () => number;
export const notifyValidateResult: (validateResult: number) => number;
export const ScpGetConfig: (configKey: string, defaultValue: string) => string;
export const ScpMdapEvent: (bizType: string, eventId: string, param1: string, param2: string, param3: string, param4: string) => number;
export const ScpLoggerWrite: (tag: string, level: number, fmt: string, msg: string) => number;
export const ScpSendEventNative: (protocol: string, properties: string, external: Uint8Array, timeout: number) => string;
