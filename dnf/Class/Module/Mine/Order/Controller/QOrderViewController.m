//
//  QOrderViewController.m
//  dnf
//
//  Created by wake on 2016/9/27.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "QOrderViewController.h"

@interface QOrderViewController ()

@property (nonatomic, strong) UIBarButtonItem *seg;
@property (nonatomic, strong) UIBarButtonItem *segs;



@end

@implementation QOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTools:self.segs];
    
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

- (void)setTools:(UIBarButtonItem *)item
{
     [self setToolbarItems:@[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], item, [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]] animated:YES];
}

- (IBAction)onToggleAction:(id)sender {
    
}

- (UIBarButtonItem *)seg
{
    if (!_seg) {
        UISegmentedControl *item = [[UISegmentedControl alloc] initWithItems:@[@"全部", @"已发布", @"已开始", @"已结束"]];
        item.selectedSegmentIndex = 0;
        item.tintColor = [UIColor colorWithRed:0.27 green:0.76 blue:0.98 alpha:1];
        UIBarButtonItem *it = [[UIBarButtonItem alloc] initWithCustomView:item];
        it.width = CGRectGetWidth(self.navigationController.toolbar.frame)-20;
        return it;
    }
    return _seg;
}

- (UIBarButtonItem *)segs
{
    if (!_segs) {
        UISegmentedControl *item = [[UISegmentedControl alloc] initWithItems:@[@"全部", @"已开始", @"已结束"]];
        item.selectedSegmentIndex = 0;
        item.tintColor = [UIColor colorWithRed:0.27 green:0.76 blue:0.98 alpha:1];
        UIBarButtonItem *it = [[UIBarButtonItem alloc] initWithCustomView:item];
        it.width = CGRectGetWidth(self.navigationController.toolbar.frame)-20;
        return it;
    }
    return _segs;
}

- (IBAction)segAction:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        [self setTools:self.segs];
    }else{
        [self setTools:self.seg];
    }
}
@end
