//
//  BCWebManager.m
//  RNReactNativeMbaichuan
//
//  Created by IORI on 2019/2/14.
//  Copyright © 2019 Facebook. All rights reserved.
//
#import <React/RCTViewManager.h>
#import <React/RCTUIManager.h>
#import <UIKit/UIKit.h>
#import "BCWebManager.h"
#import "BCWebView.h"
#import <React/RCTLog.h>

@implementation BCWebManager

RCT_EXPORT_MODULE()

- (UIView *)view
{
    BCWebView *webView = [[BCWebView alloc] initWithFrame:CGRectZero];
    //webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //暂时去除
    //webView.scalesPageToFit = YES;
    webView.scrollView.scrollEnabled = YES;
    webView.navigationDelegate = self;
    return webView;
}

//导出属性
RCT_EXPORT_VIEW_PROPERTY(param, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(onTradeResult, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onStateChange, RCTDirectEventBlock)

RCT_EXPORT_METHOD(goBack:(nonnull NSNumber *)reactTag)
{
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, BCWebView *> *viewRegistry) {
        BCWebView *view = viewRegistry[reactTag];
        if (![view isKindOfClass:[BCWebView class]]) {
            RCTLogError(@"Invalid view returned from registry, expecting AlibcWebView, got: %@", view);
        } else {
            [view goBack];
        }
    }];
}

RCT_EXPORT_METHOD(goForward:(nonnull NSNumber *)reactTag)
{
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, BCWebView *> *viewRegistry) {
        BCWebView *view = viewRegistry[reactTag];
        if (![view isKindOfClass:[BCWebView class]]) {
            RCTLogError(@"Invalid view returned from registry, expecting AlibcWebView, got: %@", view);
        } else {
            [view goForward];
        }
    }];
}

RCT_EXPORT_METHOD(reload:(nonnull NSNumber *)reactTag)
{
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, BCWebView *> *viewRegistry) {
        BCWebView *view = viewRegistry[reactTag];
        if (![view isKindOfClass:[BCWebView class]]) {
            RCTLogError(@"Invalid view returned from registry, expecting AlibcWebView, got: %@", view);
        } else {
            [view reload];
        }
    }];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    RCTLog(@"Loading URL :%@",[navigationAction.request.URL absoluteString]);
    NSString* url = navigationAction.request.URL.absoluteString;
    if ([url hasPrefix:@"http://"]  ||
        [url hasPrefix:@"https://"] ||
        [url hasPrefix:@"file://"]) {
        decisionHandler(WKNavigationActionPolicyAllow);
    } else {
        decisionHandler(WKNavigationActionPolicyCancel); //to stop loading
    }
}

- (void)webView:(BCWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    webView.onStateChange(@{
        @"loading": @(true),
        @"canGoBack": @([webView canGoBack]),
                          });
}

- (void)webView:(BCWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    webView.onStateChange(@{
        @"loading": @(false),
        @"canGoBack": @([webView canGoBack]),
        @"title": webView.title,
                          });
}

- (void)webView:(BCWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    /*webView.onStateChange(@{
     @"loading": @(false),
     @"error": @(true),
     @"canGoBack": @([webView canGoBack]),
     });
     RCTLog(@"Failed to load with error :%@",[error debugDescription]);*/
}

@end
