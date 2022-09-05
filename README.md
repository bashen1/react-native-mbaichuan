
# react-native-mbaichuan

[![npm version](https://badge.fury.io/js/react-native-mbaichuan.svg)](https://badge.fury.io/js/react-native-mbaichuan)

iOS Version: 4.1.0.0
Android Version: 4.1.0.1

## 开始

`$ npm install react-native-mbaichuan --save`

### iOS集成

1. 老版本升级上来的可以删除Podfile中的淘宝百川源，官方已经不再维护

```Podfile
source 'http://repo.baichuan-ios.taobao.com/baichuanSDK/AliBCSpecs.git'
```

2. 打开`ios/Podfile`文件，添加以下自建百川仓库，可以自己fork

```Podfile
require_relative '../node_modules/@react-native-community/cli-platform-ios/native_modules'
·······
target 'App' do
  # tag为https://github.com/bashen1/AlibcTradeSDK-Specs.git仓库实际tag
  pod 'AlibcTradeSDK-Specs', :git=> 'https://github.com/bashen1/AlibcTradeSDK-Specs.git', :tag=> '1.2.0'

  pod 'FBLazyVector', :path => "../node_modules/react-native/Libraries/FBLazyVector"
·······
target
```

### 其他配置

【注意】：所有平台的安全图片需要都改为v6的图片

#### iOS项目配置

1. 把 `yw_1222.jpg` 重命名为 `yw_1222_baichuan.jpg` 拖入到项目中
2. `URL Schemes` 添加 `tbopen + 百川APPID`
3. `LSApplicationQueriesSchemes` 添加 `tmall`、`tbopen`

#### Android项目配置

1. 重命名为 `yw_1222_baichuan.jpg`，复制百川安全图片 `yw_1222_baichuan.jpg` 到 `android/app/src/main/res/drawable/yw_1222_baichuan.jpg`

## 使用方法

详见examples目录

### 注意

新的商品ID需要传入adZoneId，否则Android跳转手淘提示「服务竟然出错了」，iOS也只能跳转至手淘首页

## 其他

模块升级时请注意上方iOS的集成方式，如果SDK升级了，需要改tag
`pod 'AlibcTradeSDK-Specs', :git=> 'https://github.com/bashen1/AlibcTradeSDK-Specs.git', :tag=> '1.2.0'`

开源不易，且用且珍惜
