//
//  QRequestData.m
//  dnf
//
//  Created by wake on 2016/10/12.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "QRequestData.h"

@implementation QRequestData

- (instancetype)init
{
    if (self = [super init]) {
        self.showHUD = YES;
    }
    return self;
}

@end


@implementation QRequestSignIn

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

@end

@implementation QRequestSignUp

- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

@end

@implementation QRequestNickname

- (instancetype)init
{
    if (self = [super init]) {
        self.id = [QUser current].id;
    }
    return self;
}

@end

@implementation QRequestSMS

@end

@implementation QRequestValidation

- (instancetype)init
{
    if (self = [super init]) {
        self.id = [QUser current].id;
    }
    return self;
}

@end

@implementation QRequestPhone

- (instancetype)init
{
    if (self = [super init]) {
        self.id = [QUser current].id;
        self.original = [QUser current].phone;
    }
    return self;
}

@end

@implementation QRequestPassword

- (instancetype)init
{
    if (self = [super init]) {
        self.id = [QUser current].id;
        self.phone = [QUser current].phone;
    }
    return self;
}

@end

@implementation QRequestAssets

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

@end

@implementation QRequestUser
- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}
@end

@implementation QRequestServicer
- (instancetype)init
{
    if (self = [super init]) {
        self.uid = [QUser current].id;
        self.showHUD = NO;
    }
    return self;
}
@end

@implementation QRequestUpdateServicer

- (instancetype)init
{
    if (self = [super init]) {
        self.uid = [QUser current].id;
    }
    return self;
}

@end

@implementation QRequestLOLAccount

- (instancetype)init
{
    if (self = [super init]) {
        self.uid = [QUser current].id;
        self.showHUD = NO;
    }
    return self;
}

@end

@implementation QRequestUpdateLOLAccount

- (instancetype)init
{
    if (self = [super init]) {
        self.uid = [QUser current].id;
    }
    return self;
}

@end

@implementation QRequestDeleteLOLAccount

- (instancetype)init
{
    if (self = [super init]) {
        self.uid = [QUser current].id;
        self.showHUD = NO;
    }
    return self;
}

@end

