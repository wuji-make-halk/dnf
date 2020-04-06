//
//  QAliyunOSS.h
//  dnf
//
//  Created by wake on 2016/10/6.
//  Copyright © 2016年 wake. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QAliyunOSS : NSObject

singleton_interface(QAliyunOSS)

@property (nonatomic, strong)OSSClient *client;

@property (nonatomic, strong)OSSPutObjectRequest *put;

@property (nonatomic, strong)OSSTask *task;

+ (NSString *)signAccessUrlWithObjectKey:(NSString *)objectKey public:(BOOL)state;

+ (NSURL *)signAccessUrl;

+ (NSString *)objectKey;

+ (NSURL *)avatarUrl:(NSString *)uid;

@end
