//
//  QTouchUnLock.h
//  dnf
//
//  Created by wake on 2016/11/3.
//  Copyright © 2016年 wake. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QTouchUnLock : NSObject

+ (void)evaluatePolicyWithTouchID:(void(^)(BOOL result)) result;

@end
