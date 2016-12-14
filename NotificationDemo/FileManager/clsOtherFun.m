//
//  clsOtherFun.m
//  EasyMeter
//
//  Created by guopu on 21/7/2016.
//  Copyright © 2016年 zxd. All rights reserved.
//

#import "clsOtherFun.h"
#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

static NSString *Device_Token = @"deviceToken";
static NSString *TriggerCountDount_ON = @"CountDountON";
static NSString *TriggerCountDount_Seconds = @"CountDountSeconds";
static NSString *TriggerLocation_ON = @"TriggerLocationON";
static NSString *TriggerLocation_Latitude = @"TriggerLocation_Latitude";
static NSString *TriggerLocation_Longitude = @"TriggerLocation_Longitude";
static NSString *TriggerLocation_Radius = @"TriggerLocation_Radius";

@implementation clsOtherFun

+ (NSString *)CreateDatabase {
    NSString * databasePath=[self getDatabasePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:databasePath]) {
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DataBaseName];
        NSError *error;
        [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:&error];
        LRLog(@"error: %@",error.description);
    }
    return databasePath;
}

+(NSString *)getDatabasePath{
    NSString *databasePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    databasePath = [databasePath stringByAppendingPathComponent:DataBaseName];
    return databasePath;
}

+ (void)setDeviceToken:(NSString *)pDeviceToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:pDeviceToken forKey:Device_Token];
    [defaults synchronize];
}

+ (NSString *)getDeviceToken
{
    NSString *strToken = @"";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:Device_Token]) {
        strToken = [defaults objectForKey:Device_Token];
    }
    return strToken;
}

+ (void)setTriggerCountDountON:(BOOL)flag
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:flag] forKey:TriggerCountDount_ON];
    [defaults synchronize];
}

+ (BOOL)getTriggerCountDountON
{
    BOOL flag = false;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:TriggerCountDount_ON]) {
        flag = [[defaults objectForKey:TriggerCountDount_ON] boolValue];
    }
    return flag;
}

+ (void)setTriggerCountDountSeconds:(long long)pSeconds
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithLongLong:pSeconds] forKey:TriggerCountDount_Seconds];
    [defaults synchronize];
}

+ (long long)getTriggerCountDountSeconds
{
    long long pSeconds = 0;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:TriggerCountDount_Seconds]) {
        pSeconds = [[defaults objectForKey:TriggerCountDount_Seconds] longLongValue];
    }
    return pSeconds;
}

+ (void)setTriggerLocationON:(BOOL)flag
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:flag] forKey:TriggerLocation_ON];
    [defaults synchronize];
}

+ (BOOL)getTriggerLocationON
{
    BOOL flag = false;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:TriggerLocation_ON]) {
        flag = [[defaults objectForKey:TriggerLocation_ON] boolValue];
    }
    return flag;
}

+ (void)setTriggerLocationCoordinate:(CLLocationCoordinate2D)coordinate{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithDouble:coordinate.latitude] forKey:TriggerLocation_Latitude];
    [defaults setObject:[NSNumber numberWithDouble:coordinate.longitude] forKey:TriggerLocation_Longitude];
    [defaults synchronize];
}

+ (CLLocationCoordinate2D)getTriggerLocationCoordinate{
    
    CLLocationCoordinate2D coordinate = DefaultCoordinate;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:TriggerLocation_Latitude]) {
        coordinate.latitude = [[defaults objectForKey:TriggerLocation_Latitude] doubleValue];
        coordinate.longitude = [[defaults objectForKey:TriggerLocation_Longitude] doubleValue];
    }
    return coordinate;
}

+ (void)setTriggerLocationRadius:(double)radius{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithDouble:radius] forKey:TriggerLocation_Radius];
    [defaults synchronize];
}

+ (double)getTriggerLocationRadius{
    
    double radius = 0;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:TriggerLocation_Radius]) {
        radius = [[defaults objectForKey:TriggerLocation_Radius] doubleValue];
    }
    return radius;
}

+(void)showAlertMessage:(NSString *) message{
    UIAlertView * aletr =[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"確定" otherButtonTitles:nil];
    [aletr show];
}


+(int)getMemberID{
    return 000;
}

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    return result;
}

#pragma mark -LocalNotification

