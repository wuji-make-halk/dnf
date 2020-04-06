//
//  ResponseData.m
//  dnf
//
//  Created by wake on 2016/10/12.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "QResponseData.h"

@implementation QResponseData

@end

@implementation QUser

+ (NSArray *)mj_allowedPropertyNames
{
    return @[@"id", @"uuid", @"phone", @"nickname"];
}

+ (NSArray *)indexedProperties {
    return @[@"id"];
}

+ (QUser *)current
{
    return [[QUser allObjects] firstObject];
}

+ (BOOL)checkSign
{
    if ([[QUser allObjects] count]  && [[SAMKeychain accountsForService:kKeychainService] count]) {
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)signInSavePhone:(NSString *)phone password:(NSString *)password
{
    //保存帐号信息到钥匙串
    if([SAMKeychain setPassword:password forService:kKeychainService account:phone]){
        //保存Token信息
        [self saveTokenInCookie];
        
        postEventWithObject(QTTabBarSelect, @(QTabBarItemMine));
        
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)signIn:(QUser *)user password:(NSString *)password
{
    //保存帐号信息到钥匙串
    if([SAMKeychain setPassword:password forService:kKeychainService account:user.phone]){
        
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            [[RLMRealm defaultRealm] deleteObjects:[QUser allObjects]];
            [[RLMRealm defaultRealm] addObject:user];
        }];
        
        //保存Token信息
        [self saveTokenInCookie];
        
        postEventWithObject(QTTabBarSelect, @(QTabBarItemMine));
        
        return YES;
    }else{
        return NO;
    }
}

+ (void)signOut
{
    //删除数据库帐号信息
    [[RLMRealm defaultRealm] transactionWithBlock:^{
        [[RLMRealm defaultRealm] deleteObjects:[QUser allObjects]];
        [[RLMRealm defaultRealm] deleteObjects:[QUserServicer allObjects]];
    }];
    
    //删除钥匙串中账号信息
    for (NSDictionary *accounts in [SAMKeychain accountsForService:kKeychainService]) {
        [SAMKeychain deletePasswordForService:kKeychainService account:[accounts objectForKey:@"acct"]];
    }
    //删除Token信息
    [self removeTokenInUserdefauls];
    
    [[EMClient sharedClient] logout:YES];
    
//    postEventWithObject(QTTabBarSelect, @(QTabBarItemServicer));
    
}

+ (void)saveTokenInCookie
{
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookies) {
        if ([cookie.name isEqualToString:kTokenName]) {
            NSLog(@"cookie is: %@\n\n", cookie.value);
            [[NSUserDefaults standardUserDefaults] setObject:cookie.value forKey:kTokenName];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

+ (void)removeTokenInUserdefauls
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kTokenName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

@implementation QChatUsers

+ (NSArray *)mj_allowedPropertyNames
{
    return @[@"id", @"uuid", @"nickname"];
}

+ (NSArray *)indexedProperties {
    return @[@"id"];
}

+ (NSString *)primaryKey {
    return @"id";
}

+ (QChatUsers *)seachWithUUID:(NSString *)uuid
{
    return [[QChatUsers objectsWhere:@"uuid == %@", uuid] firstObject];
}

@end

@implementation QResponseSignIn

@end

@implementation QResponseSignUp

@end


@implementation QAssets

+ (NSArray *)mj_allowedPropertyNames
{
    return @[@"id", @"pid", @"name", @"alias", @"icon", @"leaf", @"enable"];
}

+ (NSArray *)indexedProperties {
    return @[@"id"];
}

+ (void)updateDB
{
    QRequestAssets *request= [[QRequestAssets alloc] init];
    [QAPIClient categoryWithParams:request success:^(QResponseAsset *response) {
        if (response.code == kResponseSuccess) {
            if (response.result.count!=[QAssets allObjects].count) {
                [[RLMRealm defaultRealm] transactionWithBlock:^{
                    [[RLMRealm defaultRealm] deleteObjects:[QAssets allObjects]];
                    [[RLMRealm defaultRealm] addObjects:response.result];
                }];
            }
        }else{
            
        }
    } failure:^(NSError *error) {
        
    }];
}

+(NSString *)searchResultsWithIds:(NSString *)ids
{
    if (ids.length>0) {
        RLMResults<QAssets *> *results = [QAssets objectsWhere:[NSString stringWithFormat:@"id IN {%@}", ids]];
        NSMutableArray *arrs = [[NSMutableArray alloc] init];
        for (QAssets *ast in results) {
            if (ast.pid.integerValue == QServicerPickerLevel) {
                [arrs addObject:ast.alias];
            }else{
                [arrs addObject:ast.name];
            }
        }
        return [arrs componentsJoinedByString:@" "];
    }else{
        return @"未选择";
    }
}

+(NSArray *)searchArrayWithIds:(NSString *)ids
{
    if (ids.length>0) {
        RLMResults<QAssets *> *results = [QAssets objectsWhere:[NSString stringWithFormat:@"id IN {%@}", ids]];
        NSMutableArray *arrs = [[NSMutableArray alloc] init];
        for (QAssets *ast in results) {
            if (ast.pid.integerValue == QServicerPickerLevel) {
                [arrs addObject:ast.alias];
            }else{
                [arrs addObject:ast.name];
            }
        }
        return arrs;
    }else{
        return nil;
    }
}

+(NSArray *)searchTArrayWithIds:(NSString *)ids
{
    if (ids.length>0) {
        RLMResults<QAssets *> *results = [QAssets objectsWhere:[NSString stringWithFormat:@"id IN {%@}", ids]];
        NSMutableArray *arrs = [[NSMutableArray alloc] init];
        for (QAssets *ast in results) {
            [arrs addObject:ast];
        }
        return arrs;
    }else{
        return nil;
    }
}

+ (NSInteger)serchCountWithIds:(NSString *)ids
{
    if (ids.length>0) {
        RLMResults<QAssets *> *results = [QAssets objectsWhere:[NSString stringWithFormat:@"id IN {%@}", ids]];
        return results.count;
    }else{
        return 0;
    }
}

+ (NSArray *)resultsWith:(QServicerPickerType)type section:(BOOL)section
{
    RLMResults<QAssets *> *reslut;
    reslut = [QAssets objectsWhere:[NSString stringWithFormat:@"pid = %ld", (long)type]];
    if (section) {
        NSMutableArray *ids = [[NSMutableArray alloc] init];
        for (QAssets *astx in reslut) {
            [ids addObject:astx.id];
        }
        NSString *str = [ids componentsJoinedByString:@","];
        reslut = [QAssets objectsWhere:[NSString stringWithFormat:@"pid = %ld OR pid IN {%@}", (long)type, str]];
    }
    
    NSMutableArray *parents = [[NSMutableArray alloc] init];
    NSMutableArray *chd = [[NSMutableArray alloc] init];
    for (QAssets *astx in reslut) {
        if (!astx.leaf) {
            [parents addObject:astx];
        }
    }
    
    for (QAssets *ast in parents) {
        NSMutableArray *mut = [[NSMutableArray alloc] init];
        for (QAssets *asts in reslut) {
            if ([ast.id isEqual: asts.pid]) {
                [mut addObject:asts];
            }
        }
        
        if (mut.count == 0) {
            [mut addObject:ast];
        }
        
        QAssetsList *list = [[QAssetsList alloc] init];
        list.parent = ast;
        list.children = mut;
        
        [chd addObject:list];
        
    }
    
    NSLog(@"%@", chd);
    
    return chd;
}

@end

@implementation QAssetsList

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"children" : @"QAssets"
             };
}



