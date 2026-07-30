import { ToString } from './ToString';
export declare class CommonResult extends ToString {
    success?: boolean;
    resultCode?: string;
    resultDesc?: string;
    retry?: boolean;
}
