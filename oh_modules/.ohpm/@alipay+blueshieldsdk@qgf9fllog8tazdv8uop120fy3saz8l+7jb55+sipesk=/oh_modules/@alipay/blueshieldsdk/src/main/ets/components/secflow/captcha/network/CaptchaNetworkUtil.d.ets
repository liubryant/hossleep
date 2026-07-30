// @keepTs
// @ts-nocheck
import { ValidateRequest } from './model/ValidateRequest';
import { ValidateResult } from './model/ValidateResult';
export declare class RdsNativeValidateService {
    static validate(u55: ValidateRequest): Promise<ValidateResult | null>;
}
