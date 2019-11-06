
# react-native-mbaichuan

## 升级到SDK为4.X

## NPM 安装完以后，必须下载本仓库中的百川SDK（iOS），由于百川SDK中用了SystemLink，NPM中的百川SDK包不完整，Android不受影响

## 开始

`$ npm install react-native-mbaichuan --save`

### 自动配置

`$ react-native link react-native-mbaichuan`

### 手动配置


#### iOS

1. 打开XCode工程中, 右键点击 `Libraries` ➜ `Add Files to [your project's name]`
2. 去 `node_modules` ➜ `react-native-mbaichuan` 目录添加 `RNReactNativeMbaichuan.xcodeproj`
3. 在工程 `Build Phases` ➜ `Link Binary With Libraries` 中添加 `libRNReactNativeMbaichuan.a`

#### Android

1. 打开 `android/app/src/main/java/[...]/MainActivity.java`
  - 在顶部添加 `import com.reactlibrary.RNReactNativeMbaichuanPackage;`
  - 在 `getPackages()` 方法后添加 `new RNReactNativeMbaichuanPackage()`
  
2. 打开 `android/settings.gradle` ，添加:
  	```
    	include ':react-native-mbaichuan'
    	project(':react-native-mbaichuan').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-mbaichuan/android')
  ```
  
3. 打开 `android/app/build.gradle` ，添加:
  	```
      compile project(':react-native-mbaichuan')
  ```
  以及添加
  
  ```
   ndk {
        abiFilters "armeabi-v7a", "x86"
   }
  ```


### 其他配置

#### iOS

1. 把 `/node_modules/react-native-mbaichuan/ios` 下的 `BaichuanSDK` 引入到项目中，并替换 `yw_1222.jpg`
2. `URL Schemes` 添加 `tbopen + 百川APPID` 
3. `LSApplicationQueriesSchemes` 添加 `tmall`、`tbopen`
4. **记得把examples/ios/BaichuanSDK/mtopsdk_configuration.plist 文件拖到项目中去，否则initSDK失败闪退**

#### Android

1. 复制百川安全图片 `yw_1222.jpg` 到 `android/app/src/main/res/drawable/yw_1222.jpg`


## 使用方法
```javascript
import * as mBaichuan from 'react-native-mbaichuan';

// TODO: What to do with the module?
```
