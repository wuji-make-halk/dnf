//
//  QServicerPickerViewController.h
//  dnf
//
//  Created by wake on 2016/10/19.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "QBaseTableViewController.h"

@interface QServicerPickerViewController : QBaseTableViewController

@property (nonatomic, assign) QServicerPickerType type;

@property (nonatomic, assign) BOOL single;

@property (nonatomic, assign) BOOL section;

@property (nonatomic, strong) NSString *selectIds;

@property (nonatomic, assign) BOOL hidePickerTabelFooter;

@property (nonatomic, strong) void(^PickerSelectBlock) (NSString *results);

@end
