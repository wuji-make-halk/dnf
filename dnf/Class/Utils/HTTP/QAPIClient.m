//
//  QAPIClient.m
//  dnf
//
//  Created by wake on 2016/10/11.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "QAPIClient.h"
#import "QHTTPClient.h"

static NSString * const API_URL_SIGNIN = @"signin";
static NSString * const API_URL_SIGNUP = @"signup";
static NSString * const API_URL_SIGNOUT = @"signout";
static NSString * const API_URL_SMS = @"sms";
static NSString * const API_URL_VALIDATION = @"user/validation";
static NSString * const API_URL_NICKNAME = @"user/nickname";
static NSString * const API_URL_PHONE = @"user/phone";
static NSString * const API_URL_PASSWORD = @"user/password";
static NSString * const API_URL_USER = @"user";
static NSString * const API_URL_SERVICER = @"user/servicer";
static NSString * const API_URL_SERVICER_UPDATE = @"user/servicer_update";

static NSString * const API_URL_LOL_ACCOUNT = @"user/lol_account";
static NSString * const API_URL_LOL_ACCOUNT_UPDATE = @"user/lol_account_update";
static NSString * const API_URL_LOL_ACCOUNT_DELETE = @"user/lol_account_delete";

static NSString * const API_URL_PUBLIC_VALIDATION = @"validation";
static NSString * const API_URL_PUBLIC_PASSWORD = @"password";

static NSString * const API_URL_ASSETS = @"assets";
static NSString * const API_URL_CATEGORY = @"category";
static NSString * const API_URL_SERVICER_LIST = @"servicer";

@implementation QAPIClient

+ (void)signInWithParams:(QRequestSignIn *)params success:(void (^)(QResponseSignIn *response))success failure:(void (^)(NSError *error))failure
{
    [QHTTPClient post:API_URL_SIGNIN params:params.mj_keyValues success:^(id json) {
        success([QResponseSignIn mj_objectWithKeyValues:json]);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)signUpWithParams:(QRequestSignUp *)params success:(void (^)(QResponseSignUp *response))success failure:(void (^)(NSError *error))failure
{
    [QHTTPClient post:API_URL_SIGNUP params:params.mj_keyValues success:^(id json) {
        success([QResponseSignUp mj_objectWithKeyValues:json]);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)nicknameWithParams:(QRequestNickname *)params success:(void (^)(QResponseData *response))success failure:(void (^)(NSError *error))failure
{
    [QHTTPClient post:API_URL_NICKNAME params:params.mj_keyValues success:^(id json) {
        success([QResponseData mj_objectWithKeyValues:json]);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)smsWithParams:(QRequestSMS *)params success:(void (^)(QResponseData *response))success failure:(void (^)(NSError *error))failure
{
    [QHTTPClient post:API_URL_SMS params:params.mj_keyValues success:^(id json) {
        success([QResponseData mj_objectWithKeyValues:json]);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)validationWithParams:(QRequestValidation *)params success:(void (^)(QResponseData *response))success failure:(void (^)(NSError *error))failure
{
    [QHTTPClient post:params.id ? API_URL_VALIDATION : API_URL_PUBLIC_VALIDATION params:params.mj_keyValues success:^(id json) {
        success([QResponseData mj_objectWithKeyValues:json]);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)phoneWithParams:(QRequestPhone *)params success:(void (^)(QResponseData *response))success failure:(void (^)(NSError *error))failure
{
    [QHTTPClient post:API_URL_PHONE params:params.mj_keyValues success:^(id json) {
        success([QResponseData mj_objectWithKeyValues:json]);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)passwordWithParams:(QRequestPassword *)params success:(void (^)(QResponseData *response))success failure:(void (^)(NSError *error))failure
{
    [QHTTPClient post:params.id ? API_URL_PASSWORD : API_URL_PUBLIC_PASSWORD params:params.mj_keyValues success:^(id json) {
        success([QResponseData mj_objectWithKeyValues:json]);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)assetsWithParams:(QRequestAssets *)params success:(void (^)(QResponseAsset *response))success failure:(void (^)(NSError *error))failure
{
    [QHTTPClient get:API_URL_ASSETS params:params.mj_keyValues success:^(id json) {
        success([QResponseAsset mj_objectWithKeyValues:json]);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)categoryWithParams:(QRequestAssets *)params success:(void (^)(QResponseAsset *response))success failure:(void (^)(NSError *error))failure
{
    [QHTTPClient get:API_URL_CATEGORY params:params.mj_keyValues success:^(id json) {
        success([QResponseAsset mj_objectWithKeyValues:json]);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)servicerWithParams:(QRequestServicer *)params success:(void (^)(QResponseServicer *response))success failure:(void (^)(NSError *error))failure
{
    [QHTTPClient post:API_URL_SERVICER params:params.mj_keyValues success:^(id json) {
        success([QResponseServicer mj_objectWithKeyValues:json]);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)servicerUpdateWithParams:(QRequestUpdateServicer *)params success:(void (^)(QResponseUpdateServicer *response))success failure:(void (^)(NSError *error))failure
{
    [QHTTPClient post:API_URL_SERVICER_UPDATE params:params.mj_keyValues success:^(id json) {
        success([QResponseUpdateServicer mj_objectWithKeyValues:json]);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)servicerListWithParams:(QRequestData *)params success:(void (^)(QResponseServicerList *response))success failure:(void (^)(NSError *error))failure
{
    [QHTTPClient get:API_URL_SERVICER_LIST params:params.mj_keyValues success:^(id json) {
        success([QResponseServicerList mj_objectWithKeyValues:json]);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)lolAccountWithParams:(QRequestLOLAccount *)params success:(void (^)(QResponseLOLAccountList *response))success failure:(void (^)(NSError *error))failure
{
    [QHTTPClient post:API_URL_LOL_ACCOUNT params:params.mj_keyValues success:^(id json) {
        success([QResponseLOLAccountList mj_objectWithKeyValues:json]);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)lolAccountUpdateWithParams:(QRequestUpdateLOLAccount *)params success:(void (^)(QResponseUpdateLOLAccount *response))success failure:(void (^)(NSError *error))failure
{
    [QHTTPClient post:API_URL_LOL_ACCOUNT_UPDATE params:params.mj_keyValues success:^(id json) {
        success([QResponseUpdateLOLAccount mj_objectWithKeyValues:json]);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)lolAccountDeleteWithParams:(QRequestDeleteLOLAccount *)params success:(void (^)(QResponseData *response))success failure:(void (^)(NSError *error))failure
{
    [QHTTPClient post:API_URL_LOL_ACCOUNT_DELETE params:params.mj_keyValues success:^(id json) {
        success([QResponseData mj_objectWithKeyValues:json]);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)userWithParams:(QRequestData *)params success:(void (^)(QResponseData *response))success failure:(void (^)(NSError *error))failure
{
    [QHTTPClient post:API_URL_USER params:params.mj_keyValues success:^(id json) {
        success([QResponseData mj_objectWithKeyValues:json]);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)signOutWithParams:(QRequestData *)params success:(void (^)(QResponseData *response))success failure:(void (^)(NSError *error))failure
{
    [QHTTPClient post:API_URL_SIGNOUT params:params.mj_keyValues success:^(id json) {
        success([QResponseData mj_objectWithKeyValues:json]);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)requestWithParams:(id)params success:(void (^)(id response))success failure:(void (^)(NSError *error))failure
{
//    [QHTTPClient post:params.url params:params.mj_keyValues success:^(id json) {
//        success([QResponseData mj_objectWithKeyValues:json]);
//    } failure:^(NSError *error) {
//        failure(error);
//    }];
}

@end
