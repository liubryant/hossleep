// @keepTs
// @ts-nocheck
import dataPreferences from '@ohos.data.preferences';
export declare class PreferenceUtils {
    static readonly SHARE_PREFERENCE_NAME = "alipay_sdk_preference";
    private static instance;
    private preferences?;
    private constructor();
    static getInstance(): PreferenceUtils;
    get(y34: string, z34: dataPreferences.ValueType): dataPreferences.ValueType;
    put(w34: string, x34: dataPreferences.ValueType): void;
}
