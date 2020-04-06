//
//  QBaseNavigationController.m
//  dnf
//
//  Created by wake on 2016/9/26.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "QBaseNavigationController.h"

@interface QBaseNavigationController ()

@end

@implementation QBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[UIColor colorWithRed:0.27 green:0.76 blue:0.98 alpha:1]
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    [navigationBarAppearance setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithRed:0.27 green:0.76 blue:0.98 alpha:1]] forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setShadowImage:[UIImage new]];
    [navigationBarAppearance setBarTintColor:[UIColor whiteColor]];
    [navigationBarAppearance setBarStyle:UIBarStyleDefault];
    [navigationBarAppearance setTintColor:[UIColor whiteColor]];
    [navigationBarAppearance setTranslucent:NO];
    
    [navigationBarAppearance setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    //    [navigationBarAppearance setBackgroundColor:[UIColor colorWithRed:0.27 green:0.76 blue:0.98 alpha:1]];
    
    [[UIToolbar appearance] setBackgroundImage:[UIImage new] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [[UIToolbar appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UIToolbar appearance] setShadowImage:[UIImage imageNamed:@"tabbar_top_line"] forToolbarPosition:UIBarPositionAny];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}


@end
