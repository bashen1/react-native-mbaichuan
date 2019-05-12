//
//  BCWebView.m
//  RNReactNativeMbaichuan
//
//  Created by IORI on 2019/2/14.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "BCWebView.h"
#import "BCBridge.h"

@implementation BCWebView

- (void)setParam:(NSDictionary *)param
{
    [[BCBridge sharedInstance] showInWebView:self param:param];
}

@end