+ (void)add10LocalNotificationWithIdentifier:(NSString *)identifier Msg:(NSString*)msg Second:(long long)second{
    
    [clsOtherFun cancel10LocalNotificationWithIdentifier:identifier];
    
    // 1. 创建通知内容
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    //    content.badge = @2;
    content.title = identifier;
    content.body = msg;
    content.sound = [UNNotificationSound defaultSound];
    // 设定通知的userInfo，用来标识该通知
    NSMutableDictionary *aUserInfo = [[NSMutableDictionary alloc] init];
    aUserInfo[LocalNotificationIDKey] = identifier;
    content.userInfo = aUserInfo;
    
    //创建图片附件
    UNNotificationAttachment * attach = [UNNotificationAttachment attachmentWithIdentifier:@"imageAttach" URL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp3"]] options:nil error:nil];
    //设置附件数组
    content.attachments = @[attach];
    
    // 2. 创建发送触发
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:second repeats:NO];
    
    // 3. 创建一个发送请求
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
    
    // 4. 将请求添加到发送中心
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            LRLog(@"Time Interval Notification scheduled Error : %@",error.description);
        }
    }];
}


// 添加本地通知
+ (void)add10LocalNotificationWithIdentifier:(NSString *)identifier Msg:(NSString*)msg Time:(NSDate *)time{
    
    [clsOtherFun cancel10LocalNotificationWithIdentifier:identifier];
    
    // 1. 创建通知内容
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
//    content.badge = @2;
    content.title = identifier;
    content.body = msg;
    content.sound = [UNNotificationSound defaultSound];
    // 设定通知的userInfo，用来标识该通知
    NSMutableDictionary *aUserInfo = [[NSMutableDictionary alloc] init];
    aUserInfo[LocalNotificationIDKey] = identifier;
    content.userInfo = aUserInfo;
    
    // 2. 创建发送触发
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [greCalendar components:NSCalendarUnitHour|NSCalendarUnitMinute  fromDate:time];
    dateComponents.timeZone = [NSTimeZone defaultTimeZone];
    
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComponents repeats:YES];
    
    // 3. 创建一个发送请求
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
    
    // 4. 将请求添加到发送中心
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            LRLog(@"Time Interval Notification scheduled Error : %@",error.description);
        }
    }];
}

// 添加本地通知
+ (void)add10LocalNotificationWithIdentifier:(NSString *)identifier Msg:(NSString*)msg Location:(CLLocationCoordinate2D)coordinate radius:(CLLocationDistance)radius{
    
    [clsOtherFun cancel10LocalNotificationWithIdentifier:identifier];
    
    // 1. 创建通知内容
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    //    content.badge = @2;
    content.title = identifier;
    content.body = msg;
    content.sound = [UNNotificationSound defaultSound];
    // 设定通知的userInfo，用来标识该通知
    NSMutableDictionary *aUserInfo = [[NSMutableDictionary alloc] init];
    aUserInfo[LocalNotificationIDKey] = identifier;
    content.userInfo = aUserInfo;
    
    // 2. 创建发送触发
    CLRegion *region = [[CLCircularRegion alloc] initWithCenter:coordinate radius:radius identifier:identifier];
    region.notifyOnExit = YES;
    region.notifyOnEntry = YES;
    UNLocationNotificationTrigger *trigger = [UNLocationNotificationTrigger triggerWithRegion:region repeats:YES];
    
    // 3. 创建一个发送请求
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
    
    // 4. 将请求添加到发送中心
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            LRLog(@"Time Interval Notification scheduled Error : %@",error.description);
        }
    }];
}

// 取消某个本地推送通知
+ (void)cancel10LocalNotificationWithIdentifier:(NSString *)identifier {
    [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[identifier]];
}

// 添加本地通知
+ (void)addLocalNotificationWithIdentifier:(NSString *)identifier Msg:(NSString*)msg Second:(long long)second{
    // 若通知存在 则先去除通知 再添加
    [clsOtherFun cancelLocalNotificationWithIdentifier:identifier];
    
    // 初始化本地通知对象
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification) {
        // 设置通知的提醒时间
        notification.timeZone = [NSTimeZone defaultTimeZone]; // 使用本地时区
        notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:second];
        
        // 设置重复间隔
        notification.repeatInterval = 0;
        
        // 设置提醒的文字内容
        notification.alertBody   = msg;
        notification.alertAction = @"这是什么鬼alertAction";
        notification.soundName = UILocalNotificationDefaultSoundName;
        
        // 设置应用程序右上角的提醒个数
        //        notification.applicationIconBadgeNumber++;
        
        // 设定通知的userInfo，用来标识该通知
        NSMutableDictionary *aUserInfo = [[NSMutableDictionary alloc] init];
        aUserInfo[LocalNotificationIDKey] = identifier;
        
        notification.userInfo = aUserInfo;
        //        LRLog(@"\n添加本地通知 :%@ :%@ 提醒时间:%@",aUserInfo[LocalNotificationIDKey],aUserInfo[LocalNotificationTypeKey],notification.fireDate);
        // 将通知添加到系统中
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}


