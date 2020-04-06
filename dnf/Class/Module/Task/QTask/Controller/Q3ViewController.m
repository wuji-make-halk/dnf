//
//  Q3ViewController.m
//  dnf
//
//  Created by 张伟 on 16/10/4.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "Q3ViewController.h"

@interface Q3ViewController ()

@end

@implementation Q3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"参与竞价" style:UIBarButtonItemStylePlain target:nil action:nil];
    item.width = CGRectGetWidth([UIScreen mainScreen].bounds);
    [item setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:18]} forState:UIControlStateNormal];
    
    self.toolbarItems = @[
                          [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                          item,
                          [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]
                          ];
}

@end
