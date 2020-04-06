/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "ChatUIHelper.h"

#import "AppDelegate.h"
#import "EaseSDKHelper.h"

//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kGroupName = @"GroupName";


static ChatUIHelper *helper = nil;

@implementation ChatUIHelper

+ (instancetype)shareHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[ChatUIHelper alloc] init];
    });
    return helper;
}

- (void)dealloc
{
    [[EMClient sharedClient] removeDelegate:self];
    [[EMClient sharedClient].chatManager removeDelegate:self];
    
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initHelper];
    }
    return self;
}

#pragma mark - getter

#pragma mark - init

- (void)initHelper
{
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
}

- (void)asyncPushOptions
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        [[EMClient sharedClient] getPushOptionsFromServerWithError:&error];
    });
}

- (void)asyncConversationFromDB
{
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *array = [[EMClient sharedClient].chatManager getAllConversations];
        [array enumerateObjectsUsingBlock:^(EMConversation *conversation, NSUInteger idx, BOOL *stop){
            if(conversation.latestMessage == nil){
                [[EMClient sharedClient].chatManager deleteConversation:conversation.conversationId isDeleteMessages:NO completion:nil];
            }
        }];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (weakself.conversationListVC) {
//                [weakself.conversationListVC refreshDataSource];
//            }
//        });
    });
}

#pragma mark - EMClientDelegate

// 网络状态变化回调
- (void)didConnectionStateChanged:(EMConnectionState)connectionState
{
    self.connectionState = connectionState;
    postEventWithObject(kConnectionStateChanged, @(self.connectionState));
}

- (void)autoLoginDidCompleteWithError:(EMError *)error
{
    if (error) {
        [MBProgressHUD showTip:@"自动登录失败，请重新登录"];
    }
}

- (void)userAccountDidLoginFromOtherDevice
{
    [MBProgressHUD showTip:@"your login account has been in other places"];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

- (void)userAccountDidRemoveFromServer
{
    [MBProgressHUD showTip:@"your account has been removed from the server side"];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

- (void)userDidForbidByServer
{
    [MBProgressHUD showTip:@"Serving is banned"];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

#pragma mark - EMChatManagerDelegate

- (void)didUpdateConversationList:(NSArray *)aConversationList
{
    postEvent(kUpdateConversationList);
}

- (void)didReceiveMessages:(NSArray *)aMessages
{
//    BOOL isRefreshCons = YES;
    for(EMMessage *message in aMessages){
        
        QChatUsers *chatUser = [QChatUsers mj_objectWithKeyValues:message.ext];
        
        NSLog(@"%@", [QChatUsers mj_objectWithKeyValues:message.ext]);
        
        if (chatUser) {
            [[RLMRealm defaultRealm] beginWriteTransaction];
            [QChatUsers createOrUpdateInRealm:[RLMRealm defaultRealm] withValue:chatUser];
            [[RLMRealm defaultRealm] commitWriteTransaction];
        }
        
        BOOL needShowNotification = (message.chatType != EMChatTypeChat) ? [self _needShowNotification:message.conversationId] : YES;
        
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        if (needShowNotification) {
            switch (state) {
                case UIApplicationStateActive:
                    [self playSoundAndVibration];
                    break;
                case UIApplicationStateInactive:
                    [self playSoundAndVibration];
                    break;
                case UIApplicationStateBackground:
                    [self showNotificationWithMessage:message];
                    break;
                default:
                    break;
            }
        }
        
    }
    postEvent(kChatDidReceiveMessages);
    postEvent(kSetupUnreadMessageCount);
}


- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages
{
    for (EMMessage *message in aCmdMessages) {
        EMCmdMessageBody *cmdBody = (EMCmdMessageBody *)message.body;
        NSString *action = cmdBody.action;
        if ([action isEqualToString:@"inviteToJoinConference"]) {
//            NSString *callId = [message.ext objectForKey:@"callId"];
        } else if ([action isEqualToString:@"__Call_ReqP2P_ConferencePattern"]) {
            [MBProgressHUD showTip:@"已转为会议模式"];
        }
    }
}


#pragma mark - private
- (BOOL)_needShowNotification:(NSString *)fromChatter
{
    BOOL ret = YES;
    NSArray *igGroupIds = [[EMClient sharedClient].groupManager getGroupsWithoutPushNotification:nil];
    for (NSString *str in igGroupIds) {
        if ([str isEqualToString:fromChatter]) {
            ret = NO;
            break;
        }
    }
    return ret;
}

- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushOptions *options = [[EMClient sharedClient] pushOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    
    if (options.displayStyle == EMPushDisplayStyleMessageSummary) {
        EMMessageBody *messageBody = message.body;
        NSString *messageStr = nil;
        switch (messageBody.type) {
            case EMMessageBodyTypeText:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case EMMessageBodyTypeImage:
            {
                messageStr = NSLocalizedString(@"message.image", @"Image");
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                messageStr = NSLocalizedString(@"message.location", @"Location");
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                messageStr = NSLocalizedString(@"message.voice", @"Voice");
            }
                break;
            case EMMessageBodyTypeVideo:{
                messageStr = NSLocalizedString(@"message.video", @"Video");
            }
                break;
            default:
                break;
        }
        NSString *title = message.from;
        
        notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    }
    else{
        notification.alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
    }
    
#warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
    notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@", notification.alertBody];
    
    notification.alertAction = NSLocalizedString(@"open", @"Open");
    notification.timeZone = [NSTimeZone defaultTimeZone];
    [[ChatUIHelper shareHelper] playSoundAndVibration];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.chatType] forKey:kMessageType];
    [userInfo setObject:message.conversationId forKey:kConversationChatter];
    notification.userInfo = userInfo;
    
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    //    UIApplication *application = [UIApplication sharedApplication];
    //    application.applicationIconBadgeNumber += 1;
}

- (void)_handleReceivedAtMessage:(EMMessage*)aMessage
{
    if (aMessage.chatType != EMChatTypeGroupChat || aMessage.direction != EMMessageDirectionReceive) {
        return;
    }
    
    NSString *loginUser = [EMClient sharedClient].currentUsername;
    NSDictionary *ext = aMessage.ext;
    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:aMessage.conversationId type:EMConversationTypeGroupChat createIfNotExist:NO];
    if (loginUser && conversation && ext && [ext objectForKey:kGroupMessageAtList]) {
        id target = [ext objectForKey:kGroupMessageAtList];
        if ([target isKindOfClass:[NSString class]] && [(NSString*)target compare:kGroupMessageAtAll options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            NSNumber *atAll = conversation.ext[kHaveUnreadAtMessage];
            if ([atAll intValue] != kAtAllMessage) {
                NSMutableDictionary *conversationExt = conversation.ext ? [conversation.ext mutableCopy] : [NSMutableDictionary dictionary];
                [conversationExt removeObjectForKey:kHaveUnreadAtMessage];
                [conversationExt setObject:@kAtAllMessage forKey:kHaveUnreadAtMessage];
                conversation.ext = conversationExt;
            }
        }
        else if ([target isKindOfClass:[NSArray class]]) {
            if ([target containsObject:loginUser]) {
                if (conversation.ext[kHaveUnreadAtMessage] == nil) {
                    NSMutableDictionary *conversationExt = conversation.ext ? [conversation.ext mutableCopy] : [NSMutableDictionary dictionary];
                    [conversationExt setObject:@kAtYouMessage forKey:kHaveUnreadAtMessage];
                    conversation.ext = conversationExt;
                }
            }
        }
    }
}

@end