+ (void)addLocalNotificationWithIdentifier:(NSString *)identifier Msg:(NSString*)msg Time:(NSDate *)time{
    // 若通知存在 则先去除通知 再添加
    [clsOtherFun cancelLocalNotificationWithIdentifier:identifier];
    
    // 初始化本地通知对象
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification) {
        // 设置通知的提醒时间
        notification.timeZone = [NSTimeZone defaultTimeZone]; // 使用本地时区
        notification.fireDate = time;
        
        // 设置重复间隔
        notification.repeatInterval = kCFCalendarUnitDay;
        
        // 设置提醒的文字内容
        notification.alertBody   = msg;
        notification.alertAction = @"这是什么鬼alertAction";
        notification.soundName = UILocalNotificationDefaultSoundName;
        
        // 设置应用程序右上角的提醒个数
//        notification.applicationIconBadgeNumber++;
        
        // 设定通知的userInfo，用来标识该通知
        NSMutableDictionary *aUserInfo = [[NSMutableDictionary alloc] init];
        aUserInfo[LocalNotificationIDKey] = identifier;
        
        notification.userInfo = aUserInfo;
//        LRLog(@"\n添加本地通知 :%@ :%@ 提醒时间:%@",aUserInfo[LocalNotificationIDKey],aUserInfo[LocalNotificationTypeKey],notification.fireDate);
        // 将通知添加到系统中
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

+ (void)addLocalNotificationWithIdentifier:(NSString *)identifier Msg:(NSString*)msg Location:(CLLocationCoordinate2D)coordinate radius:(CLLocationDistance)radius{
    // 若通知存在 则先去除通知 再添加
    [clsOtherFun cancelLocalNotificationWithIdentifier:identifier];
    
    // 初始化本地通知对象
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification) {
        // 设置通知的地理位置
        CLRegion *region = [[CLCircularRegion alloc] initWithCenter:coordinate radius:radius identifier:identifier];
        region.notifyOnExit = YES;
        region.notifyOnEntry = YES;
        notification.region = region;
        notification.regionTriggersOnce = NO;
        
        // 设置重复间隔
        notification.repeatInterval = kCFCalendarUnitDay;
        
        // 设置提醒的文字内容
        notification.alertBody   = msg;
        notification.alertAction = @"这是什么鬼alertAction";
        notification.soundName = UILocalNotificationDefaultSoundName;
        
        // 设置应用程序右上角的提醒个数
        //        notification.applicationIconBadgeNumber++;
        
        // 设定通知的userInfo，用来标识该通知
        NSMutableDictionary *aUserInfo = [[NSMutableDictionary alloc] init];
        aUserInfo[LocalNotificationIDKey] = identifier;
        
        notification.userInfo = aUserInfo;
        //        LRLog(@"\n添加本地通知 :%@ :%@ 提醒时间:%@",aUserInfo[LocalNotificationIDKey],aUserInfo[LocalNotificationTypeKey],notification.fireDate);
        // 将通知添加到系统中
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

// 取消某个本地推送通知
+ (void)cancelLocalNotificationWithIdentifier:(NSString *)identifier {
    // 获取所有本地通知数组
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            // 根据设置通知参数时指定的key来获取通知参数
            NSString *info = userInfo[LocalNotificationIDKey];
            
            // 如果找到需要取消的通知，则取消
            if ([info isEqualToString:identifier]) {
//                LRLog(@"\n关闭本地通知 :%@ 提醒时间:%@",notification.userInfo[LocalNotificationIDKey],notification.fireDate);
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                break;
            }
        }
    }
}

#pragma mark -时间处理
+(NSDate *)custHourMinFromString:(NSString *)dateStr{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    
    return date;
}

+(NSString *)custHourMinFromDate:(NSDate *)date{
    NSString *str =@"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    str = [dateFormatter stringFromDate:date];
    
    return str;
}

+(NSDate *)custYearMonthDayAndHourMinFromDate:(NSDate *)time{
    
    NSString *todayTime =@"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    todayTime = [dateFormatter stringFromDate:time];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    todayTime = [NSString stringWithFormat:@"%@ %@",dateStr, todayTime];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateFormatter dateFromString:todayTime];
}

@end
