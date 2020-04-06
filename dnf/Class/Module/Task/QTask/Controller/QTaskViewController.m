//
//  QTaskViewController.m
//  dnf
//
//  Created by wake on 2016/9/26.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "QTaskViewController.h"
#import "QTaskTableViewCell.h"

@interface QTaskViewController ()

@end

@implementation QTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QTaskTableViewCell *cell = [QTaskTableViewCell initCell];
    [cell setArrays:@[@"定位赛"]];
    [cell setArray:@[@"黄铜1(20胜点) / 黄金5(6段2阶)"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self performSegueWithIdentifier:@"desc" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"¥ 70.00";
    self.navigationItem.backBarButtonItem = backItem;
}


@end
