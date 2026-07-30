import { ToString } from './ToString';
export declare class ValidateRequest extends ToString {
    serviceName?: string;
    bizNo?: string;
    application?: string;
    uri?: string;
    protocol?: string;
    method?: string;
    disposeAccessPoint?: string;
    disposeApplication?: string;
    disposeName?: string;
    encryptVersion?: string;
    encryptData?: string;
    product?: string;
    extra?: Record<string, Object>;
}
