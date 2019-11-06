
# react-native-mbaichuan

[![npm version](https://badge.fury.io/js/react-native-mbaichuan.svg)](https://badge.fury.io/js/react-native-mbaichuan)

## 注意点

|         版本        |   版本  |   文档  |
| :-----------------: | :---: | :---: |
| react-native < 0.60 | 3.0.2 | [点击](./README_0.5X.md) |


## 开始

`$ npm install react-native-mbaichuan --save`

### iOS

打开`ios/Podfile`文件，添加以下（百川仓库）
```
require_relative '../node_modules/@react-native-community/cli-platform-ios/native_modules'
·······
source 'https://github.com/CocoaPods/Specs.git'
source 'http://repo.baichuan-ios.taobao.com/baichuanSDK/AliBCSpecs.git'

·······
target
```

### Android
打开`android/bulid.gradle`，添加以下仓库
```
······
allprojects {
    repositories {
        ·····
        maven {
            url "http://repo.baichuan-android.taobao.com/content/groups/BaichuanRepositories/"
        }
    }
}
······
```

### 其他配置


#### iOS

1. 把 `yw_1222.jpg` 拖入到项目中
2. `URL Schemes` 添加 `tbopen + 百川APPID` 
3. `LSApplicationQueriesSchemes` 添加 `tmall`、`tbopen`

#### Android

1. 复制百川安全图片 `yw_1222.jpg` 到 `android/app/src/main/res/drawable/yw_1222.jpg`


## 使用方法
详见examples目录

