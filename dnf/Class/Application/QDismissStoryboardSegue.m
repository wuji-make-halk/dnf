//
//  QDismissStoryboardSegue.m
//  dnf
//
//  Created by wake on 2016/10/5.
//  Copyright © 2016年 wake. All rights reserved.
//

#import "QDismissStoryboardSegue.h"

@implementation QDismissStoryboardSegue

- (void)perform
{
    UIViewController *sourceViewController = self.sourceViewController;
    if ([self.identifier isEqualToString:@"pop"]) {
        [sourceViewController.navigationController popViewControllerAnimated:YES];
    }else{
        [sourceViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
