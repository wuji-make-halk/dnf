//
//  QHTTPClient.m
//  dnf
//
//  Created by wake on 2016/10/11.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "QHTTPClient.h"

static NSString * const APIBaseURLString = @"http://lol.initme.com/";

@implementation QHTTPClient

+ (instancetype)sharedClient {
    static QHTTPClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[QHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIBaseURLString]];
        
        //        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        _sharedClient.requestSerializer.timeoutInterval = 30;
        
        _sharedClient.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        _sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    });
    
    return _sharedClient;
}

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    QRequestData *request = [QRequestData mj_objectWithKeyValues:params];
    
//    if (request.showHUD) {
//        [MBProgressHUD showMessage:nil toView:nil];
//    }
    
    QHTTPClient *manager = [QHTTPClient sharedClient];
    
    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        [self urlWithTask:task params:params];
        
        if(success){
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//            NSLog(@"请求成功：\n%@", dict);
            success(dict);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
//        [self urlWithTask:task params:params];
        
        [MBProgressHUD showError:error.localizedDescription];
        
        if(failure){
//            NSLog(@"请求失败：\n%@", error);
            failure(error);
        }
        
    }];
}

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure {
    
    QRequestData *request = [QRequestData mj_objectWithKeyValues:params];
    
    if (request.showHUD) {
        [MBProgressHUD showMessage:nil toView:nil];
    }
    
    QHTTPClient *manager = [QHTTPClient sharedClient];
    
    NSLog(@"kTokenName: %@", [[NSUserDefaults standardUserDefaults] objectForKey:kTokenName]);
    
    //自定义参数
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:kTokenName] forHTTPHeaderField:@"token"];
    
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self urlWithTask:task params:params];
        
        if(success){
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功：\n%@", dict);
            success(responseObject);
            
            QResponseData *response = [QResponseData mj_objectWithKeyValues:dict];
            if (response.code == kResponseSignTimeout) {
                postEventWithObject(QSginStateObs, @(QSignTimeoutSate));
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self urlWithTask:task params:params];
        
        [MBProgressHUD showError:error.localizedDescription];
        
        if(failure){
            NSLog(@"请求失败：\n%@", error);
            failure(error);
        }
        
    }];
    
}

+ (void)urlWithTask:(NSURLSessionDataTask *)task params:(id)params {
    
    QRequestData *request = [QRequestData mj_objectWithKeyValues:params];
    
    if (request.showHUD) {
        [MBProgressHUD hideHUD];
    }
    
    NSLog(@"\n====请求信息==============================================================\n");
    
    NSLog(@"当前网络状态: \n%@", [QHTTPClient sharedClient].reachabilityManager.localizedNetworkReachabilityStatusString);
    
    NSLog(@"请求的地址: \n%@", task.currentRequest.URL.absoluteString);
    
    NSLog(@"请求的方法: \n%@", task.currentRequest.HTTPMethod);
    
    NSLog(@"请求的头信息: \n%@", task.currentRequest.allHTTPHeaderFields);
    
    NSLog(@"请求的参数: \n%@", params);

    if (![QHTTPClient sharedClient].reachabilityManager.isReachable) {
        NSLog(@"当前网络不可用, 请求中止");
        [task cancel];
    }
    //http://lol.initme.com/user/nickname
    //http://lol.initme.com/user/validation
    NSLog(@"\n==========================================================================");

}

@end
