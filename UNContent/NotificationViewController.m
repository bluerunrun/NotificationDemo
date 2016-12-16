//
//  NotificationViewController.m
//  UNContent
//
//  Created by guopu on 2016/12/14.
//  Copyright © 2016年 blue. All rights reserved.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface NotificationViewController () <UNNotificationContentExtension>

@property IBOutlet UILabel *label;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any required interface initialization here.
}

- (void)didReceiveNotification:(UNNotification *)notification {
    self.label.text = notification.request.content.body;
}


- (void)didReceiveNotificationResponse:(UNNotificationResponse *)response completionHandler:(void (^)(UNNotificationContentExtensionResponseOption option))completion{
    if ([response.actionIdentifier  isEqual: @"likes"]) {
        NSString *identifiers = response.notification.request.identifier;
        
        [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[identifiers]];
        [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:@[identifiers]];
        completion(UNNotificationContentExtensionResponseOptionDoNotDismiss);
    }else{
        completion(UNNotificationContentExtensionResponseOptionDismiss);
    }
}

@end
