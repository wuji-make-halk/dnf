//
//  QTaskTableViewCell.m
//  dnf
//
//  Created by 张伟 on 16/9/29.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "QTaskTableViewCell.h"

@interface QTaskTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *level;
@end

@implementation QTaskTableViewCell



- (void)awakeFromNib {
    [super awakeFromNib];
    self.nickname.textColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.502 alpha:1.0];
    [self setLevelBackgroundColor];
}

- (void)setArrays:(NSArray *)arr
{
    
//    NSLog(@"%@", arr);
    for (int i=0; i<arr.count; i++) {
        NSString *str = [arr objectAtIndex:i];
        
        CGFloat width = [self widthForString:str fontSize:12 andHeight:20];
        
//        NSLog(@"width: %f", width);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*width+i*5, 0, width, 20)];
        //        label.backgroundColor = [UIColor orangeColor];
        //        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        label.text = str;
        //        label.layer.cornerRadius = 3;
        //        label.clipsToBounds = YES;
        [self.view1 addSubview:label];
        
    }
}

- (void)setArray:(NSArray *)arr
{
    
//    NSLog(@"%@", arr);
    for (int i=0; i<arr.count; i++) {
        NSString *str = [arr objectAtIndex:i];
        
        CGFloat width = [self widthForString:str fontSize:12 andHeight:20];
        
//        NSLog(@"width: %f", width);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*width+i*5, 0, width, 20)];
        //        label.backgroundColor = [UIColor purpleColor];
        label.textColor = [UIColor colorWithRed:0.298 green:0.298 blue:0.298 alpha:1.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        label.text = str;
        //        label.layer.cornerRadius = 3;
        //        label.layer.borderColor = [UIColor purpleColor].CGColor;
        //        label.layer.borderWidth = 0.5;
        //        label.clipsToBounds = YES;
        [self.view2 addSubview:label];
        
    }
}

-(float) widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(CGFLOAT_MAX, height) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self setLevelBackgroundColor];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    [self setLevelBackgroundColor];
}

- (void)setLevelBackgroundColor
{
    self.level.backgroundColor = [UIColor colorWithRed:0.22 green:0.76 blue:0.99 alpha:1.0];
}

@end
