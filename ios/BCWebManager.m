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
    webView.scalesPageToFit = YES;
    webView.scrollView.scrollEnabled = YES;
    webView.delegate = self;
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
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    RCTLog(@"Loading URL :%@",request.URL.absoluteString);
    NSString* url = request.URL.absoluteString;
    if ([url hasPrefix:@"http://"]  ||
        [url hasPrefix:@"https://"] ||
        [url hasPrefix:@"file://"]) {
        return YES;
    } else {
        return FALSE; //to stop loading
    }
}

- (void)webViewDidStartLoad:(BCWebView *)webView
{
    webView.onStateChange(@{
                            @"loading": @(true),
                            @"canGoBack": @([webView canGoBack]),
                            });
}

- (void)webViewDidFinishLoad:(BCWebView *)webView
{
    webView.onStateChange(@{
                            @"loading": @(false),
                            @"canGoBack": @([webView canGoBack]),
                            @"title": [webView stringByEvaluatingJavaScriptFromString:@"document.title"],
                            });
}

- (void)webView:(BCWebView *)webView didFailLoadWithError:(NSError *)error
{
    /*webView.onStateChange(@{
     @"loading": @(false),
     @"error": @(true),
     @"canGoBack": @([webView canGoBack]),
     });
     RCTLog(@"Failed to load with error :%@",[error debugDescription]);*/
}
@end
