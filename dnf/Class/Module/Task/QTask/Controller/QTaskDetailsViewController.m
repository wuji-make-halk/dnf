//
//  QTaskDetailsViewController.m
//  dnf
//
//  Created by wake on 2016/9/30.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "QTaskDetailsViewController.h"

@interface QTaskDetailsViewController ()<UIScrollViewDelegate>

@property (nonatomic, assign)NSInteger currentPage;

@end

@implementation QTaskDetailsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentPage = 0;
    
    [self setToolbarItems:self.childViewControllers[self.currentPage].toolbarItems animated:YES];
    
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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.currentPage = scrollView.contentOffset.x / CGRectGetWidth([UIScreen mainScreen].bounds);
    
    [self setToolbarItems:self.childViewControllers[self.currentPage].toolbarItems animated:YES];
    

}

@end
