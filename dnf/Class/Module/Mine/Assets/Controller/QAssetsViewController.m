//
//  QAssetsViewController.m
//  dnf
//
//  Created by wake on 2016/9/26.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "QAssetsViewController.h"

@interface QAssetsViewController ()

@end

@implementation QAssetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

@end
