//
//  Q2ViewController.m
//  dnf
//
//  Created by 张伟 on 16/10/4.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "Q2ViewController.h"

@interface Q2ViewController ()

@end

@implementation Q2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"参与竞选" style:UIBarButtonItemStylePlain target:nil action:nil];
    item.width = CGRectGetWidth([UIScreen mainScreen].bounds);
    [item setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:18]} forState:UIControlStateNormal];
    
    self.toolbarItems = @[
                          [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                          item,
                          [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]
                          ];

}

@end
