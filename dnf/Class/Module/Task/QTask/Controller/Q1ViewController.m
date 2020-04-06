//
//  Q1ViewController.m
//  dnf
//
//  Created by 张伟 on 16/10/4.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "Q1ViewController.h"

@interface Q1ViewController ()

@end

@implementation Q1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"立即抢单" style:UIBarButtonItemStylePlain target:nil action:nil];
    item.width = CGRectGetWidth([UIScreen mainScreen].bounds);
    [item setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:18]} forState:UIControlStateNormal];
    
    self.toolbarItems = @[
                          [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                          item,
                          [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]
                          ];
}


@end
