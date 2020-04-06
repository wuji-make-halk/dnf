//
//  QResponseData.h
//  dnf
//
//  Created by wake on 2016/10/12.
//  Copyright © 2016年 wake. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QResponseData : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) NSString *msg;

@end


@interface QUser : RLMObject

@property (nonatomic, strong) NSNumber<RLMInt> *id;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString  *phone;
@property (nonatomic, strong) NSString  *nickname;

+ (QUser *)current;

+ (BOOL)checkSign;

+ (BOOL)signInSavePhone:(NSString *)phone password:(NSString *)password;

+ (BOOL)signIn:(QUser *)user password:(NSString *)password;

+ (void)signOut;

@end



@interface QChatUsers : RLMObject

@property (nonatomic, strong) NSNumber<RLMInt> *id;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString  *nickname;

+ (QChatUsers *)seachWithUUID:(NSString *)uuid;

@end



#pragma mark -

@interface QResponseSignIn : QResponseData

@property (nonatomic, strong) QUser *result;

@end


#pragma mark - 

@interface QResponseSignUp : QResponseData

@property (nonatomic, strong) NSString *result;

@end

@interface QAssets : RLMObject

@property (nonatomic, assign) NSNumber<RLMInt> *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *alias;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, assign) NSNumber<RLMInt> *pid;
@property (nonatomic, assign) BOOL leaf;
@property (nonatomic, assign) BOOL enable;

+ (void)updateDB;

+(NSString *)searchResultsWithIds:(NSString *)ids;

+(NSArray *)searchArrayWithIds:(NSString *)ids;

+(NSArray *)searchTArrayWithIds:(NSString *)ids;

+ (NSInteger)serchCountWithIds:(NSString *)ids;

+ (NSArray *)resultsWith:(QServicerPickerType)type section:(BOOL)section;

@end

@interface QAssetsList : NSObject

@property (nonatomic, strong) QAssets *parent;
@property (nonatomic, strong) NSArray *children;

@end

@interface QResponseAsset : QResponseData

@property (nonatomic, strong) NSArray *result;

@end

@interface QUserServicer : RLMObject
@property (nonatomic, assign) NSNumber<RLMInt> *id;
@property (nonatomic, strong) NSNumber<RLMInt> *uid;
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, strong) NSString *format;
@property (nonatomic, strong) NSString *level;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *position;

@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *uuid;


+ (QUserServicer *)current;

+ (void)updateDB;

@end

@interface QResponseServicer : QResponseData

@property (nonatomic, strong) QUserServicer *result;

@end


@interface QResponseUpdateServicer : QResponseData

@end


@interface QResponseServicerList : QResponseData

@property (nonatomic, strong) NSArray *result;

@end

@interface QResponseUpdateLOLAccount : QResponseData

@property (nonatomic, strong) NSNumber *result;

@end

@interface QLOLAccount : RLMObject

@property (nonatomic, strong) NSNumber<RLMInt> *id;
@property (nonatomic, strong) NSNumber<RLMInt> *uid;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *nickname;

+ (void)updateDB;

+ (void)deleteWithAccountId:(NSNumber *)id;

+ (NSArray *)sectionArray;

@end

@interface QLOLAccountList : NSObject

@property (nonatomic, strong) NSString *section;
@property (nonatomic, strong) QLOLAccount *parent;
@property (nonatomic, strong) NSMutableArray *children;

@end

@interface QResponseLOLAccountList : QResponseData

@property (nonatomic, strong) NSArray *result;

@end

@interface QLOLAccountAreaNickname : NSObject

@property (nonatomic, assign)NSNumber *aid;
@property (nonatomic, strong) NSString *nickname;

@end

