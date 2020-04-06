//
//  QChangePasswordViewController.m
//  dnf
//
//  Created by 张伟 on 16/10/18.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "QChangePasswordViewController.h"

@interface QChangePasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;

@end

@implementation QChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.phone) {
        self.title = @"重置密码";
    }
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
    if (self.phone) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex: 1] animated:YES];
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.textLabel.text isEqualToString:@"确认"]) {
        [self onPassword];
    }
}

- (void)onPassword
{
    [self viewHasTouched];
    
    if ([self.password.text isEqualToString:@""] || ![self.password.text isEqualToString:self.confirmPassword.text]) {
        [MBProgressHUD showError:@"请填写完整信息"];
        return;
    }
    
    QRequestPassword *request= [[QRequestPassword alloc] init];
    request.password = [self.password.text md5Encrypt].lowercaseString;
    
    if (self.phone) {
        request.phone = self.phone;
    }
    
    [QAPIClient passwordWithParams:request success:^(QResponseData *response) {
        [MBProgressHUD showTip:response.msg];
        if (response.code == kResponseSuccess) {
            if (self.phone) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex: 1] animated:YES];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
