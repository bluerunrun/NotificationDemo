//
//  AppDelegate.h
//  NotificationDemo
//
//  Created by guopu on 2016/12/5.
//  Copyright © 2016年 blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController * rootViewController;

@property (nonatomic, copy) NSString *messageID;
@property (nonatomic, copy) NSString *messageType;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSDate *messageTime;

@end