@end

@implementation QResponseAsset

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"result" : @"QAssets"
             };
}

@end

@implementation QUserServicer

+ (NSArray *)ignoredProperties {
    return @[@"nickname", @"uuid"];
}

+ (NSArray *)indexedProperties {
    return @[@"uid"];
}

+ (QUserServicer *)current
{
    return [[QUserServicer allObjects] firstObject];
}

+ (void)updateDB
{
    if (![QUserServicer allObjects].count) {
        QRequestServicer *request= [[QRequestServicer alloc] init];
        [QAPIClient servicerWithParams:request success:^(QResponseServicer *response) {
            if (response.code == kResponseSuccess) {
                [[RLMRealm defaultRealm] transactionWithBlock:^{
                    [[RLMRealm defaultRealm] deleteObjects:[QUserServicer allObjects]];
                    [[RLMRealm defaultRealm] addObject:response.result];
                }];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

@end

@implementation QResponseServicer

@end



@implementation QResponseUpdateServicer

@end


@implementation QResponseServicerList

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"result" : @"QUserServicer"
             };
}

@end

@implementation QResponseUpdateLOLAccount

@end

@implementation QLOLAccount

+ (NSString *)primaryKey {
    return @"id";
}

+ (void)updateDB
{
    QRequestLOLAccount *request= [[QRequestLOLAccount alloc] init];
    [QAPIClient lolAccountWithParams:request success:^(QResponseLOLAccountList *response) {
        if (response.code == kResponseSuccess) {
            [[RLMRealm defaultRealm] transactionWithBlock:^{
                [[RLMRealm defaultRealm] deleteObjects:[QLOLAccount allObjects]];
                [[RLMRealm defaultRealm] addObjects:response.result];
            }];
        }
    } failure:^(NSError *error) {
        
    }];
}

+ (void)deleteWithAccountId:(NSNumber *)id
{
    QRequestDeleteLOLAccount *request= [[QRequestDeleteLOLAccount alloc] init];
    request.id = id;
    [QAPIClient lolAccountDeleteWithParams:request success:^(QResponseData *response) {
        if (response.code == kResponseSuccess) {
        }
    } failure:^(NSError *error) {
        
    }];
}

+ (NSArray *)sectionArray
{
//    NSMutableArray *parents = [[NSMutableArray alloc] init];
    NSMutableArray *chd = [[NSMutableArray alloc] init];
    
//    for (QLOLAccount *account in [QLOLAccount allObjects]) {
//        if (![parents containsObject:account.account]) {
//            [parents addObject:account.account];
//        }
//    }
//    
//    for (NSString *account in parents) {
//        NSMutableArray *mut = [[NSMutableArray alloc] init];
//        for (QLOLAccount *acc in [QLOLAccount allObjects]) {
//            if ([account isEqual: acc.account]) {
//                [mut addObject:acc];
//            }
//        }
//        
//        QLOLAccountList *list = [[QLOLAccountList alloc] init];
//        list.section = account;
//        list.children = [[NSMutableArray alloc] initWithArray:mut];
//        
//        [chd addObject:list];
//        
//    }

    for (QLOLAccount *account in [QLOLAccount allObjects]) {
        
        QLOLAccountList *list = [[QLOLAccountList alloc] init];
        list.section = account.account;
        list.parent = account;
        list.children = [QLOLAccountAreaNickname mj_objectArrayWithKeyValuesArray:account.nickname];
        [chd addObject:list];
        
    }
    
    return chd;
}

@end

@implementation QLOLAccountList

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"children" : @"QLOLAccountArea"
             };
}



@end


@implementation QResponseLOLAccountList

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"result" : @"QLOLAccount"
             };
}

@end

@implementation QLOLAccountAreaNickname

@end
