// @keepTs
// @ts-nocheck
export interface IStxCirculateModule {
    writeData(sceneCode: string, data: string): boolean;
    readData(targetBundleName: string, sceneCode: string): string;
    deleteData(sceneCode: string): boolean;
}
