//
//  clsAlert.m
//  MacauTXH
//
//  Created by guopu on 20/9/16.
//  Copyright © 2016年 com.zxd.MacauTXH. All rights reserved.
//

#import "clsAlert.h"
#import <MJExtension/MJExtension.h>
#import <FMDB/FMDB.h>
#import "clsOtherFun.h"

#define MAX_ALERT_NUM 64

@implementation clsAlert

- (instancetype)init {
    self = [super init];
    if (self) {
        self.ID = @"";
        self.TIME = @"00:00";
        self.ISON = NO;
        self.MSG = @"";
        self.STATE = 1;
        self.drugAlerts = [NSMutableArray array];
    }
    return self;
}

+(NSMutableArray *)deSerializeList:(NSArray*)list{
    NSMutableArray * array=[NSMutableArray array];
    NSArray *tempList = [clsAlert mj_objectArrayWithKeyValuesArray:list];
    [array addObjectsFromArray:tempList];
    return array;
}

+ (clsAlert *)deSerializeObj:(NSDictionary*)obj{
    clsAlert * cls = [clsAlert mj_objectWithKeyValues:obj];
    return cls;
}
/**
 关闭所有的提醒
 */
+ (void)closeAllAlert{
    NSMutableArray *array = [clsAlert getList];
    for (clsAlert *cls in array) {
        cls.ISON = 0;
        [clsAlert modifyCls:cls];
    }
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}
//
/**
 查詢是否可以添加本地通知

 @return YES：可以 NO：不可以
 */
+ (BOOL)canInsertAlert{
    NSMutableArray *list = [clsAlert getList];
    if (list.count >= MAX_ALERT_NUM) {
        return NO;
    }
    return YES;
}
/**
 查询App所有的提醒

 @return App提醒列表
 */
+ (NSMutableArray *)getList{
    NSMutableArray * list=[NSMutableArray array];
    NSString *strSQL=[NSString stringWithFormat:@"select * from alert"];
    FMDatabase * db=[[FMDatabase alloc] initWithPath:[clsOtherFun getDatabasePath]];
    if([db open]){
        FMResultSet * resultSet=[db executeQuery:strSQL];
        while ([resultSet next]) {
            clsAlert *cls = [self deSerializeObj:resultSet.resultDictionary];
            [list addObject:cls];
        }
    }
    [db close];
    return list;
}

+ (BOOL)modifyCls:(clsAlert *)pcls{
    BOOL flag = NO;
    clsAlert *oclsOld = [clsAlert getCls:pcls.ID];
    
    if (pcls.STATE==0) {
        if (oclsOld) {
            flag = [clsAlert deleteCls:oclsOld.ID];
        }
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 10.0) {
            [clsOtherFun cancel10LocalNotificationWithIdentifier:pcls.ID];
        }
        else{
            [clsOtherFun cancelLocalNotificationWithIdentifier:pcls.ID];
        }
        
    }else{
        if (oclsOld) {
            flag = [clsAlert updateCls:pcls];
        }else{
            flag = [clsAlert insertCls:pcls];
        }
        
        if (pcls.ISON) {
            if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 10.0) {
                [clsOtherFun add10LocalNotificationWithIdentifier:pcls.ID Msg:pcls.MSG Time:[clsOtherFun custHourMinFromString:pcls.TIME]];
            }
            else{
                [clsOtherFun addLocalNotificationWithIdentifier:pcls.ID Msg:pcls.MSG Time:[clsOtherFun custHourMinFromString:pcls.TIME]];
            }
        }else{
            if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 10.0) {
                [clsOtherFun cancel10LocalNotificationWithIdentifier:pcls.ID];
            }
            else{
                [clsOtherFun cancelLocalNotificationWithIdentifier:pcls.ID];
            }
        }
    }
    
    return flag;
}

+ (clsAlert *)getCls:(NSString *)pID{
    
    clsAlert * cls=nil;
    NSString *strSQL=[NSString stringWithFormat:@"select * from alert where ID = '%@'",pID];
    FMDatabase * db=[[FMDatabase alloc] initWithPath:[clsOtherFun getDatabasePath]];
    if([db open]){
        FMResultSet * resultSet=[db executeQuery:strSQL];
        while ([resultSet next]) {
            cls = [self deSerializeObj:resultSet.resultDictionary];
        }
    }
    [db close];
    return cls;
}

+ (BOOL)insertCls:(clsAlert *)pcls{

    BOOL flag = NO;
    NSDictionary *arguments = @{
                                @"TIME": pcls.TIME,
                                @"ISON":@(pcls.ISON),
                                @"MSG": pcls.MSG};
    
    NSString *strSQL=@"insert into alert (TIME, ISON, MSG) VALUES (:TIME, :ISON, :MSG)";
    FMDatabase * db=[[FMDatabase alloc] initWithPath:[clsOtherFun getDatabasePath]];
    if([db open]){
        flag = [db executeUpdate:strSQL withParameterDictionary:arguments];
    }
    [db close];
    
    return flag;
}

+ (BOOL)updateCls:(clsAlert *)pcls{
    
    BOOL flag = NO;
    NSString *strSQL=[NSString stringWithFormat:@"update alert set TIME='%@', ISON=%d, MSG='%@' where ID='%@'",pcls.TIME,pcls.ISON,pcls.MSG,pcls.ID];
    
    FMDatabase * db=[[FMDatabase alloc] initWithPath:[clsOtherFun getDatabasePath]];
    if([db open]){
        flag = [db executeUpdate:strSQL];
    }
    [db close];
    
    return flag;
}

+ (BOOL)deleteCls:(NSString *)pId{
    
    BOOL flag = NO;
    NSString *strSQL=[NSString stringWithFormat:@"delete from alert where ID='%@'",pId];
    
    FMDatabase * db=[[FMDatabase alloc] initWithPath:[clsOtherFun getDatabasePath]];
    if([db open]){
        flag = [db executeUpdate:strSQL];
    }
    [db close];
    
    return flag;
}


@end
