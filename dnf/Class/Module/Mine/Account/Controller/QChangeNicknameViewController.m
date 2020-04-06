//
//  QChangeNicknameViewController.m
//  dnf
//
//  Created by wake on 2016/10/17.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "QChangeNicknameViewController.h"

@interface QChangeNicknameViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nickname;

@end

@implementation QChangeNicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nickname.text = [QUser current].nickname;
    
}

- (IBAction)onNickname:(id)sender {
    if ([self.nickname.text isEqualToString:[QUser current].nickname] || [self.nickname.text isEqualToString:@""]) {
        return;
    }
    [self viewHasTouched];
    QRequestNickname *params = [[QRequestNickname alloc] init];
    params.nickname = self.nickname.text;
    [QAPIClient nicknameWithParams:params success:^(QResponseData *response) {
        if (response.code == kResponseSuccess) {
            [[RLMRealm defaultRealm] transactionWithBlock:^{
                [QUser current].nickname = self.nickname.text;
            }];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showTip:response.msg];
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
