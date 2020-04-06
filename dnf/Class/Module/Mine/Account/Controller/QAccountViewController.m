//
//  QAccountViewController.m
//  dnf
//
//  Created by wake on 2016/9/27.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "QAccountViewController.h"
#import "QValidationPhoneViewController.h"

@interface QAccountViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (nonatomic, retain)UIImagePickerController * picker;

@property (weak, nonatomic) IBOutlet UIButton *state;

@end

@implementation QAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.picker = [[UIImagePickerController alloc] init];
    
    self.picker.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[SDImageCache sharedImageCache] diskImageExistsWithKey:[QAliyunOSS signAccessUrl].absoluteString]) {
        self.avatarImageView.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[QAliyunOSS signAccessUrl].absoluteString];
    }else{
        [self.avatarImageView sd_setImageWithURL:[QAliyunOSS signAccessUrl] placeholderImage:nil options:SDWebImageRefreshCached | EMSDWebImageRefreshCached];
    }
    
    self.nickname.text = [QUser current].nickname;
    
    self.phone.text = [QUser current].phone;
    
    self.state.selected = [QUserServicer current].enable;
    
    NSLog(@"%@", [QLOLAccount sectionArray]);
    
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
    
    if ([cell.textLabel.text isEqualToString:@"头像"]) {
        
        [[LCActionSheet sheetWithTitle:@"设置头像" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
            
            NSLog(@"clickedButtonAtIndex: %d", (int)buttonIndex);
            
            if (buttonIndex == 1) {
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                {
                    self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    self.picker.allowsEditing = YES;
                    [self presentViewController:self.picker animated:YES completion:nil];
                    NSLog(@"支持相机");
                }
            }else if (buttonIndex == 2){
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
                {
                    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    self.picker.allowsEditing = YES;
                    [self presentViewController:self.picker animated:YES completion:nil];
                    NSLog(@"支持相片库");
                }
            }
            
        } otherButtonTitles:@"拍照", @"从相册选择", nil] show];
        
    }else if([cell.textLabel.text isEqualToString:@"退出登录"]){
        
        [[LCActionSheet sheetWithTitle:@"确认退出?" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
            
            NSLog(@"clickedButtonAtIndex: %d", (int)buttonIndex);
            if (buttonIndex == 1) {
                [self onSignOut];
            }
            
        } otherButtonTitles:@"退出登录", nil] show];
        
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)sender
{
    QValidationPhoneViewController *validation = segue.destinationViewController;
    if ([sender.textLabel.text isEqualToString:@"手机号"]) {
        validation.type = QValidationChangePhoneType;
    }else if ([sender.textLabel.text isEqualToString:@"修改密码"]){
        validation.type = QValidationChangePasswordType;
    }
}

- (void)onSignOut
{
    postEventWithObject(QSginStateObs, @(QSignOutState));
    [self.navigationController popToRootViewControllerAnimated:YES];
//    [QAPIClient signOutWithParams:[[QRequestData alloc] init] success:^(QResponseData *response) {
//        if (response.code == kResponseSuccess) {
//
//        }else{
//            [MBProgressHUD showTip:response.msg];
//        }
//    } failure:^(NSError *error) {
//        
//    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:NO completion:^{
        id image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if ([image isKindOfClass:[UIImage class]]) {
            UIImage *img = (UIImage *)image;
            NSData *data = UIImageJPEGRepresentation(img, 0.5);
            [self upload:data withName:[QAliyunOSS objectKey]];
        }
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)upload:(NSData *)data withName:(NSString *)name
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    hud.mode = MBProgressHUDModeDeterminate;
    hud.label.text = NSLocalizedString(@"正在上传...", @"HUD loading title");
    
    [QAliyunOSS sharedQAliyunOSS].put.uploadingData = data;
    
    [QAliyunOSS sharedQAliyunOSS].put.objectKey = name;
    
    
    [QAliyunOSS sharedQAliyunOSS].put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
        
        NSString *totalSent = [NSString stringWithFormat:@"%lld", totalByteSent];
        NSString *total = [NSString stringWithFormat:@"%lld", totalBytesExpectedToSend];
        
        float pro = totalSent.floatValue / total.floatValue;
        
        NSString *pros = [NSString stringWithFormat:@"%.1f", pro];
        
        NSLog(@"%@", pros);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD HUDForView:self.navigationController.view].progress = pros.floatValue;
        });
    };
    
    [[QAliyunOSS sharedQAliyunOSS].task continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                UIImage *image = [UIImage imageWithData:[QAliyunOSS sharedQAliyunOSS].put.uploadingData];
                self.avatarImageView.image = image;
                [[SDImageCache sharedImageCache] storeImage:image forKey:[QAliyunOSS signAccessUrl].absoluteString];
            });
            NSLog(@"upload object success!");
        } else {
            [hud hideAnimated:YES];
            NSLog(@"upload object failed, error: %@" , task.error);
        }
        return nil;
    }];
}
@end
