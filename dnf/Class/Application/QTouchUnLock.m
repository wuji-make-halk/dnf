//
//  QTouchUnLock.m
//  dnf
//
//  Created by wake on 2016/11/3.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "QTouchUnLock.h"
#import <LocalAuthentication/LAContext.h>

@interface QTouchUnLock()

@end

@implementation QTouchUnLock

+ (void)evaluatePolicyWithTouchID:(void(^)(BOOL result)) result
{
    LAContext *context = [LAContext new];
    NSError *error;
    if([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
    {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"Please verif the existing fingerprint,enter the app" reply:^(BOOL success, NSError * _Nullable error) {
            result(success);
        }];
    }
    else
    {
        result(NO);
    }
}

@end
