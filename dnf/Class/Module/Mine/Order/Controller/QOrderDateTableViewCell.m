//
//  QOrderDateTableViewCell.m
//  dnf
//
//  Created by wake on 2016/11/22.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "QOrderDateTableViewCell.h"

@interface QOrderDateTableViewCell()

@end

@implementation QOrderDateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)onDateButtonAction:(UIButton *)sender {
    if (self.DateSelectBlock) {
        self.DateSelectBlock(sender.selected, sender.tag);
    }
}


@end
