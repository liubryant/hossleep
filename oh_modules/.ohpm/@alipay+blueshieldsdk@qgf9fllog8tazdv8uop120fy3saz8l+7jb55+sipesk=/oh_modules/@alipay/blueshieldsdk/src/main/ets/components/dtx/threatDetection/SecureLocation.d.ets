// @keepTs
// @ts-nocheck
declare class originalLocationResult {
    latitude: string;
    longitude: string;
    altitude: string;
    accuracy: string;
    timeStamp: string;
}
export declare class SecureLocation {
    private static TAG;
    static tokenResult: originalLocationResult;
    static createAttestKey(): Promise<void>;
    static initializeAttestContext(): Promise<string>;
    static getCurrentSecureLocation(k25: string, l25: number, m25?: boolean): Promise<string>;
    static finalizeAttestContext(): Promise<void>;
    static destroyAttestKey(): Promise<void>;
}
export {};
