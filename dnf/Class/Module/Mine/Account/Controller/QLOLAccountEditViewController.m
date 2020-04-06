//
//  QLOLAccountEditViewController.m
//  dnf
//
//  Created by wake on 2016/11/3.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "QLOLAccountEditViewController.h"
#import "QServicerPickerViewController.h"
#import "QLOLAccountEditTableViewCell.h"


@interface QLOLAccountEditViewController ()
@property (weak, nonatomic) IBOutlet UITableViewCell *cell;
@property (nonatomic, strong) NSString *areaSelectedResults;
@property (nonatomic, strong) NSString *nicknameSelectedResults;
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (nonatomic, strong) NSMutableArray *cells;
@property (nonatomic, strong) NSMutableArray *ares;
@end

@implementation QLOLAccountEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.lolAccount) {
        self.areaSelectedResults = self.lolAccount.area;
        self.nicknameSelectedResults = self.lolAccount.nickname;
        
        NSLog(@"当前昵称为: %@", self.nicknameSelectedResults);
        
        self.account.text = self.lolAccount.account;
        self.password.text = self.lolAccount.password;
        [self setDetailTextWithCell:self.cell results:self.lolAccount.area];
    }
    
    self.cells = [[NSMutableArray alloc] init];
    
    self.ares = [[NSMutableArray alloc] initWithArray:[QLOLAccountAreaNickname mj_objectArrayWithKeyValuesArray:self.nicknameSelectedResults]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (IBAction)onTogglePassword:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.password setSecureTextEntry:NO];
    }else{
        [self.password setSecureTextEntry:YES];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)sender
{
    QServicerPickerViewController *picker = segue.destinationViewController;
    picker.type = [segue.identifier integerValue];
    picker.title = @"选择大区";
    picker.section = YES;
    picker.hidePickerTabelFooter = YES;
    picker.selectIds = self.areaSelectedResults;
    
    picker.PickerSelectBlock = ^(NSString *results){
        [self.cells removeAllObjects];
        self.areaSelectedResults = results;
        [self setDetailTextWithCell:self.cell results:results];
        [self.tableView reloadData];
    };
    
}

- (void)setDetailTextWithCell:(UITableViewCell *)cell results:(NSString *)results
{
    cell.textLabel.text = [QAssets searchResultsWithIds:results];
    NSInteger count = [QAssets serchCountWithIds:results];
    if (count > 0) {
        cell.textLabel.textColor = [UIColor blackColor];
    }else{
        cell.textLabel.textColor = [UIColor lightGrayColor];
    }
}

- (IBAction)saveAction:(id)sender {
    
    NSLog(@"%@", self.areaSelectedResults);
    
    if (!self.areaSelectedResults || [self.areaSelectedResults isEqualToString:@""] || [self.account.text isEqualToString:@""] || [self.password.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请填写完整信息"];
        return;
    }
    
    if ([self getNullCellArea]) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"请填写 %@ 的昵称", [self getNullCellArea]]];
        return;
    }
    
    [self viewHasTouched];
    
    self.nicknameSelectedResults = [[QLOLAccountAreaNickname mj_keyValuesArrayWithObjectArray:[self getCellArea]] mj_JSONString];
    
    QRequestUpdateLOLAccount *request= [[QRequestUpdateLOLAccount alloc] init];
    request.account = self.account.text;
    request.password = self.password.text;
    request.nickname = self.nicknameSelectedResults;
    request.area = self.areaSelectedResults;
    if (self.lolAccount) {
        request.id = self.lolAccount.id;
    }
    [QAPIClient lolAccountUpdateWithParams:request success:^(QResponseUpdateLOLAccount *response) {
        if (response.code == kResponseSuccess) {
            QLOLAccount *lolAcc = [[QLOLAccount alloc] init];
            lolAcc.account = self.account.text;
            lolAcc.password = self.password.text;
            lolAcc.nickname = self.nicknameSelectedResults;
            lolAcc.area = self.areaSelectedResults;
            if (self.lolAccount) {
                lolAcc.id = self.lolAccount.id;
            }else{
                lolAcc.id = response.result;
                lolAcc.uid = [QUser current].id;
            }
            [[RLMRealm defaultRealm] beginWriteTransaction];
            [QLOLAccount createOrUpdateInDefaultRealmWithValue:lolAcc];
            [[RLMRealm defaultRealm] commitWriteTransaction];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showTip:response.msg];
        }
    } failure:^(NSError *error) {
        
    }];

}

