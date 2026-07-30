// @keepTs
// @ts-nocheck
import { IStxCirculateModule } from './IStxCirculateModule';
export declare class StxCirculateModule implements IStxCirculateModule {
    writeData(x63: string, y63: string): boolean;
    readData(u63: string, v63: string): string;
    deleteData(s63: string): boolean;
}
