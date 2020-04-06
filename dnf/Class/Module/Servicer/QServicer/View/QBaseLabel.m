//
//  QBaseLabel.m
//  dnf
//
//  Created by wake on 2016/9/28.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "QBaseLabel.h"

@implementation QBaseLabel

- (id)initWithFrame:(CGRect)frame text:(NSString *)text
{
    self = [super initWithFrame:frame];
    if (!self) {
        self.text = @"xxxxxx";
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(3, 3)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = self.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
