//
//  BCBridge.m
//  RNReactNativeMbaichuan
//
//  Created by IORI on 2019/2/14.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "BCBridge.h"
#import "BCWebView.h"
#import <AlibabaAuthSDK/ALBBSDK.h>
#import <AlibcTradeBiz/AlibcTradeBiz.h>
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <React/RCTLog.h>

@implementation BCBridge {
    AlibcTradeTaokeParams *taokeParams;
    AlibcTradeShowParams *showParams;
}

+ (instancetype) sharedInstance {
    static BCBridge *instance = nil;
    if (!instance) {
        instance = [[BCBridge alloc] init];
    }
    return instance;
}
- (void)initSDK: (RCTPromiseResolveBlock)resolve
{
    // 百川平台基础SDK初始化，加载并初始化各个业务能力插件
    [[AlibcTradeSDK sharedInstance] asyncInitWithSuccess:^{
        NSDictionary *ret = @{@"code": @"0", @"message":@"success"};
        resolve(ret);
    } failure:^(NSError *error) {
        NSDictionary *ret = @{@"code": @(error.code), @"message":error.description};
        resolve(ret);
    }];
    
    // 初始化AlibabaAuthSDK
    [[ALBBSDK sharedInstance] ALBBSDKInit];
    
    // 开发阶段打开日志开关，方便排查错误信息
    //默认调试模式打开日志,release关闭,可以不调用下面的函数
    [[AlibcTradeSDK sharedInstance] setDebugLogOpen:YES];
    
    //设置全局的app标识，在电商模块里等同于isv_code
    [[AlibcTradeSDK sharedInstance] setISVCode:@"app"];
}

- (void)showLogin: (RCTPromiseResolveBlock)resolve
{
     if(![[ALBBSession sharedInstance] isLogin]){
    [[ALBBSDK sharedInstance] auth:[UIApplication sharedApplication].delegate.window.rootViewController
                   successCallback:^(ALBBSession *session) {
                       //授权成功
                       NSString *isLg;
                       if([session isLogin]){
                           isLg=@"true";
                       }else{
                           isLg=@"false";
                       }
                       NSDictionary *ret = @{
                                             @"userNick" :[session getUser].nick,
                                             @"avatarUrl":[session getUser].avatarUrl,
                                             @"openId":[session getUser].openId,
                                             @"isLogin":isLg
                                             };
                       resolve(ret);
                   }
                   failureCallback:^(ALBBSession *session, NSError *error) {
                       NSDictionary *ret = @{@"code":[NSString stringWithFormat:@"%ld", (long)[error code]],@"message":[[error userInfo] objectForKey:NSLocalizedDescriptionKey]};
                       resolve(ret);
                   }
     ];
     }else{
         //如果登录的输出用户信息
         ALBBSession *session=[ALBBSession sharedInstance];
         NSString *isLg;
         if([session isLogin]){
             isLg=@"true";
         }else{
             isLg=@"false";
         }
         NSDictionary *ret = @{
                               @"userNick" :[session getUser].nick,
                               @"avatarUrl":[session getUser].avatarUrl,
                               @"openId":[session getUser].openId,
                               @"isLogin":isLg};
         resolve(ret);
     }
}

- (void)getUserInfo: (RCTPromiseResolveBlock)resolve
{
    if(![[ALBBSession sharedInstance] isLogin]){
        NSDictionary *ret = @{@"code":@"90000",@"message":@"Not logged in"};
        resolve(ret);
    }else{
        ALBBSession *session=[ALBBSession sharedInstance];
        NSString *isLg;
        if([session isLogin]){
            isLg=@"true";
        }else{
            isLg=@"false";
        }
        NSDictionary *ret = @{
                              @"userNick" :[session getUser].nick,
                              @"avatarUrl":[session getUser].avatarUrl,
                              @"openId":[session getUser].openId,
                              @"isLogin":isLg};
        resolve(ret);
    }
}

