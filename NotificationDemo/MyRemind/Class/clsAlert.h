//
//  clsAlert.h
//  MacauTXH
//
//  Created by guopu on 20/9/16.
//  Copyright © 2016年 com.zxd.MacauTXH. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(int, AlertType) {
    
    AlertType_Timed=0,
    AlertType_Drug=1
};


@interface clsAlert : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *TIME;//提醒時間
@property (nonatomic, assign) BOOL ISON;//開關
@property (nonatomic, assign) int TYPE;//0:運動提醒 1:血壓提醒 2:血糖提醒 3:用药提醒
@property (nonatomic, copy) NSString *MSG;
@property (nonatomic, assign) int STATE;//0删除  1正常

@property (nonatomic, strong) NSMutableArray *drugAlerts;

+ (void)closeAllAlert;
+ (BOOL)canInsertAlert;
+ (BOOL)modifyCls:(clsAlert *)pcls;

+ (clsAlert *)getClsByType:(int)pType;
+ (clsAlert *)getCls:(NSString *)pID;//根據ID查詢
@end
