//
//  QLOLAccountViewController.m
//  dnf
//
//  Created by wake on 2016/11/3.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "QLOLAccountViewController.h"
#import "QLOLAccountEditViewController.h"

@interface QLOLAccountViewController ()

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation QLOLAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.dataArray = [[NSMutableArray alloc] initWithArray: [QLOLAccount sectionArray]];
    
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    QLOLAccountList *list = [self.dataArray objectAtIndex:section];
    return (list.children.count > 0) ? list.children.count : 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    QLOLAccountList *list = [self.dataArray objectAtIndex:section];
    return list.section;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellid];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    QLOLAccountList *list = [self.dataArray objectAtIndex:indexPath.section];
    if (list.children.count>0) {
        QLOLAccountAreaNickname *area = [list.children objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageNamed:@"Avatar"];
        cell.textLabel.text = area.nickname;
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.detailTextLabel.text = [QAssets searchResultsWithIds:area.aid.stringValue];
    }else{
        cell.textLabel.text = @"修改帐号";
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QLOLAccountEditViewController *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([QLOLAccountEditViewController class])];
    ctrl.title = @"修改帐号";
    QLOLAccountList *list = [self.dataArray objectAtIndex:indexPath.section];
    ctrl.lolAccount = list.parent;
    ctrl.areaNickname = (list.children.count > 0) ? [list.children objectAtIndex:indexPath.row] : nil;
    [self.navigationController pushViewController:ctrl animated:YES];
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    QLOLAccountList *list = [self.dataArray objectAtIndex:indexPath.section];
//    QLOLAccount *lolAccount = [list.children objectAtIndex:indexPath.row];
//    [QLOLAccount deleteWithAccountId:lolAccount.id];
//    [[RLMRealm defaultRealm] transactionWithBlock:^{
////        [[RLMRealm defaultRealm] deleteObject:lolAccount];
//        
//       NSLog(@"%@", [QLOLAccount allObjects]);
//
//        if (list.children.count>1) {
//            [list.children removeObjectAtIndex:indexPath.row];
//            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        }else{
//             [self.dataArray removeObjectAtIndex:indexPath.section];
//            NSIndexSet *sets = [NSIndexSet indexSetWithIndex:indexPath.section];
//            [self.tableView deleteSections:sets withRowAnimation:UITableViewRowAnimationFade];
//        }
//        
//        
//    }];
//}

//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return @"删除";
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *ctrl = segue.destinationViewController;
    ctrl.title = @"添加帐号";
}

@end