- (void)logout: (RCTPromiseResolveBlock)resolve
{
    if([[ALBBSession sharedInstance] isLogin]){
        [[ALBBSDK sharedInstance] logout];
        NSDictionary *ret = @{@"code":@"0",@"message":@"success"};
        resolve(ret);
    }else{
        NSDictionary *ret = @{@"code":@"90000",@"message":@"Not logged in"};
        resolve(ret);
    }
}

- (void)show: (NSDictionary *)param resolve: (RCTPromiseResolveBlock)resolve
{
    NSString *type = param[@"type"];
    NSDictionary *payload = (NSDictionary *)param[@"payload"];
    
    id<AlibcTradePage> page;
    if ([type isEqualToString:@"detail"]) {
        page = [AlibcTradePageFactory itemDetailPage:(NSString *)payload[@"itemid"]];
        [self _show:page param:param bizCode:@"detail" resolve:resolve];
    } else if ([type isEqualToString:@"url"]) {
        NSString* url = payload[@"url"];
        [self _showUrl:url param:param resolve:resolve];
    } else if ([type isEqualToString:@"shop"]) {
        page = [AlibcTradePageFactory shopPage:(NSString *)payload[@"shopid"]];
        [self _show:page param:param bizCode:@"shop" resolve:resolve];
    } else if ([type isEqualToString:@"orders"]) {
        page = [AlibcTradePageFactory myOrdersPage:[payload[@"orderStatus"] integerValue] isAllOrder:[payload[@"allOrder"] boolValue]];
        [self _show:page param:param bizCode:@"orders" resolve:resolve];
    } else if ([type isEqualToString:@"addCard"]) {
        page = [AlibcTradePageFactory addCartPage:(NSString *)payload[@"itemid"]];
        [self _show:page param:param bizCode:@"addCart" resolve:resolve];
    } else if ([type isEqualToString:@"mycard"]) {
        page = [AlibcTradePageFactory myCartsPage];
        [self _show:page param:param bizCode:@"cart" resolve:resolve];
    } else {
        RCTLog(@"not implement");
        return;
    }
}

- (void)_show: (id<AlibcTradePage>)page param:(NSDictionary *)param bizCode: (NSString *)bizCode resolve: (RCTPromiseResolveBlock)resolve
{
    //处理参数
    NSDictionary* result = [self dealParam:param];
    AlibcTradeTaokeParams *taokeParams = [[AlibcTradeTaokeParams alloc] init];
    taokeParams = result[@"taokeParams"];
    AlibcTradeShowParams* showParams = [[AlibcTradeShowParams alloc] init];
    showParams = result[@"showParams"];
    NSDictionary *trackParam = result[@"trackParam"];
    
    [[AlibcTradeSDK sharedInstance].tradeService openByBizCode:bizCode page:page webView:nil parentController:[UIApplication sharedApplication].delegate.window.rootViewController showParams:showParams taoKeParams:taokeParams trackParam:trackParam tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
        //成功回调
        NSArray *orderId=@[];
        if(result.result == AlibcTradeResultTypePaySuccess){
            orderId=result.payResult.paySuccessOrders;
        }
        NSDictionary *ret = @{@"code" : @"0",@"message":@"success",@"orderid":orderId};
        resolve(ret);
    } tradeProcessFailedCallback:^(NSError * _Nullable error) {
        //失败回调
        NSDictionary *ret = @{@"code":[NSString stringWithFormat:@"%ld", (long)[error code]],@"message":[[error userInfo] objectForKey:NSLocalizedDescriptionKey]};
        resolve(ret);
    }];
}

