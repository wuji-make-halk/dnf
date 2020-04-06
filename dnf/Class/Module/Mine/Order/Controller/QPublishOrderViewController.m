//
//  QPublishOrderViewController.m
//  dnf
//
//  Created by wake on 2016/11/22.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "QPublishOrderViewController.h"
#import "QOrderDateTableViewCell.h"

@interface QPublishOrderViewController ()
@property (nonatomic, assign)BOOL toggleState;
@property (nonatomic, assign)NSInteger switchTag;

@end

@implementation QPublishOrderViewController

+ (instancetype)instanceViewController
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"QOrder" bundle:[NSBundle mainBundle]];
    return [storyBoard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.switchTag = 0;
    self.toggleState = NO;
    
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [super tableView:tableView titleForHeaderInSection:section];
}

- (NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return [super tableView:tableView titleForFooterInSection:section];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [super tableView:tableView heightForHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [super tableView:tableView heightForFooterInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.toggleState) {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }else{
        if (indexPath.section == 1 && indexPath.row == 1) {
            return 0;
        }else{
            return [super tableView:tableView heightForRowAtIndexPath:indexPath];
        }
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [super tableView:tableView viewForFooterInSection:section];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [super tableView:tableView viewForHeaderInSection:section];
}

-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1 && indexPath.row ==0){
        QOrderDateTableViewCell *cell = [QOrderDateTableViewCell initCell];
        cell.DateSelectBlock = ^(BOOL select, NSInteger tag)
        {
            [self showSelectDate:nil withTag:tag];
        };
        return cell;
    }else{
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 1) {
    }
}

- (void)showSelectDate:(NSDate *)date withTag:(NSInteger)tag
{
    NSLog(@"%ld---%ld /// %d", (long)self.switchTag, (long)tag, self.toggleState);
    
    if ((self.switchTag == tag || self.switchTag==0) || (self.switchTag != tag && !self.toggleState)) {
        self.toggleState = !self.toggleState;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
    }
  
    self.switchTag = tag;
}

@end
