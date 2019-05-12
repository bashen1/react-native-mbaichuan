//
//  BCWebView.h
//  RNReactNativeMbaichuan
//
//  Created by IORI on 2019/2/14.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <React/RCTComponent.h>

NS_ASSUME_NONNULL_BEGIN

@interface BCWebView :  UIWebView

@property (nonatomic, copy) RCTDirectEventBlock onTradeResult;
@property (nonatomic, copy) RCTDirectEventBlock onStateChange;
- (void)setParam:(NSDictionary *)param;

@end

NS_ASSUME_NONNULL_END
