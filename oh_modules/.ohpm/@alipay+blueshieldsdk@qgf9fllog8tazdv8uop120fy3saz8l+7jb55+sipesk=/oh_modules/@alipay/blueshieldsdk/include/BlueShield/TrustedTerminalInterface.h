//
// Created on 2024/5/6.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#ifndef APSECDEMO_BLUESHIELDTRUSTEDTERMINALINTERFACE_H
#define APSECDEMO_BLUESHIELDTRUSTEDTERMINALINTERFACE_H

#ifdef TRUSTEDTERMINAL_USE_VISIBILITY_DEFAULT
#define TRUSTEDTERMINAL_VISIBILITY_DEFAULT __attribute__((visibility("default")))
#else
#define TRUSTEDTERMINAL_VISIBILITY_DEFAULT 
#endif // #ifdef TRUSTEDTERMINAL_USE_VISIBILITY_DEFAULT

#include <stddef.h>
#include <stdint.h>

typedef union _BSValue {
    uint8_t     uint8_value;
    int8_t      int8_value;
    uint16_t    uint16_value;
    int16_t     int16_value;
    uint32_t    uint32_value;
    int32_t     int32_value;
    uint64_t    uint64_value;
    int64_t     int64_value;
    float       float_value;
    double      double_value;
    const char* string_value;
    void*       pointer_value;
} BSValue;

typedef struct _BSKeyValue{
    const char*     key;
    BSValue   val;
} BSKeyValue;

// Module 0, 静态密钥存储
typedef struct _BlueShieldStaticStoreModule {
    int (*GetCustomData)(const char *appKey, const char *authName, const char** outData);
} BlueShieldStaticStoreModule;

// Module 1, 静态加解密
typedef enum _BlueShieldStaticCryptoMode {
    BS_STATIC_CRYPTO_MODE_SG_AES_128 = 16,
    BS_STATIC_CRYPTO_MODE_BS_SM4_GCM = 32,
    BS_STATIC_CRYPTO_MODE_BS_AES_128 = 33,
} BlueShieldStaticCryptoMode;

typedef struct _BlueShieldStaticCryptoModule {
    int (*Encrypt)(BlueShieldStaticCryptoMode mode, const char *appKey, const char *authCode, uint8_t *inData,
                   size_t inLen, uint8_t **outData, size_t *outLen);
    int (*Decrypt)(BlueShieldStaticCryptoMode mode, const char *appKey, const char *authCode, uint8_t *inData,
                   size_t inLen, uint8_t **outData, size_t *outLen);
    int (*EncryptBase64)(BlueShieldStaticCryptoMode mode, const char *appKey, const char *authCode, uint8_t *inData,
                         size_t inLen, uint8_t **outData, size_t *outLen);
    int (*DecryptBase64)(BlueShieldStaticCryptoMode mode, const char *appKey, const char *authCode, uint8_t *inData,
                         size_t inLen, uint8_t **outData, size_t *outLen);
    int (*EncryptStringBase64)(BlueShieldStaticCryptoMode mode, const char *appKey, const char *authCode,
                               const char *inData, const char **outData);
    int (*DecryptStringBase64)(BlueShieldStaticCryptoMode mode, const char *appKey, const char *authCode,
                               const char *inData, const char **outData);
} BlueShieldStaticCryptoModule;

// Module 3, 动态加解密
typedef struct _BlueShieldDynamicCryptoModule {
    int (*Encrypt)(uint8_t *inData, size_t inLen, uint8_t **outData, size_t *outLen);
    int (*Decrypt)(uint8_t *inData, size_t inLen, uint8_t **outData, size_t *outLen);
    int (*EncryptStringBase64)(const char *inData, const char **outData);
    int (*DecryptStringBase64)(const char *inData, const char **outData);
} BlueShieldDynamicCryptoModule;

// Module 4, 安全签名
typedef enum _BlueShieldSafeSignatureAlgo {
    // 32 - 63 HMAC摘要
    BS_SAFE_SIGNATURE_ALGO_HMAC_SM3 = 32,
    BS_SAFE_SIGNATURE_ALGO_HMAC_MD5 = 33,
    BS_SAFE_SIGNATURE_ALGO_HMAC_SHA1 = 34,
    BS_SAFE_SIGNATURE_ALGO_HMAC_SHA256 = 35,

    // 64 - 95 正常摘要
    BS_SAFE_SIGNATURE_ALGO_SM3 = 64,
    BS_SAFE_SIGNATURE_ALGO_MD5 = 65,
    BS_SAFE_SIGNATURE_ALGO_SHA1 = 66,
    BS_SAFE_SIGNATURE_ALGO_SHA256 = 67,

    // 96 - 127 兼容摘要
    BS_SAFE_SIGNATURE_ALGO_SG_SM3 = 96,
    BS_SAFE_SIGNATURE_ALGO_SG_MD5 = 97,
    BS_SAFE_SIGNATURE_ALGO_SG_SHA1 = 98,
    BS_SAFE_SIGNATURE_ALGO_SG_SHA256 = 99,
    BS_SAFE_SIGNATURE_ALGO_SG_XIAMI = 100,
} BlueShieldSafeSignatureAlgo;

