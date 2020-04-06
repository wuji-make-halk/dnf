//
//  QServicerDetailsViewController.m
//  dnf
//
//  Created by wake on 2016/9/29.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "QServicerDetailsViewController.h"

#define HeadViewHeight 150 // 头视图高度
#define SuspensionViewHeight 44 // 悬浮视图高度
#define HeadViewMinHeight 64 // HeadView最小高度

@interface QServicerDetailsViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *item;

/** HeadView高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headHeightCons;

/** 记录滚动视图最开始偏移量y值 */
@property (nonatomic, assign) CGFloat oriOffsetY;

@property (nonatomic, weak) UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;

@end

@implementation QServicerDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航条
//    [self setUpNavigationBar];
    
    
    // 不需要自动调节滚动区域
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.item setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Bold" size:15]} forState:UIControlStateNormal];
    
    self.title = self.userServicer.nickname;
    [self.avatar sd_setImageWithURL:[QAliyunOSS avatarUrl:self.userServicer.uid.stringValue] placeholderImage:nil options:SDWebImageRefreshCached];
    NSLog(@"%@", self.userServicer.nickname);
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

/** 设置导航栏 */
- (void)setUpNavigationBar {
    // 传递一个空的UIImage,选择模式为UIBarMetricsDefault来设置导航栏背景为透明, 注意UIImage不能传nil, 如果传nil, 苹果会为你加载一张默认的不透明背景图片
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    // 清空导航条的阴影的线
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    // 设置导航条标题为透明
    UILabel *usernameLabel = [[UILabel alloc] init];
    usernameLabel.text = self.userServicer.nickname;
    // 设置文字的颜色
    usernameLabel.textColor = [UIColor blackColor];
    // 根据文字大小自适应尺寸
    [usernameLabel sizeToFit];
    _userNameLabel = usernameLabel;
    
    [self.navigationItem setTitleView:_userNameLabel];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.27 green:0.76 blue:0.98 alpha:1];
}

- (IBAction)sendMessage:(id)sender {
    QChatViewController *chatController = [[QChatViewController alloc]
                                           initWithConversationChatter:self.userServicer.uuid conversationType:EMConversationTypeChat];
    
    NSLog(@"%@----%@", self.userServicer.uuid, self.userServicer.nickname);
    chatController.title = self.userServicer.nickname;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:chatController animated:YES];
}


@end
