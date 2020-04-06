//
//  QSignUpViewController.m
//  dnf
//
//  Created by wake on 2016/10/5.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "QSignUpViewController.h"


@interface QSignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *sms;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *ConfimPassword;

@property (strong, nonatomic) IBOutlet JKCountDownButton *smsButton;
@end

@implementation QSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqualToString:@"注册"]) {
        [self onSignUp];
    }
}

- (void)onSignUp
{
    [self viewHasTouched];
    
    if ([self.phone.text isEqualToString:@""] || [self.sms.text isEqualToString:@""] || [self.password.text isEqualToString:@""] || ![self.password.text isEqualToString:self.ConfimPassword.text]) {
        [MBProgressHUD showError:@"请填写完整信息"];
        return;
    }
    
    QRequestSignUp *request= [[QRequestSignUp alloc] init];
    request.phone = self.phone.text;
    request.password = [self.password.text md5Encrypt].lowercaseString;
    request.sms = self.sms.text;
    
    [QAPIClient signUpWithParams:request success:^(QResponseSignUp *response) {
        [MBProgressHUD showTip:response.msg];
        if (response.code == kResponseSuccess) {
            
            postEventWithObject(QSginStateObs, @(QSignUpState));
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[EMClient sharedClient] registerWithUsername:response.result password:request.password];
            });
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)onSMS:(JKCountDownButton *)sender {
    
    if ([self.phone.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入手机号"];
        return;
    }
    
    QRequestSMS *request= [[QRequestSMS alloc] init];
    request.phone = self.phone.text;
    request.type = QSMSSignUp;
    
    [QAPIClient smsWithParams:request success:^(QResponseData *response) {
        [MBProgressHUD showTip:response.msg];
        if (response.code == kResponseSuccess) {
            sender.enabled = NO;
            
            [sender startCountDownWithSecond:60];
            
            [sender countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
                NSString *title = [NSString stringWithFormat:@"剩余%zd秒",second];
                return title;
            }];
            [sender countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
                countDownButton.enabled = YES;
                return @"重新获取";
            }];
        }
    } failure:^(NSError *error) {
        
    }];
    

    
//    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:@"http://lol.initme.com/captcha"] options:SDWebImageRefreshCached | SDWebImageHandleCookies progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//        [self.captchaButton setBackgroundImage:image forState:UIControlStateNormal];
//    }];
}

- (void)onSMS
{

}

@end
