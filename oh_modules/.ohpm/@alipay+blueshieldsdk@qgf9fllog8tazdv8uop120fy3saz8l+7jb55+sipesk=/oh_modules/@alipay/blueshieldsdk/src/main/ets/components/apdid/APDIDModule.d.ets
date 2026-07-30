// @keepTs
// @ts-nocheck
import { IAPDIDModule, TokenResult } from './IAPDIDModule';
import { AsyncCallback } from '@ohos.base';
export declare class APDIDModule implements IAPDIDModule {
    initToken(z: Map<string, string>, a1: AsyncCallback<TokenResult, void>): void;
    initToken(z: Map<string, string>): Promise<TokenResult>;
    innerInitToken(n: Map<string, string>, o?: AsyncCallback<TokenResult, void>): Promise<void | TokenResult>;
    getTokenResult(): TokenResult;
    getApdidToken(): string;
    initOpenToken(g: string, h: string, i: AsyncCallback<string, void>): void;
    initOpenToken(g: string, h: string): Promise<string>;
    registerDeviceIdChanged(a: AsyncCallback<number, void>): void;
}
