//
//  QServicerPickerTableFooter.h
//  dnf
//
//  Created by wake on 2016/10/27.
//  Copyright © 2016年 wake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QServicerPickerTableFooter : UIView

@property (strong, nonatomic) void(^checkAll)(BOOL check);

@property (weak, nonatomic) IBOutlet UISwitch *switchButton;

+ (instancetype)instanceView;

- (void)setSwitchOn:(BOOL)on;

- (void)setSwitchEnable:(BOOL)enable;

@end
