// @keepTs
// @ts-nocheck
import dataPreferences from '@ohos.data.preferences';
export declare class PreferencesUtil {
    private static readonly secPrefsTag;
    private static prefs;
    private static getPreferences;
    static read(i11: string, j11?: dataPreferences.ValueType, k11?: Context | null): Promise<dataPreferences.ValueType | undefined | null>;
    static save(x10: string, y10: dataPreferences.ValueType | undefined | null, z10?: boolean, a11?: Context | null): Promise<number>;
    private static flush;
}
