//
//  QServicerViewController.m
//  dnf
//
//  Created by wake on 2016/9/26.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "QServicerViewController.h"
#import "QServicerTableViewCell.h"
#import "QServicerDetailsViewController.h"
#import "QPublishOrderViewController.h"

@interface QServicerViewController ()

@property (nonatomic, strong)NSArray *dataArray;

@end

@implementation QServicerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.tableFooterView = [UIView new];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    QRequestData *request = [[QRequestData alloc] init];
    [QAPIClient servicerListWithParams:request success:^(QResponseServicerList *response) {
        if (response.code == kResponseSuccess) {
            self.dataArray = response.result;
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
    
//    UIStoryboard *board = [UIStoryboard storyboardWithName:@"QMine" bundle:[NSBundle mainBundle]];
//    [self.navigationController presentViewController:[board instantiateViewControllerWithIdentifier:@"test"] animated:YES completion:^{
//        
//    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QServicerTableViewCell *cell = [QServicerTableViewCell initCell];
    [cell setUserServicer:[self.dataArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UIStoryboard *board = [UIStoryboard storyboardWithName:@"QServicer" bundle:[NSBundle mainBundle]];
    QServicerDetailsViewController *details = [board instantiateViewControllerWithIdentifier:@"QServicerDetailsViewController"];
    details.userServicer = [self.dataArray objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:details animated:YES];
  
}

@end
