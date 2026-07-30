interface InputData {
    h: Record<string, any>;
    idt: Record<string, any>;
    a: {
        e: Record<string, Array<Record<string, any>>>;
    };
}
interface OutputData {
    h: Record<string, any>;
    idt: Record<string, any>;
    a: {
        e: Array<Record<string, any> & {
            sid: string;
        }>;
    };
}
export declare function transformData(i2: InputData): OutputData;
export {};
