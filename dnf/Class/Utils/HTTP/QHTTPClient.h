//
//  QHTTPClient.h
//  dnf
//
//  Created by wake on 2016/10/11.
//  Copyright © 2016年 wake. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QHTTPClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

/** get请求 */
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/** post请求 */
+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

@end
