// @keepTs
// @ts-nocheck
import { Context } from '@kit.AbilityKit';
declare class GlobalContext {
    private context;
    getContext(): Context | null;
    setContext(p8: Context): void;
}
declare const _default: GlobalContext;
export default _default;
