//
//  QOrderDateTableViewCell.h
//  dnf
//
//  Created by wake on 2016/11/22.
//  Copyright © 2016年 wake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QOrderDateTableViewCell : QBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *startDate;
@property (weak, nonatomic) IBOutlet UILabel *startTime;

@property (weak, nonatomic) IBOutlet UILabel *endDate;
@property (weak, nonatomic) IBOutlet UILabel *endTime;

@property(nonatomic, strong) void(^DateSelectBlock)(BOOL select, NSInteger tag);

@end
