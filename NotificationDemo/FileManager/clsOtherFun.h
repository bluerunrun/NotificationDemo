//
//  clsOtherFun.h
//  EasyMeter
//
//  Created by guopu on 21/7/2016.
//  Copyright © 2016年 zxd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class clsUser;
@interface clsOtherFun : NSObject

+ (NSString *)CreateDatabase;
+(NSString *)getDatabasePath;
+ (void)setDeviceToken:(NSString *)pDeviceToken;
+ (NSString *)getDeviceToken;
+ (void)setTriggerCountDountON:(BOOL)flag;
+ (BOOL)getTriggerCountDountON;
+ (void)setTriggerCountDountSeconds:(long long)pSeconds;
+ (long long)getTriggerCountDountSeconds;
+ (void)setTriggerLocationON:(BOOL)flag;
+ (BOOL)getTriggerLocationON;
+ (void)setTriggerCoordinate:(CLLocationCoordinate2D)coordinate;
+ (CLLocationCoordinate2D)getTriggerCoordinate;
+ (void)setTriggerRadius:(double)radius;
+ (double)getTriggerRadius;

+(void)showAlertMessage:(NSString *) message;
+(int)getMemberID;

+ (UIViewController *)getCurrentVC;

#pragma mark -LocalNotification
// Before iOS10
// 添加本地通知
+ (void)addLocalNotificationWithIdentifier:(NSString *)identifier Type:(NSString *)type Msg:(NSString*)content Second:(long long)second;
+ (void)addLocalNotificationWithIdentifier:(NSString *)identifier Type:(NSString *)type Msg:(NSString*)content Time:(NSDate *)time;
// 取消某个本地推送通知
+ (void)cancelLocalNotificationWithIdentifier:(NSString *)identifier;

// iOS10
+ (void)add10LocalNotificationWithIdentifier:(NSString *)identifier Type:(NSString *)type Msg:(NSString*)msg Second:(long long)second;
+ (void)add10LocalNotificationWithIdentifier:(NSString *)identifier Type:(NSString *)type Msg:(NSString*)msg Time:(NSDate *)time;
+ (void)cancel10LocalNotificationWithIdentifier:(NSString *)key;


+(NSDate *)custHourMinFromString:(NSString *)dateStr;
+(NSString *)custHourMinFromDate:(NSDate *)date;
+(NSDate *)custYearMonthDayAndHourMinFromDate:(NSDate *)time;

@end
