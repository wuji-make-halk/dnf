//
//  QServicerPickerTableViewCell.h
//  dnf
//
//  Created by wake on 2016/10/26.
//  Copyright © 2016年 wake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QServicerPickerTableViewCell : QBaseTableViewCell

+ (instancetype)instanceCell;

@property (weak, nonatomic) IBOutlet UIImageView *checked;

@property (weak, nonatomic) IBOutlet UIView *line;

@property (weak, nonatomic) IBOutlet UIView *topLine;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLeading;
@end
