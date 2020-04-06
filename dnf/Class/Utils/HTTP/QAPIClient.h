//
//  QAPIClient.h
//  dnf
//
//  Created by wake on 2016/10/11.
//  Copyright © 2016年 wake. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QAPIClient : NSObject

+ (void)signInWithParams:(QRequestSignIn *)params success:(void (^)(QResponseSignIn *response))success failure:(void (^)(NSError *error))failure;

+ (void)signUpWithParams:(QRequestSignUp *)params success:(void (^)(QResponseSignUp *response))success failure:(void (^)(NSError *error))failure;

+ (void)nicknameWithParams:(QRequestNickname *)params success:(void (^)(QResponseData *response))success failure:(void (^)(NSError *error))failure;

+ (void)smsWithParams:(QRequestSMS *)params success:(void (^)(QResponseData *response))success failure:(void (^)(NSError *error))failure;

+ (void)validationWithParams:(QRequestValidation *)params success:(void (^)(QResponseData *response))success failure:(void (^)(NSError *error))failure;

+ (void)phoneWithParams:(QRequestPhone *)params success:(void (^)(QResponseData *response))success failure:(void (^)(NSError *error))failure;

+ (void)passwordWithParams:(QRequestPassword *)params success:(void (^)(QResponseData *response))success failure:(void (^)(NSError *error))failure;

+ (void)assetsWithParams:(QRequestAssets *)params success:(void (^)(QResponseAsset *response))success failure:(void (^)(NSError *error))failure;

+ (void)categoryWithParams:(QRequestAssets *)params success:(void (^)(QResponseAsset *response))success failure:(void (^)(NSError *error))failure;

+ (void)servicerWithParams:(QRequestServicer *)params success:(void (^)(QResponseServicer *response))success failure:(void (^)(NSError *error))failure;

+ (void)servicerUpdateWithParams:(QRequestUpdateServicer *)params success:(void (^)(QResponseUpdateServicer *response))success failure:(void (^)(NSError *error))failure;

+ (void)servicerListWithParams:(QRequestData *)params success:(void (^)(QResponseServicerList *response))success failure:(void (^)(NSError *error))failure;

+ (void)lolAccountWithParams:(QRequestLOLAccount *)params success:(void (^)(QResponseLOLAccountList *response))success failure:(void (^)(NSError *error))failure;

+ (void)lolAccountUpdateWithParams:(QRequestUpdateLOLAccount *)params success:(void (^)(QResponseUpdateLOLAccount *response))success failure:(void (^)(NSError *error))failure;

+ (void)lolAccountDeleteWithParams:(QRequestDeleteLOLAccount *)params success:(void (^)(QResponseData *response))success failure:(void (^)(NSError *error))failure;

+ (void)userWithParams:(QRequestData *)params success:(void (^)(QResponseData *response))success failure:(void (^)(NSError *error))failure;

+ (void)signOutWithParams:(QRequestData *)params success:(void (^)(QResponseData *response))success failure:(void (^)(NSError *error))failure;

+ (void)requestWithParams:(id)params success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

@end
