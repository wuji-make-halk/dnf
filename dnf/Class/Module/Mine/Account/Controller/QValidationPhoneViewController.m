//
//  QValidationPhoneViewController.m
//  dnf
//
//  Created by wake on 2016/10/18.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "QValidationPhoneViewController.h"
#import "QChangePasswordViewController.h"

@interface QValidationPhoneViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *sms;

@property (strong, nonatomic) IBOutlet JKCountDownButton *smsButton;

@end

@implementation QValidationPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%ld", self.type);
    
    if (self.type == QValidationForgotPasswordType) {
        self.phone.enabled = YES;
        self.phone.text = @"";
        self.phone.placeholder = @"输入手机号";
    }else{
        self.phone.enabled = NO;
        self.phone.text = [QUser current].phone;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.textLabel.text isEqualToString:@"下一步"]) {
        [self onValidation];
    }
}

- (void)onValidation
{
    [self viewHasTouched];
    
    if ([self.phone.text isEqualToString:@""] || [self.sms.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请填写完整信息"];
        return;
    }
    
    QRequestValidation *request= [[QRequestValidation alloc] init];
    request.phone = self.phone.text;
    request.sms = self.sms.text;
    request.type = QSMSPhone;
    
    [QAPIClient validationWithParams:request success:^(QResponseData *response) {
        if (response.code == kResponseSuccess) {
            if (self.type == QValidationChangePhoneType) {
                [self performSegueWithIdentifier:@"QChangePhoneViewController" sender:nil];
            }else if (self.type == QValidationChangePasswordType || self.type == QValidationForgotPasswordType) {
                [self performSegueWithIdentifier:@"QChangePasswordViewController" sender:nil];
            }
        }else{
            [MBProgressHUD showTip:response.msg];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"QChangePasswordViewController"]) {
        if (self.type == QValidationForgotPasswordType) {
            QChangePasswordViewController *changePassword = segue.destinationViewController;
            changePassword.phone = self.phone.text;
        }
    }
}

- (IBAction)onSMS:(JKCountDownButton *)sender {
    if ([self.phone.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入手机号"];
        return;
    }
    
    QRequestSMS *request= [[QRequestSMS alloc] init];
    request.phone = self.phone.text;
    request.type = QSMSPhone;
    
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

}


@end
