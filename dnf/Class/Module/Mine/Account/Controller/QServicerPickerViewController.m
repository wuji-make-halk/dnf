//
//  QServicerPickerViewController.m
//  dnf
//
//  Created by wake on 2016/10/19.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "QServicerPickerViewController.h"
#import "QServicerPickerTableViewCell.h"
#import "QServicerPickerTableFooter.h"


static NSString *cellid = @"cellid";

@interface QServicerPickerViewController ()

@property (nonatomic, strong) NSArray *listArray;

@property (nonatomic, strong) NSMutableArray *selectArray;
@end

@implementation QServicerPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectArray = [[NSMutableArray alloc] initWithArray:self.selectIds.length>0 ? [self.selectIds componentsSeparatedByString:@","] : @[]];
    
    self.listArray = [QAssets resultsWith:self.type section:self.section];
    
    [self.tableView reloadData];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if (self.single || self.hidePickerTabelFooter) {
        
        return nil;
        
    }else{
    
        QServicerPickerTableFooter *pickerTabelFooter = [QServicerPickerTableFooter instanceView];
        
        if (self.section) {
            
            QAssetsList *list = [self.listArray objectAtIndex:section];
            
            NSInteger astCount = 0;
            
            for (QAssets *ast in list.children) {
                if ([self.selectArray containsObject:ast.id.stringValue]) {
                    astCount++;
                }
            }
            
            if (astCount == list.children.count && astCount>0) {
                [pickerTabelFooter setSwitchOn:YES];
            }else{
                [pickerTabelFooter setSwitchOn:NO];
            }
            
        }else{
            if (self.selectArray.count == self.listArray.count && self.selectArray.count>0) {
                [pickerTabelFooter setSwitchOn:YES];
            }else{
                [pickerTabelFooter setSwitchOn:NO];
            }
        }

        pickerTabelFooter.checkAll = ^(BOOL check){
            if (check) {
                if (self.section) {
                    QAssetsList *list = [self.listArray objectAtIndex:section];
                    
                    if ([self.selectArray containsObject:list.parent.id.stringValue]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.selectArray removeObject:list.parent.id.stringValue];
                        });
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        for (QAssets *ast in list.children) {
                            [self.selectArray addObject:ast.id.stringValue];
                        }
                    });
                }else{
                    [self.selectArray removeAllObjects];
                    for (QAssetsList *ast in self.listArray) {
                        [self.selectArray addObject:ast.parent.id.stringValue];
                    }
                }
            }else{
                if (self.section) {
                    QAssetsList *list = [self.listArray objectAtIndex:section];
                    for (QAssets *ast in list.children) {
                        if ([self.selectArray containsObject:ast.id.stringValue]) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.selectArray removeObject:ast.id.stringValue];
                            });
                        }
                    }
                }else{
                    [self.selectArray removeAllObjects];
                }
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        };
        return pickerTabelFooter;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return self.single ? 18 : 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.section ? self.listArray.count : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    QAssetsList *list = [self.listArray objectAtIndex:section];
    return  self.section ? list.children.count : self.listArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    QAssetsList *list = [self.listArray objectAtIndex:section];
    return  self.section ? list.parent.name : @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QServicerPickerTableViewCell *cell = [QServicerPickerTableViewCell instanceCell];
    
    QAssets *ast;
    
    if (self.section) {
        QAssetsList *list = [self.listArray objectAtIndex:indexPath.section];
        ast = [list.children objectAtIndex:indexPath.row];
        
        if (indexPath.row == list.children.count-1) {
            cell.lineLeading.constant = 0;
        }
        if (indexPath.row == 0) {
            cell.topLine.hidden = NO;
        }
    }else{
        QAssetsList *list = [self.listArray objectAtIndex:indexPath.row];
        ast = list.parent;
        
        if (indexPath.row == self.listArray.count-1) {
            cell.lineLeading.constant = 0;
        }
        
        if (indexPath.row == 0) {
            cell.topLine.hidden = NO;
        }
    }
    
    cell.textLabel.text = self.type == QServicerPickerLevel ? ast.alias : ast.name;
    
    if ([self.selectArray containsObject:ast.id.stringValue]) {
        cell.checked.hidden = NO;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    QAssets *ast;
    if (self.section) {
        QAssetsList *list = [self.listArray objectAtIndex:indexPath.section];
        ast = [list.children objectAtIndex:indexPath.row];
    }else{
        QAssetsList *list = [self.listArray objectAtIndex:indexPath.row];
        ast = list.parent;
    }
    
    if (self.single) {
        
        [self.selectArray removeAllObjects];
        [self.selectArray addObject:ast.id.stringValue];
        
        [self onSelect:nil];
        
    }else{
        if ([self.selectArray containsObject:ast.id.stringValue]) {
            [self.selectArray removeObject:ast.id.stringValue];
        }else{
            [self.selectArray addObject:ast.id.stringValue];
        }
    }
    [self.tableView reloadData];
}

- (IBAction)onSelect:(id)sender {
    self.PickerSelectBlock([self.selectArray componentsJoinedByString:@","]);
    [self.navigationController popViewControllerAnimated:YES];
}

@end
