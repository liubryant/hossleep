//
// Created on 2024/1/25.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#ifndef APSECDEMO_BLUESHIELDMANAGER_H
#define APSECDEMO_BLUESHIELDMANAGER_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef enum _BlueShieldModuleType {
    // Trusted Terminal
    BS_STATIC_STORE_MODULE = 0,
    BS_STATIC_CRYPTO_MODULE = 1,
    BS_ENVELOPE_CRYPTO_MODULE = 2,
    BS_DYNAMIC_CRYPTO_MODULE = 3,
    BS_SAFE_SIGNATURE_MODULE = 4,
    BS_SAFE_OTP_MODULE = 5,
    BS_TRUSTED_SIGNATURE_MODULE = 6,
    BS_TRUSTED_ENGINE_MODULE = 7,
    BS_DEVICE_FEATURE_MODULE = 8,
    BS_SAFE_TOKEN_MODULE = 9,

    // Aliapy Device ID
    BS_APDID_MODULE = 16,

    // Security Flow
    BS_RDS_MODULE = 32,
    BS_DEVICE_COLOR_MODULE = 33,
    BS_CAPTCHA_MODULE = 34,

    // Edge Risk Control
    BS_EDGE_RISK_MODULE = 48,

    //dtx module
    BS_TEE_TOKEN_MODULE = 64,

    //dtx tee interface
    BS_TEE_MODULE = 1000,

    // native 测试模块
    BS_NATIVE_TEST_MODULE = 1100,
} BlueShieldModuleType;

typedef struct _BlueShieldManager {
    /* 蓝盾初始化接口，Android/iOS/鸿蒙不需要调用
     * @param: resPath 安全图片所在文件夹路径
     * @param: workPath 程度执行时缓存文件路径
     * @param: execPath 可执行二进制程序全路径,不传或者传空会默认读取/proc/self/exe
     * @param: authCode 图片名，如果不定制可以传空串，默认为nearx_bs.jpg
     * @param: extParams 扩展参数，可以暂时传NULL
     * @return 初始化是否成功，0未成功，非0为错误码
     */
    int   (*Init)(const char* resPath, const char* workPath, const char* execPath, const char* authCode, void *extParams);
    
    /* 蓝盾功能模块获取接口
     * @param moduleType 对应功能模块的ID
     * return 返回对应功能模块的单例
     */
    void* (*GetModule)(BlueShieldModuleType moduleType);
} BlueShieldManager;

// 获取蓝盾单例
__attribute__((visibility("default"))) BlueShieldManager *BlueShieldGetManager();

#ifdef __cplusplus
}
#endif

#endif //APSECDEMO_BLUESHIELDMANAGER_H
