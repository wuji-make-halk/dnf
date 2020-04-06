//
//  QBaseTabBarController.m
//  dnf
//
//  Created by wake on 2016/9/26.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "QBaseTabBarController.h"
#import "QBaseNavigationController.h"
#import "QMineViewController.h"

//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kGroupName = @"GroupName";

@interface QBaseTabBarController ()<UITabBarControllerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSArray *tabBarItemsAttributes;

@property (strong, nonatomic) NSDate *lastPlaySoundDate;

@end

@implementation QBaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    [self setupTabBarItems];
    
    [self customizeTabBarAppearance];
    
    addObs(kSetupUnreadMessageCount, setupUnreadMessageCount);
    
    addObs(QTTabBarSelect, selectToTabBarItem:);
    
    addObs(QSginStateObs, onSignState:);
    
    [self setupUnreadMessageCount];
}

- (void)setupTabBarItems
{
    for (int i=0; i<self.viewControllers.count; i++) {
        QBaseNavigationController *nav = [self.viewControllers objectAtIndex:i];
        nav.topViewController.title = [self.tabBarItemsAttributes objectAtIndex:i][@"title"];
        nav.tabBarItem.title = [self.tabBarItemsAttributes objectAtIndex:i][@"title"];
        nav.tabBarItem.image = [UIImage imageNamed:[self.tabBarItemsAttributes objectAtIndex:i][@"image"]];
        nav.tabBarItem.selectedImage = [UIImage imageNamed:[self.tabBarItemsAttributes objectAtIndex:i][@"selectImage"]];
        nav.tabBarItem.tag = [[[self.tabBarItemsAttributes objectAtIndex:i] objectForKey:@"type"] integerValue];
    }
}

- (NSArray *)tabBarItemsAttributes
{
    if (!_tabBarItemsAttributes) {
        _tabBarItemsAttributes = @[
                                   @{
                                       @"name" : @"QServicer",
                                       @"title" : @"代练",
                                       @"image" : @"Conference",
                                       @"selectImage" : @"Conference",
                                       @"type" : @(QTabBarItemServicer)
                                       },
                                   @{
                                       @"name" : @"QTask",
                                       @"title" : @"订单",
                                       @"image" : @"Torah",
                                       @"selectImage" : @"Torah",
                                       @"type" : @(QTabBarItemTask)
                                    },
                                   @{
                                       @"name" : @"QMine",
                                       @"title" : @"我的",
                                       @"image" : @"User Menu Male",
                                       @"selectImage" : @"User Menu Male",
                                       @"type" : @(QTabBarItemMine)
                                       },
                                   ];
    }
    return _tabBarItemsAttributes;
}

- (void)customizeTabBarAppearance
{
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UITabBar appearance] setShadowImage:[UIImage imageNamed:@"tabbar_top_line"]];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (viewController.tabBarItem.tag == QTabBarItemMine && ![QUser checkSign]) {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"QSign" bundle:[NSBundle mainBundle]];
        [self presentViewController:board.instantiateInitialViewController animated:YES completion:nil];
        return NO;
    }else{
        return YES;
    }
}

- (void)selectToTabBarItem:(NSNotification *)notification;
{
    self.selectedIndex = [notification.object integerValue];
}


- (void)onSignState:(NSNotification *)notification
{
    NSInteger state = [notification.object integerValue];
    
    switch (state) {
        case QSignInState:
            NSLog(@"QSignInState");
            break;
        case QSignUpState:
            NSLog(@"QSignUpState");
            break;
        case QSignOutState:
        case QSignTimeoutSate:
            
            NSLog(@"QSignOutState , QSignTimeoutSate");
            
            [QUser signOut];
            [self.tabBar hideBadgeOnItemIndex:QTabBarItemMine];
            self.selectedIndex = QTabBarItemServicer;
            break;
        default:
            break;
    }
}



// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    QBaseNavigationController *nav = [self.viewControllers objectAtIndex:QTabBarItemMine];
    if (unreadCount > 0) {
        [self.tabBar showBadgeOnItemIndex:QTabBarItemMine];
        if (nav.viewControllers.count==1) {
            nav.topViewController.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)unreadCount];
        }
    }else{
        [self.tabBar hideBadgeOnItemIndex:QTabBarItemMine];
        if (nav.viewControllers.count==1) {
            nav.topViewController.navigationItem.rightBarButtonItem.badgeValue = nil;
        }
    }
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
}



#pragma mark - 自动登录回调

- (void)willAutoReconnect{
    
}

- (void)didAutoReconnectFinishedWithError:(NSError *)error{

}

#pragma mark - public

- (void)jumpToChatList
{
    
}

- (EMConversationType)conversationTypeFromMessageType:(EMChatType)type
{
    EMConversationType conversatinType = EMConversationTypeChat;
    switch (type) {
        case EMChatTypeChat:
            conversatinType = EMConversationTypeChat;
            break;
        case EMChatTypeGroupChat:
            conversatinType = EMConversationTypeGroupChat;
            break;
        case EMChatTypeChatRoom:
            conversatinType = EMConversationTypeChatRoom;
            break;
        default:
            break;
    }
    return conversatinType;
}

- (void)didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo)
    {
    }
}

- (void)didReceiveUserNotification:(UNNotification *)notification
{
    NSDictionary *userInfo = notification.request.content.userInfo;
    if (userInfo)
    {
    }
}

@end
