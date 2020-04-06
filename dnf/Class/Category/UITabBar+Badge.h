//
//  UITabBar+Badge.h
//  dnf
//
//  Created by wake on 2016/11/14.
//  Copyright © 2016年 wake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (Badge)

- (void)showBadgeOnItemIndex:(int)index;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点

@end
