import RpcException from '../exception/RpcException';
export declare enum ResponseDataType {
    STRING = 0,
    OBJECT = 1,
    PROTO_BUFFER = 2
}
export declare class RpcUrlResponse<T = undefined> {
    constructor(l65?: RpcUrlResponse);
    success: boolean;
    rpcId: number;
    operationType: string;
    responseHeaders: Map<string, string>;
    responseBodyType: ResponseDataType;
    responseBodyBuffer: ArrayBuffer;
    responseBodyStr: string;
    responseBody?: T;
    extParams: Map<string, string>;
    rpcException: RpcException;
}
export interface RpcDebugCallback {
    getRequestEncoder?(): Function;
    getRequestDecoder?(): Function;
    getResponseEncoder?(): Function;
    getResponseDecoder?(): Function;
}
export interface RpcTransportCallback<T = undefined> extends RpcDebugCallback {
    onSuccess(rpcUrlResponse: RpcUrlResponse<T>): void;
    onError(rpcUrlResponse: RpcUrlResponse<T>): void;
}
export declare class DefaultRpcTransportCallbackImpl implements RpcTransportCallback {
    onSuccess(k65: RpcUrlResponse): void;
    onError(j65: RpcUrlResponse): void;
    private convertMap2Str;
}
