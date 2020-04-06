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

#import <Foundation/Foundation.h>
#import "QMessageViewController.h"
#import "QChatViewController.h"

#define kHaveUnreadAtMessage    @"kHaveAtMessage"
#define kAtYouMessage           1
#define kAtAllMessage           2

@interface ChatUIHelper : NSObject <EMClientDelegate,EMChatManagerDelegate>

@property (strong, nonatomic) NSDate *lastPlaySoundDate;

@property (nonatomic, weak) QMessageViewController *conversationListVC;

@property (nonatomic, weak) QChatViewController *chatVC;

@property (nonatomic, assign)EMConnectionState connectionState;


+ (instancetype)shareHelper;

- (void)asyncPushOptions;

- (void)asyncConversationFromDB;


@end
