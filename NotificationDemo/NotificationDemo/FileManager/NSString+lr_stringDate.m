//
//  NSString+lr_stringDate.m
//  MacauTXH
//
//  Created by guopu on 24/9/16.
//  Copyright © 2016年 com.zxd.MacauTXH. All rights reserved.
//

#import "NSString+lr_stringDate.h"

@implementation NSString (lr_stringDate)

+ (NSString *)lr_stringDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    return dateString;
}

@end
