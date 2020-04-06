//
//  QServicerPickerTableViewCell.m
//  dnf
//
//  Created by wake on 2016/10/26.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "QServicerPickerTableViewCell.h"

@implementation QServicerPickerTableViewCell

+ (instancetype)instanceCell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
