//
//  ListPickView.h
//  AWC
//
//  Created by guopu on 15-2-3.
//  Copyright (c) 2015年 sanvio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CallBack)(NSString *pSelectData,NSDate * pSelectDate,NSInteger pSelectIndex);

@interface ListPickView : UIView

-(instancetype)initPickviewWithArray:(NSArray *)array;
-(instancetype)initPickviewWithArray:(NSArray *)array andSlectedRow:(NSInteger)row;

/**
 * @brief DatePick初始化 不限制最小和最大时间
 *
 * @param  defaulDate 设置显示(选中)Date
 *
 * @param  datePickerMode UIDatePickerMode
 *
 * @return 返回value.
 */
-(instancetype)initDatePickWithDate:(NSDate *)defaulDate datePickerMode:(UIDatePickerMode)datePickerMode;
/**
 * @brief DatePick初始化 默认限制最小时间为100年前
 *
 * @param  defaulDate 设置显示(选中)Date
 *
 * @param  maximumDate 可选最大时间
 *
 * @param  datePickerMode UIDatePickerMode
 *
 * @return 返回value.
 */
-(instancetype)initDatePickWithDate:(NSDate *)defaulDate maximumDate:(NSDate *)maximumDate datePickerMode:(UIDatePickerMode)datePickerMode;
/**
 * @brief DatePick初始化 传入参数设置最大和最小可选时间
 *
 * @param  defaulDate 设置显示(选中)Date
 *
 * @param  minimumDate 可选最小时间 传nil则不限制
 *
 * @param  maximumDate 可选最大时间 传nil则不限制
 *
 * @param  datePickerMode UIDatePickerMode
 *
 * @return 返回value.
 */
-(instancetype)initDatePickWithDate:(NSDate *)defaulDate minimumDate:(NSDate *)minimumDate maximumDate:(NSDate *)maximumDate datePickerMode:(UIDatePickerMode)datePickerMode;

-(void)show:(CallBack) pCloseCallback;
-(void)remove;

@end