- (void)_showUrl: (NSString *)url param:(NSDictionary *)param resolve: (RCTPromiseResolveBlock)resolve
{
    //处理参数
    NSDictionary* result = [self dealParam:param];
    AlibcTradeTaokeParams *taokeParams = [[AlibcTradeTaokeParams alloc] init];
    taokeParams = result[@"taokeParams"];
    AlibcTradeShowParams* showParams = [[AlibcTradeShowParams alloc] init];
    showParams = result[@"showParams"];
    NSDictionary *trackParam = result[@"trackParam"];
    
    [[AlibcTradeSDK sharedInstance].tradeService openByUrl:url identity:@"trade" webView:nil parentController:[UIApplication sharedApplication].delegate.window.rootViewController showParams:showParams taoKeParams:taokeParams trackParam:trackParam tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
        //成功回调
        NSArray *orderId=@[];
        if(result.result == AlibcTradeResultTypePaySuccess){
            orderId=result.payResult.paySuccessOrders;
        }
        NSDictionary *ret = @{@"code" : @"0",@"message":@"success",@"orderid":orderId};
        resolve(ret);
    } tradeProcessFailedCallback:^(NSError * _Nullable error) {
        //失败回调
        NSDictionary *ret = @{@"code":[NSString stringWithFormat:@"%ld", (long)[error code]],@"message":[[error userInfo] objectForKey:NSLocalizedDescriptionKey]};
        resolve(ret);
    }];
}

- (void)showInWebView: (BCWebView *)webView param:(NSDictionary *)param
{
    NSString *type = param[@"type"];
    NSDictionary *payload = (NSDictionary *)param[@"payload"];
    
    id<AlibcTradePage> page;
    if ([type isEqualToString:@"detail"]) {
        page = [AlibcTradePageFactory itemDetailPage:(NSString *)payload[@"itemid"]];
        [self _showInWebView:webView page:page param:param bizCode:@"detail"];
    } else if ([type isEqualToString:@"url"]) {
        NSString* url = payload[@"url"];
        [self _showUrlInWebView:webView url:url param:param];
    } else if ([type isEqualToString:@"shop"]) {
        page = [AlibcTradePageFactory shopPage:(NSString *)payload[@"shopid"]];
        [self _showInWebView:webView page:page param:param bizCode:@"shop"];
    } else if ([type isEqualToString:@"orders"]) {
        page = [AlibcTradePageFactory myOrdersPage:[payload[@"orderStatus"] integerValue] isAllOrder:[payload[@"allOrder"] boolValue]];
        [self _showInWebView:webView page:page param:param bizCode:@"orders"];
    } else if ([type isEqualToString:@"addCard"]) {
        page = [AlibcTradePageFactory addCartPage:(NSString *)payload[@"itemid"]];
        [self _showInWebView:webView page:page param:param bizCode:@"addCart"];
    } else if ([type isEqualToString:@"mycard"]) {
        page = [AlibcTradePageFactory myCartsPage];
        [self _showInWebView:webView page:page param:param bizCode:@"cart"];
    } else {
        RCTLog(@"not implement");
        return;
    }
}

- (void)_showInWebView: (UIWebView *)webView page:(id<AlibcTradePage>)page param:(NSDictionary *)param bizCode: (NSString *)bizCode
{
    //处理参数
    NSDictionary* result = [self dealParam:param];
    AlibcTradeTaokeParams *taokeParams = [[AlibcTradeTaokeParams alloc] init];
    taokeParams = result[@"taokeParams"];
    AlibcTradeShowParams* showParams = [[AlibcTradeShowParams alloc] init];
    showParams = result[@"showParams"];
    NSDictionary *trackParam = result[@"trackParam"];
    
    [[AlibcTradeSDK sharedInstance].tradeService openByBizCode:bizCode page:page webView: webView parentController:[UIApplication sharedApplication].delegate.window.rootViewController showParams:showParams taoKeParams:taokeParams trackParam:trackParam tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
        //成功回调
        NSArray *orderId=@[];
        if(result.result == AlibcTradeResultTypePaySuccess){
            orderId=result.payResult.paySuccessOrders;
        }
        NSDictionary *ret = @{@"code" : @"0",@"message":@"success",@"orderid":orderId};
        ((BCWebView *)webView).onTradeResult(ret);
    } tradeProcessFailedCallback:^(NSError * _Nullable error) {
        //失败回调
        NSDictionary *ret = @{@"code":[NSString stringWithFormat:@"%ld", (long)[error code]],@"message":[[error userInfo] objectForKey:NSLocalizedDescriptionKey]};
        ((BCWebView *)webView).onTradeResult(ret);
    }];
}

