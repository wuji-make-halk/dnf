//
//  QSignInViewController.m
//  dnf
//
//  Created by wake on 2016/10/5.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "QSignInViewController.h"
#import "QValidationPhoneViewController.h"

@interface QSignInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *captcha;
@property (strong, nonatomic) IBOutlet UIButton *captchaButton;

@end

@implementation QSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self onCaptcha:nil];
    
    self.phone.text = @"18681578163";
    self.password.text = @"888888";
    self.captcha.text = @"6666";

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
     
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqualToString:@"登录"]) {
        [self onSignIn];
    }
}

- (void)onSignIn
{
    [self viewHasTouched];
    
    QRequestSignIn *request = [[QRequestSignIn alloc] init];
    request.phone = self.phone.text;
    request.password = [self.password.text md5Encrypt].lowercaseString;
    request.captcha = self.captcha.text;

    [QAPIClient signInWithParams:request success:^(QResponseSignIn *response) {
        if (response.code == kResponseSuccess) {
            
            postEventWithObject(QSginStateObs, @(QSignInState));
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                EMError *error = [[EMClient sharedClient] loginWithUsername:response.result.uuid password:request.password];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!error) {
                        //设置是否自动登录
                        [[EMClient sharedClient].options setIsAutoLogin:YES];
                        
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            [[EMClient sharedClient] migrateDatabaseToLatestSDK];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[ChatUIHelper shareHelper] asyncConversationFromDB];
                                [[ChatUIHelper shareHelper] asyncPushOptions];
                                //发送自动登陆状态通知
                                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@([[EMClient sharedClient] isLoggedIn])];
                            });
                        });
                    }
                });
            });
            
            NSLog(@"%@", response.result);
            if (![QUser signIn:response.result password:request.password]) {
                [MBProgressHUD showError:@"系统异常"];
                return;
            }
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self onCaptcha:nil];
            [MBProgressHUD showError:response.msg];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)onCaptcha:(id)sender {
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:@"http://lol.initme.com/captcha"] options:SDWebImageRefreshCached | SDWebImageHandleCookies progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        [self.captchaButton setBackgroundImage:image forState:UIControlStateNormal];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"QValidationPhoneViewController"]) {
        QValidationPhoneViewController *validation = segue.destinationViewController;
        validation.type = QValidationForgotPasswordType;
    }
}

@end
