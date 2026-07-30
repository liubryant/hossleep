export declare class JsonUtils {
    /**
     * 将 JSON 字符串 或者 Record 解析为指定类型的对象，并为其赋予类的方法
     * @param data
     * @param type
     * @returns
     */
    static parseJsonToInstance<z33>(a34: string | Record<string, any>, b34: {
        new (...args: any[]): z33;
    }): z33;
}
