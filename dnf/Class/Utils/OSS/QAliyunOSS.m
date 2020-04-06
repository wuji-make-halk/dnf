//
//  QAliyunOSS.m
//  dnf
//
//  Created by wake on 2016/10/6.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "QAliyunOSS.h"

NSString * const AccessKey = @"LTAI4Fcok7PWjWSnzDRC2i1A";
NSString * const SecretKey = @"s9aiJJMqf5Gsed96viajjzovSaxMOq";
NSString * const endPoint = @"oss.initme.com";
NSString * const multipartUploadKey = @"multipartUploadObject";
NSString * const bucketName = @"initme";
NSString * const avatarName = @"avatar.jpg";

@implementation QAliyunOSS

singleton_implementation(QAliyunOSS)

- (OSSClient *)client
{
    if (!_client) {
        id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:AccessKey
                                                                                                                secretKey:SecretKey];
        
        // 自实现签名，可以用本地签名也可以远程加签
        id<OSSCredentialProvider> credential1 = [[OSSCustomSignerCredentialProvider alloc] initWithImplementedSigner:^NSString *(NSString *contentToSign, NSError *__autoreleasing *error) {
            NSString *signature = [OSSUtil calBase64Sha1WithData:contentToSign withSecret:SecretKey];
            if (signature != nil) {
                *error = nil;
            } else {
                // construct error object
                *error = [NSError errorWithDomain:endPoint code:OSSClientErrorCodeSignFailed userInfo:nil];
                return nil;
            }
            return [NSString stringWithFormat:@"OSS %@:%@", AccessKey, signature];
        }];
        
        // Federation鉴权，建议通过访问远程业务服务器获取签名
        // 假设访问业务服务器的获取token服务时，返回的数据格式如下：
        // {"accessKeyId":"STS.iA645eTOXEqP3cg3VeHf",
        // "accessKeySecret":"rV3VQrpFQ4BsyHSAvi5NVLpPIVffDJv4LojUBZCf",
        // "expiration":"2015-11-03T09:52:59Z[;",
        // "federatedUser":"335450541522398178:alice-001",
        // "requestId":"C0E01B94-332E-4582-87F9-B857C807EE52",
        // "securityToken":"CAES7QIIARKAAZPlqaN9ILiQZPS+JDkS/GSZN45RLx4YS/p3OgaUC+oJl3XSlbJ7StKpQp1Q3KtZVCeAKAYY6HYSFOa6rU0bltFXAPyW+jvlijGKLezJs0AcIvP5a4ki6yHWovkbPYNnFSOhOmCGMmXKIkhrRSHMGYJRj8AIUvICAbDhzryeNHvUGhhTVFMuaUE2NDVlVE9YRXFQM2NnM1ZlSGYiEjMzNTQ1MDU0MTUyMjM5ODE3OCoJYWxpY2UtMDAxMOG/g7v6KToGUnNhTUQ1QloKATEaVQoFQWxsb3cSHwoMQWN0aW9uRXF1YWxzEgZBY3Rpb24aBwoFb3NzOioSKwoOUmVzb3VyY2VFcXVhbHMSCFJlc291cmNlGg8KDWFjczpvc3M6KjoqOipKEDEwNzI2MDc4NDc4NjM4ODhSAFoPQXNzdW1lZFJvbGVVc2VyYABqEjMzNTQ1MDU0MTUyMjM5ODE3OHIHeHljLTAwMQ=="}
        id<OSSCredentialProvider> credential2 = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * {
            NSURL * url = [NSURL URLWithString:@"http://localhost:8080/distribute-token.json"];
            NSURLRequest * request = [NSURLRequest requestWithURL:url];
            OSSTaskCompletionSource * tcs = [OSSTaskCompletionSource taskCompletionSource];
            NSURLSession * session = [NSURLSession sharedSession];
            NSURLSessionTask * sessionTask = [session dataTaskWithRequest:request
                                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                            if (error) {
                                                                [tcs setError:error];
                                                                return;
                                                            }
                                                            [tcs setResult:data];
                                                        }];
            [sessionTask resume];
            [tcs.task waitUntilFinished];
            if (tcs.task.error) {
                NSLog(@"get token error: %@", tcs.task.error);
                return nil;
            } else {
                NSDictionary * object = [NSJSONSerialization JSONObjectWithData:tcs.task.result
                                                                        options:kNilOptions
                                                                          error:nil];
                OSSFederationToken * token = [OSSFederationToken new];
                token.tAccessKey = [object objectForKey:@"accessKeyId"];
                token.tSecretKey = [object objectForKey:@"accessKeySecret"];
                token.tToken = [object objectForKey:@"securityToken"];
                token.expirationTimeInGMTFormat = [object objectForKey:@"expiration"];
                NSLog(@"get token: %@", token);
                return token;
            }
        }];
        
        
        OSSClientConfiguration * conf = [OSSClientConfiguration new];
        conf.maxRetryCount = 2;
        conf.timeoutIntervalForRequest = 30;
        conf.timeoutIntervalForResource = 24 * 60 * 60;
        
        return [[OSSClient alloc] initWithEndpoint:endPoint credentialProvider:credential clientConfiguration:conf];
    }
    return _client;
}

- (OSSPutObjectRequest *)put
{
    if (!_put) {
        _put = [OSSPutObjectRequest new];
        _put.bucketName = bucketName;
        _put.contentType = @"";
        _put.contentMd5 = @"";
        _put.contentEncoding = @"";
        _put.contentDisposition = @"";
        return _put;
    }
    return _put;
}

- (OSSTask *)task
{
    if (!_task) {
        OSSTask * putTask = [[QAliyunOSS sharedQAliyunOSS].client putObject:[QAliyunOSS sharedQAliyunOSS].put];
        return putTask;
    }
    return _task;
}



// 签名URL授予第三方访问
+ (NSString *)signAccessUrlWithObjectKey:(NSString *)objectKey public:(BOOL)state {
    
    NSString *url = nil;
    
    OSSTask * task = [[QAliyunOSS sharedQAliyunOSS].client presignConstrainURLWithBucketName:bucketName
                                                                                      withObjectKey:objectKey
                                                                             withExpirationInterval: 30 * 60];
    
    if (state) {
        task = [[QAliyunOSS sharedQAliyunOSS].client presignPublicURLWithBucketName:bucketName
                                                                      withObjectKey:objectKey];
    }
    
    if (!task.error) {
        url = (NSString *)task.result;
    } else {
        NSLog(@"sign url error: %@", task.error);
        url = @"";
    }
    return url;
}

// 签名URL授予第三方访问
+ (NSURL *)signAccessUrl {
    NSString *url = nil;
    OSSTask * task = [[QAliyunOSS sharedQAliyunOSS].client presignPublicURLWithBucketName:bucketName
                                                                      withObjectKey:[QAliyunOSS objectKey]];
    if (!task.error) {
        url = (NSString *)task.result;
    } else {
        NSLog(@"sign url error: %@", task.error);
        url = @"";
    }
    return [NSURL URLWithString:url];
}

+ (NSString *)objectKey
{
    return [NSString stringWithFormat:@"%@/%@", [QUser current].id, avatarName];
}

+ (NSURL *)avatarUrl:(NSString *)uid
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@%%2Favatar.jpg", endPoint, uid]];
}

@end