- (NSArray *)getCellArea
{
    NSMutableArray *areaArray = [[NSMutableArray alloc] init];
    for (QLOLAccountEditTableViewCell *cell in self.cells) {
        QLOLAccountAreaNickname *area = [[QLOLAccountAreaNickname alloc] init];
        area.aid = [NSNumber numberWithInteger:cell.tag];
        area.nickname = cell.nickname.text;
        [areaArray addObject:area];
    }
    return areaArray;
}

- (NSString *)getNullCellArea
{
    NSString *nullCell = nil;
    for (QLOLAccountEditTableViewCell *cell in self.cells) {
        if ([cell.nickname.text isEqualToString:@""]) {
            nullCell = cell.area.text;
            break;
        }
    }
    return nullCell;
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
    return section > 3 ? 20 : [super tableView:tableView heightForHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [super tableView:tableView heightForFooterInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section != 3){
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }else{
        return 60;
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
    if ([QAssets serchCountWithIds:self.areaSelectedResults]) {
        if (self.lolAccount) {
            return [super numberOfSectionsInTableView:tableView];
        }else{
            return [super numberOfSectionsInTableView:tableView]-1;
        }
    }else{
        return [super numberOfSectionsInTableView:tableView]-2;
    }
    
//    return ([QAssets serchCountWithIds:self.areaSelectedResults] > 0) ? [super numberOfSectionsInTableView:tableView] : [super numberOfSectionsInTableView:tableView]-1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section != 3)
    {
        return [super tableView:tableView numberOfRowsInSection:section];
    }else{
        return [QAssets serchCountWithIds:self.areaSelectedResults];
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section != 3){
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }else{

        QLOLAccountEditTableViewCell *cell = [QLOLAccountEditTableViewCell initCell];
        NSArray *arrs = [QAssets searchTArrayWithIds:self.areaSelectedResults];
        QAssets *ass = [arrs objectAtIndex:indexPath.row];
        cell.area.text =  ass.name;
        cell.tag = ass.id.integerValue;
        
        for (QLOLAccountAreaNickname *area in self.ares) {
            if ([area.aid isEqual:ass.id]) {
                cell.nickname.text = area.nickname;
                continue;
            }
        }
        
        if (![self.cells containsObject:cell]) {
            [self.cells addObject:cell];
        }
        
        if ([ass.id isEqual: self.areaNickname.aid]) {
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.lolAccount) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if([cell.textLabel.text isEqualToString:@"删除"]){
            [[LCActionSheet sheetWithTitle:@"确认删除?" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    QRequestDeleteLOLAccount *request= [[QRequestDeleteLOLAccount alloc] init];
                    request.id = self.lolAccount.id;
                    [QAPIClient lolAccountDeleteWithParams:request success:^(QResponseData *response) {
                        if (response.code == kResponseSuccess) {
                             [[RLMRealm defaultRealm] transactionWithBlock:^{
                                 [[RLMRealm defaultRealm] deleteObject:self.lolAccount];
                                 [self.navigationController popViewControllerAnimated:YES];
                             }];
                        }else{
                            [MBProgressHUD showTip:response.msg];
                        }
                    } failure:^(NSError *error) {
                    }];
                }
            } otherButtonTitles:@"删除", nil] show];
        }
    }
}

@end