- (void)_showUrlInWebView: (UIWebView *)webView url:(NSString *)url param:(NSDictionary *)param
{
    //处理参数
    NSDictionary* result = [self dealParam:param];
    AlibcTradeTaokeParams *taokeParams = [[AlibcTradeTaokeParams alloc] init];
    taokeParams = result[@"taokeParams"];
    AlibcTradeShowParams* showParams = [[AlibcTradeShowParams alloc] init];
    showParams = result[@"showParams"];
    NSDictionary *trackParam = result[@"trackParam"];
    
    [[AlibcTradeSDK sharedInstance].tradeService openByUrl:url identity:@"trade" webView:webView parentController:[UIApplication sharedApplication].delegate.window.rootViewController showParams:showParams taoKeParams:taokeParams trackParam:trackParam tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
        //成功回调
        NSArray *orderId=@[];
        if(result.result == AlibcTradeResultTypePaySuccess){
            orderId=result.payResult.paySuccessOrders;
        }
        NSDictionary *ret = @{@"code" : @"0",@"message":@"success",@"orderid":orderId};
        ((BCWebView *)webView).onTradeResult(ret);
    } tradeProcessFailedCallback:^(NSError * _Nullable error) {
        //失败回调
        NSDictionary *ret = @{@"code":[NSString stringWithFormat:@"%ld", (long)[error code]],@"message":[[error userInfo] objectForKey:NSLocalizedDescriptionKey]};
        ((BCWebView *)webView).onTradeResult(ret);
    }];
}

/****---------------以下是公用方法----------------**/
//公用参数处理
- (NSDictionary *)dealParam:(NSDictionary *)param
{
    NSDictionary *payload = (NSDictionary *)param[@"payload"];
    
    NSString *mmPid = @"mm_114988374_16864682_45439350353";
    NSString *isvcode=@"app";
    NSString *adzoneid=@"45439350353";
    NSString *tkkey=@"23488271";
    
    AlibcTradeTaokeParams *taokeParam = [[AlibcTradeTaokeParams alloc] init];
    if ((NSString *)payload[@"mmpid"]!=nil) {
        mmPid=(NSString *)payload[@"mmpid"];
    }
    
    if ((NSString *)payload[@"adzoneid"]!=nil) {
        adzoneid=(NSString *)payload[@"adzoneid"];
    }
    
    if ((NSString *)payload[@"tkkey"]!=nil) {
        tkkey=(NSString *)payload[@"tkkey"];
    }
    
    //[taokeParam setPid:mmPid];
    //[taokeParam setAdzoneId:adzoneid];
    taokeParam.pid = mmPid;
    //taokeParam.adzoneId = adzoneid;
    //taokeParam.extParams=@{@"taokeAppkey":tkkey};
    
    AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc] init];
    if ((NSString *)payload[@"opentype"]!=nil) {
        if([(NSString *)payload[@"opentype"] isEqual:@"html5"]){
            showParam.openType = AlibcOpenTypeAuto;
        }else{
            showParam.openType = AlibcOpenTypeNative;
        }
    }else{
        showParam.openType = AlibcOpenTypeAuto;
    }
    showParam.nativeFailMode = AlibcNativeFailModeJumpH5;
    //新版加入，防止唤醒手淘app的时候打开h5
    showParam.linkKey=@"taobao";
    
    if ((NSString *)payload[@"isvcode"]!=nil) {
        isvcode=(NSString *)payload[@"isvcode"];
    }
    NSDictionary *trackParam=@{@"isv_code":isvcode};
    //返回处理后的参数
    return @{@"showParams":showParam,@"taokeParams":taokeParam,@"trackParam":trackParam};
}


@end
