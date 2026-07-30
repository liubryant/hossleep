# 友盟sdk common包

## 系统API要求
  鸿蒙NEXT API12 及以上

## 配置项说明

| 配置项 | 类型 | 说明 |
|--------|------|------|
| disableScreen | boolean | 禁用屏幕信息 |
| disablePlmn | boolean | 禁用运营商信息 |
| disableOsVersion | boolean | 禁用OS版本信息 |
| disableDeviceModel | boolean | 禁用设备型号信息 |
| disableMarketName | boolean | 禁用设备市场名称信息 |
| disableDeviceType | boolean | 禁用设备类型信息 |
| disableBrand | boolean | 禁用设备品牌信息 |
| disableProductSeries | boolean | 禁用设备产品系列信息 |
| disableOAID | boolean | 禁用OAID信息 |

## 快速开始
- 安装sdk
在项目根目录执行如下命令，安装友盟sdk的common包，不能单独使用,需要配合  @umeng/analytics 一起使用
```shell
ohpm install @umeng/common --registry=https://ohpm.openharmony.cn/ohpm
```