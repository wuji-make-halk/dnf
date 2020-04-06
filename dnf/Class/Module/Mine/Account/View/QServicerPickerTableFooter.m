//
//  QServicerPickerTableFooter.m
//  dnf
//
//  Created by wake on 2016/10/27.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "QServicerPickerTableFooter.h"

@implementation QServicerPickerTableFooter

+ (instancetype)instanceView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (IBAction)selectAll:(UISwitch *)sender {
    self.checkAll(sender.on);
}

- (void)setSwitchOn:(BOOL)on
{
    self.switchButton.on = on;
}

- (void)setSwitchEnable:(BOOL)enable
{
    self.switchButton.enabled = enable;
}

@end
