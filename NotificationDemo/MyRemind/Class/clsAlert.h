//
//  clsAlert.h
//  MacauTXH
//
//  Created by guopu on 20/9/16.
//  Copyright © 2016年 com.zxd.MacauTXH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface clsAlert : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *TIME;//提醒時間
@property (nonatomic, assign) BOOL ISON;//開關
@property (nonatomic, copy) NSString *MSG;
@property (nonatomic, assign) int STATE;//0删除  1正常

@property (nonatomic, strong) NSMutableArray *drugAlerts;

+ (void)closeAllAlert;
+ (BOOL)canInsertAlert;
+ (BOOL)modifyCls:(clsAlert *)pcls;

+ (clsAlert *)getCls:(NSString *)pID;//根據ID查詢
@end
