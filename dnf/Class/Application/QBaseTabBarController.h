//
//  QBaseTabBarController.h
//  dnf
//
//  Created by wake on 2016/9/26.
//  Copyright © 2016年 wake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

@interface QBaseTabBarController : UITabBarController

- (void)jumpToChatList;

- (void)didReceiveLocalNotification:(UILocalNotification *)notification;

- (void)didReceiveUserNotification:(UNNotification *)notification;

@end
