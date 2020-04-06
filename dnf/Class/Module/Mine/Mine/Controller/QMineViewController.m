//
//  QMineViewController.m
//  dnf
//
//  Created by wake on 2016/9/26.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "QMineViewController.h"

@interface QMineViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickname;

@end

@implementation QMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([[SDImageCache sharedImageCache] diskImageExistsWithKey:[QAliyunOSS signAccessUrl].absoluteString]) {
        self.avatarImageView.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[QAliyunOSS signAccessUrl].absoluteString];
    }else{
        [self.avatarImageView sd_setImageWithURL:[QAliyunOSS signAccessUrl] placeholderImage:nil options:SDWebImageRefreshCached];
    }
    
    self.nickname.text = [QUser current].nickname;
    
    [QUserServicer updateDB];
    
    [QLOLAccount updateDB];
    
    postEvent(kSetupUnreadMessageCount);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
