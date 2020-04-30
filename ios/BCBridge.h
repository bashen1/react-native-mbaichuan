//
//  BCBridge.h
//  RNReactNativeMbaichuan
//
//  Created by IORI on 2019/2/14.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BCBridge : NSObject
+ (instancetype)sharedInstance;
- (void)initSDK: (NSDictionary *)param resolve: (RCTPromiseResolveBlock)resolve;
- (void)showLogin: (RCTPromiseResolveBlock)resolve;
- (void)getUserInfo: (RCTPromiseResolveBlock)resolve;
- (void)logout: (RCTPromiseResolveBlock)resolve;
- (void)show: (NSDictionary *)param resolve: (RCTPromiseResolveBlock)resolve;
- (void)showInWebView: (WKWebView *)webView param:(NSDictionary *)param;
@end

NS_ASSUME_NONNULL_END
