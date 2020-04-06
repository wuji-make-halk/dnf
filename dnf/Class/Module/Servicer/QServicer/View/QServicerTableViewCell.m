//
//  QServicerTableViewCell.m
//  dnf
//
//  Created by wake on 2016/9/28.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "QServicerTableViewCell.h"
#import "QBaseLabel.h"

@interface QServicerTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *format;
@property (weak, nonatomic) IBOutlet UILabel *level;

@end

@implementation QServicerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setUserServicer:(QUserServicer *)userServicer
{
    [self.avatar sd_setImageWithURL:[QAliyunOSS avatarUrl:userServicer.uid.stringValue] placeholderImage:nil options:SDWebImageRefreshCached];
    self.nickname.text = userServicer.nickname;
    self.format.text = [QAssets searchResultsWithIds:userServicer.format];
    self.level.text = [QAssets searchResultsWithIds:userServicer.level];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
}

@end
