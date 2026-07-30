// @keepTs
// @ts-nocheck
import { BizContext } from '../context/BizContext';
import { JSONObject } from '../utils/Utils';
import { NetworkTask } from './NetworkTask';
import HashMap from "@ohos.util.HashMap";
export declare class DynamicConfigPacket extends NetworkTask {
    getApiVersion(): string;
    buildAction(): JSONObject;
    isWifiMocked(): boolean;
    getName(): string;
    buildEnvelopInner(m16: BizContext, n16: Map<string, string>, o16: HashMap<string, string>): string;
    private generateRequestParams;
}
