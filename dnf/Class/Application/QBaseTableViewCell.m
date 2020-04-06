//
//  QBaseTableViewCell.m
//  dnf
//
//  Created by wake on 2016/9/28.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "QBaseTableViewCell.h"

@implementation QBaseTableViewCell

+ (instancetype)initCell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
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
