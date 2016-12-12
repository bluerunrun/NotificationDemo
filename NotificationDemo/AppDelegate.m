//
//  AppDelegate.m
//  NotificationDemo
//
//  Created by guopu on 2016/12/5.
//  Copyright © 2016年 blue. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import "VersionViewController.h"
#import "CustomNavigationController.h"
#import "clsOtherFun.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    LRLog(@"\nNSDocumentDirectory:%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]);
    
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0]; 清零
    // 1.请求授权(注意：如果不请求授权在设置中是没有对应的通知设置项的)
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 10.0) {
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
            //在block中会传入布尔值granted，表示用户是否同意
            if (granted) {
                //如果用户权限申请成功，设置通知中心的代理
                [UNUserNotificationCenter currentNotificationCenter].delegate = self;
            }
        }];
    }else{
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes: (UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    // 注册远程通知
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    
    [clsOtherFun CreateDatabase];
    
    //接收通知参数®
    UILocalNotification *notification=[launchOptions valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    NSDictionary *userInfo= notification.userInfo;
    if (userInfo) {
        
        LRLog(@"\n应用外Local notification:%@ 提醒內容:%@ 提醒时间:%@",userInfo[LocalNotificationIDKey],notification.alertBody,notification.fireDate);
        self.messageID = notification.userInfo[LocalNotificationIDKey];
        self.message = notification.alertBody;
        self.messageTime = [clsOtherFun custYearMonthDayAndHourMinFromDate:notification.fireDate];
       
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:self.messageID message:self.message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if ([self.messageID isEqualToString:LocalNotificationID_CountDown]) {
                [clsOtherFun setTriggerCountDountON:NO];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LocalNotification_CountDown_Recieve" object:nil];
            }
        }]];
        [[clsOtherFun getCurrentVC] presentViewController:alert animated:YES completion:nil];
        
    }

    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.rootViewController = [[VersionViewController alloc] initWithNibName:@"VersionViewController" bundle:nil];
    CustomNavigationController * nav=[[CustomNavigationController alloc] initWithRootViewController:self.rootViewController];
    nav.navigationBarHidden=YES;
    
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES; 
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    LRLog(@"\n应用内Local notification:%@ 提醒內容:%@ 提醒时间:%@",notification.userInfo[LocalNotificationIDKey],notification.alertBody,notification.fireDate);

    self.messageID = notification.userInfo[LocalNotificationIDKey];
    self.message = notification.alertBody;
    self.messageTime = [clsOtherFun custYearMonthDayAndHourMinFromDate:notification.fireDate];
    
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:self.messageID message:self.message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if ([self.messageID isEqualToString:LocalNotificationID_CountDown]) {
            [clsOtherFun setTriggerCountDountON:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LocalNotification_CountDown_Recieve" object:nil];
        }
    }]];
    [[clsOtherFun getCurrentVC] presentViewController:alert animated:YES completion:nil];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(nonnull UNNotificationResponse *)response withCompletionHandler:(nonnull void (^)())completionHandler{
    UNNotificationContent *content = response.notification.request.content;
    LRLog(@"\ndidReceiveNotificationResponse:%@ 提醒內容:%@ 提醒时间:%@",content.userInfo[LocalNotificationIDKey],content.body,response.notification.date);
    
    self.messageID = content.userInfo[LocalNotificationIDKey];
    self.message = content.body;
    self.messageTime = [clsOtherFun custYearMonthDayAndHourMinFromDate:response.notification.date];
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:self.messageID message:self.message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if ([self.messageID isEqualToString:LocalNotificationID_CountDown]) {
            [clsOtherFun setTriggerCountDountON:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LocalNotification_CountDown_Recieve" object:nil];
        }
    }]];
    [[clsOtherFun getCurrentVC] presentViewController:alert animated:YES completion:nil];
    
    completionHandler();
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    NSString *strToken=[NSString stringWithFormat:@"%@",deviceToken];
    strToken=[strToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
    strToken=[strToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    strToken=[strToken stringByReplacingOccurrencesOfString:@">" withString:@""];
    //    LRLog(@"\nMy Token is:%@",strToken);
    [clsOtherFun setDeviceToken:strToken];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
