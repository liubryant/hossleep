# Changelog
## [v1.1.12] 2026-05-08
增加可选合规控制字段
disableMarketName?: boolean; // 禁用设备市场名称信息
disableDeviceType?: boolean; // 禁用设备类型信息
disableBrand?: boolean; // 禁用设备品牌信息
disableProductSeries?: boolean; // 禁用设备产品系列信息
## [v1.1.10] 2026-02-06
增加可选合规控制字段
disableScreen?: boolean; // 禁用屏幕信息
disablePlmn?: boolean; // 禁用运营商信息
disableOsVersion?: boolean; // 禁用OS版本信息
disableDeviceModel?: boolean; // 禁用设备型号信息
disableOAID?: boolean; // 禁用OAID信息
## [v1.1.8] 2025-08-20
## build
添加友盟企业签名信息，用于评优认证
## [v1.1.7] 2025-08-13
## build
基于DevEco Studio 5.1.1 Release重新build,添加签名，开启数据库异常时自动恢复
## [v1.1.3] 2024-12-17
## build
基于DevEco Studio 5.0.1 Release重新build,解决新版本IDE依赖错误问题
## [v1.1.2] 2024-11-28
## feat
增加odid的采集
## [v1.1.1] 2024-10-30
## build
升级到api12
## [v1.0.31] 2024-08-15
## feat
性能优化
## [v1.0.30] 2024-08-7
## feat
支持u-apm业务
## [v1.0.28] 2024-07-8
## fix
优化启动统计
## [v1.0.24] 2024-06-18
## feat
支持u-push业务
## [v1.0.22] 2024-05-27
## fix
获取`OAID`前先校验是否有授权
## [v1.0.21] 2024-04-26
## build
基于4.1（API11）Release开发套件重新编译发布
## [v1.0.20] 2024-03-14
## 新增
基础日志采集模块