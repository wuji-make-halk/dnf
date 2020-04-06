//
//  QBaseTableViewController.m
//  dnf
//
//  Created by wake on 2016/9/27.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "QBaseTableViewController.h"

@interface QBaseTableViewController ()

@end

@implementation QBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
//    self.tableView.tableFooterView = [UIView new];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self viewHasTouched];
}

- (void)addTapEndEditGestureRecognizer
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewHasTouched)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewHasTouched {
    [self.view endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self viewHasTouched];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