typedef struct _BlueShieldSafeSignatureModule {
    int (*sign)(BlueShieldSafeSignatureAlgo signAlgo, const char *appKey, uint8_t *msgData, size_t msgLen,
                uint8_t **signBytes, size_t *signLen);
    int (*signString)(BlueShieldSafeSignatureAlgo signAlgo, const char *appKey, const char *msgStr,
                      const char **signStr);
    int (*verify)(BlueShieldSafeSignatureAlgo signAlgo, const char *appKey, uint8_t *msgData, size_t msgLen,
                  uint8_t *signData, size_t signLen);
    int (*verifyString)(BlueShieldSafeSignatureAlgo signAlgo, const char *appKey, const char *msgStr,
                        const char *signStr);
} BlueShieldSafeSignatureModule;

// Module 7, 可信签名
#define  BS_TRUSTED_SIGN_PARAM_KEY_SIGN_API         "api"
#define  BS_TRUSTED_SIGN_PARAM_KEY_SIGN_ENV         "env"
#define  BS_TRUSTED_SIGN_PARAM_KEY_SIGN_TYPE        "signType"
#define  BS_TRUSTED_SIGN_PARAM_KEY_SIGN_APPKEY      "appKey"
#define  BS_TRUSTED_SIGN_PARAM_KEY_SIGN_AUTHCODE    "authCode"
#define  BS_TRUSTED_SIGN_PARAM_KEY_SIGN_DATA        "signData"
#define  BS_TRUSTED_SIGN_PARAM_KEY_SIGN_SWITCH      "signSwi"

typedef enum _BlueShieldTrustedSignType {
    BS_SECURITY_GUARD_MD5 = 0,
    BS_SECURITY_GUARD_HMAC_SHA1 = 1,
    // BS_SECURITY_GUARD_ATLAS       = 2,
    // BS_SECURITY_GUARD_AVMP        = 3,
    BS_TRUSTED_SIGN_NORMAL = 4,
} BlueShieldTrustedSignType;

typedef enum _BlueShieldTrustedSignEnv {
    BS_TRUSTED_SIGN_ENV_ONLINE = 0,
    BS_TRUSTED_SIGN_ENV_DEV = 1,
    BS_TRUSTED_SIGN_ENV_PRE = 2,
} BlueShieldTrustedSignEnv;

typedef struct _BSTrustedSignResult {
    const char *sign;
    const char *color;
    const char *token;
    const char *reserved0;
    const char *reserved1;
} BSTrustedSignResult;

typedef struct _BlueShieldTrustedSignatureModule {
    int (*GetSign)(BSKeyValue* signParams, size_t paramCount, BSTrustedSignResult* signResult);
    int (*ReleaseSign)(BSTrustedSignResult* signResult);
} BlueShieldTrustedSignatureModule;

// Module 8, 动态密钥
typedef struct _BlueShieldSafeTokenModule {
    int (*GetEncToken)(const char* value, int flag, uint8_t** out, size_t *outLen);
    int (*GetPaycodeWithEncToken)(uint8_t* encToken, size_t encTokenLen, int64_t srvTime, int flag, const char** paycode);
    int (*EncryptWithEncToken)(uint8_t* encToken, size_t encTokenLen, uint8_t* plainData, size_t plainDataLen, int flag, uint8_t** out, size_t* outLen);
    int (*DecryptWithEncToken)(uint8_t* encToken, size_t encTokenLen, uint8_t* cipherData, size_t cipherDataLen, int flag, uint8_t** out, size_t* outLen);
    int (*SignWithEncToken)(uint8_t* encToken, size_t encTokenLen, uint8_t* msgData, size_t msgDataLen, int flag, const char** signResult);
} BlueShieldSafeTokenModule;

// Module 9, teeToken
typedef struct _BlueShieldTeeTokenModule {
    int (*initTeeEncToken)(const char* srvFactor, const char* addition, int flag, uint8_t** out, size_t *outLen);
    int (*encryptByTeeEncToken)(uint8_t* encBizID, size_t encBizIDLen, uint8_t* plainData, size_t plainDataLen, const char* addition, int flag, uint8_t** out, size_t* outLen);
    int (*decryptByTeeEncToken)(uint8_t* encBizID, size_t encBizIDLen, uint8_t* cipherData, size_t cipherDataLen, const char* addition, int flag, uint8_t** out, size_t* outLen);
    int (*signByTeeEncToken)(uint8_t* encBizID, size_t encBizIDLen, uint8_t* msgData, size_t msgDataLen, const char* addition, int flag, const char** signResult);
    int (*deleteTeeToken)(uint8_t* encBizID, size_t encBizIDLen, const char* addition, int flag);
} BlueShieldTeeTokenModule;

#endif // APSECDEMO_BLUESHIELDTRUSTEDTERMINALINTERFACE_H
