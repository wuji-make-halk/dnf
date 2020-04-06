//
//  QChatViewController.h
//  dnf
//
//  Created by wake on 2016/11/12.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "EaseMessageViewController.h"

#define KNOTIFICATIONNAME_DELETEALLMESSAGE @"RemoveAllMessages"

@interface QChatViewController : EaseMessageViewController <EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource>

- (void)showMenuViewController:(UIView *)showInView
                  andIndexPath:(NSIndexPath *)indexPath
                   messageType:(EMMessageBodyType)messageType;

@end
