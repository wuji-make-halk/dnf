//
//  QChangePhoneViewController.m
//  dnf
//
//  Created by wake on 2016/10/18.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "QChangePhoneViewController.h"

@interface QChangePhoneViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *sms;

@property (strong, nonatomic) IBOutlet JKCountDownButton *smsButton;
@end

@implementation QChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (BOOL)navigationShouldPopOnBackButton
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex: 1] animated:YES];
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.textLabel.text isEqualToString:@"确认"]) {
        [self onPhone];
    }
}

- (void)onPhone
{
    [self viewHasTouched];
    
    if ([self.phone.text isEqualToString:@""] || [self.sms.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请填写完整信息"];
        return;
    }
    
    QRequestPhone *request= [[QRequestPhone alloc] init];
    request.phone = self.phone.text;
    request.sms = self.sms.text;
    
    [QAPIClient phoneWithParams:request success:^(QResponseData *response) {
        [MBProgressHUD showTip:response.msg];
        if (response.code == kResponseSuccess) {
            [[RLMRealm defaultRealm] transactionWithBlock:^{
                [QUser current].phone = self.phone.text;
            }];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex: 1] animated:YES];
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
