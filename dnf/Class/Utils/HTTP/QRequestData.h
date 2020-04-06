//
//  QRequestData.h
//  dnf
//
//  Created by wake on 2016/10/12.
//  Copyright © 2016年 wake. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QRequestData : NSObject

@property (nonatomic, strong)NSString *url;
@property (nonatomic, assign)BOOL showHUD;

@end

#pragma mark - signin

@interface QRequestSignIn : QRequestData

@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *captcha;

@end

#pragma mark - signup

@interface QRequestSignUp : QRequestData

@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *sms;

@end

#pragma mark - nickname

@interface QRequestNickname : QRequestData

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *nickname;

@end

#pragma mark - sms

@interface QRequestSMS : QRequestData

@property (nonatomic, assign) QSMSType type;
@property (nonatomic, strong) NSString *phone;

@end

#pragma mark - sms

@interface QRequestValidation : QRequestData

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *sms;
@property (nonatomic, assign) QSMSType type;

@end

#pragma mark - phone

@interface QRequestPhone : QRequestData

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *original;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *sms;

@end

@interface QRequestPassword : QRequestData

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *password;

@end

@interface QRequestAssets : QRequestData

@property (nonatomic, assign) QServicerPickerType type;

@end

@interface QRequestUser : QRequestData

@end

@interface QRequestServicer : QRequestData

@property (nonatomic, strong) NSNumber *uid;

@end

@interface QRequestUpdateServicer : QRequestData

@property (nonatomic, assign) BOOL enable;
@property (nonatomic, strong) NSNumber *uid;
@property (nonatomic, strong) NSString *format;
@property (nonatomic, strong) NSString *level;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *position;

@end

@interface QRequestLOLAccount : QRequestData

@property (nonatomic, strong) NSNumber *uid;

@end

@interface QRequestUpdateLOLAccount : QRequestData

@property (nonatomic, strong) NSNumber *uid;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSNumber *id;

@end

@interface QRequestDeleteLOLAccount : QRequestData

@property (nonatomic, strong) NSNumber *uid;
@property (nonatomic, strong) NSNumber *id;

@end


