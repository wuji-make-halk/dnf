//
//  QMessageViewController.h
//  dnf
//
//  Created by wake on 2016/11/12.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "EaseConversationListViewController.h"

@interface QMessageViewController : EaseConversationListViewController

@property (strong, nonatomic) NSMutableArray *conversationsArray;

- (void)refresh;
- (void)refreshDataSource;

- (void)isConnect:(BOOL)isConnect;

@end
