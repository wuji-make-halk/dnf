//
//  QServicerSetViewController.m
//  dnf
//
//  Created by wake on 2016/10/19.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "QServicerSetViewController.h"
#import "QServicerPickerViewController.h"

@interface QServicerSetViewController ()

@property (strong, nonatomic) IBOutlet UISwitch *switchShow;

@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *cells;

@property (nonatomic, strong) NSString *formatSelectedResults;
@property (nonatomic, strong) NSString *levelSelectedResults;
@property (nonatomic, strong) NSString *areaSelectedResults;
@property (nonatomic, strong) NSString *positionSelectedResults;

@end



@implementation QServicerSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.switchShow.on = [QUserServicer current].enable;
    self.formatSelectedResults = [QUserServicer current].format;
    self.levelSelectedResults = [QUserServicer current].level;
    self.areaSelectedResults = [QUserServicer current].area;
    self.positionSelectedResults = [QUserServicer current].position;
    
    [self.cells enumerateObjectsUsingBlock:^(UITableViewCell *cell, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *result;
        switch (idx) {
            case 0:
                result = self.formatSelectedResults;
                break;
            case 1:
                result = self.levelSelectedResults;
                break;
            case 2:
                result = self.areaSelectedResults;
                break;
            case 3:
                result = self.positionSelectedResults;
                break;
            default:
                result = @"";
                break;
        }
        
        cell.detailTextLabel.text = [QAssets searchResultsWithIds:result];
        
        [self setDetailTextWithCell:cell results:result];
    }];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)sender
{
    QServicerPickerViewController *picker = segue.destinationViewController;
    picker.type = [segue.identifier integerValue];
    picker.title = sender.textLabel.text;
    
    if (picker.type == QServicerPickerFormat) {
        picker.selectIds = self.formatSelectedResults;
    }else if (picker.type == QServicerPickerLevel){
        picker.selectIds = self.levelSelectedResults;
    }else if(picker.type == QServicerPickerAREA){
        picker.selectIds = self.areaSelectedResults;
//        picker.section = YES;
    }else if(picker.type == QServicerPickerPosition){
        picker.selectIds = self.positionSelectedResults;
    }

    picker.PickerSelectBlock = ^(NSString *results){
        
        if ([segue.identifier integerValue] == QServicerPickerFormat) {
            self.formatSelectedResults = results;
        }else if ([segue.identifier integerValue] == QServicerPickerLevel){
            self.levelSelectedResults = results;
        }else if([segue.identifier integerValue] == QServicerPickerAREA){
            self.areaSelectedResults = results;
        }else if([segue.identifier integerValue] == QServicerPickerPosition){
            self.positionSelectedResults = results;
        }
        
        sender.detailTextLabel.text = [QAssets searchResultsWithIds:results];
        
        [self setDetailTextWithCell:sender results:results];
    };
}

- (void)setDetailTextWithCell:(UITableViewCell *)cell results:(NSString *)results
{
    NSInteger count = [QAssets serchCountWithIds:results];
    if (count > 0) {
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    }else{
        cell.detailTextLabel.textColor = [UIColor redColor];
    }
}

- (IBAction)saveAction:(id)sender {
    
    QRequestUpdateServicer *request= [[QRequestUpdateServicer alloc] init];
    request.enable = self.switchShow.on;
    request.format = self.formatSelectedResults;
    request.level = self.levelSelectedResults;
    request.area = self.areaSelectedResults;
    request.position = self.positionSelectedResults;
    
    [QAPIClient servicerUpdateWithParams:request success:^(QResponseUpdateServicer *response) {
        if (response.code == kResponseSuccess) {
            
            [[RLMRealm defaultRealm] transactionWithBlock:^{
                [QUserServicer current].enable = self.switchShow.on;
                [QUserServicer current].format = self.formatSelectedResults;
                [QUserServicer current].level = self.levelSelectedResults;
                [QUserServicer current].area = self.areaSelectedResults;
                [QUserServicer current].position = self.positionSelectedResults;
            }];

            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showTip:response.msg];
        }
    } failure:^(NSError *error) {
        
    }];
    
}



@end
