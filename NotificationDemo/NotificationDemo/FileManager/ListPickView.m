//
//  ListPickView.m
//  AWC
//
//  Created by guopu on 15-2-3.
//  Copyright (c) 2015年 sanvio. All rights reserved.
//

#import "ListPickView.h"
//#import "clsLanguage.h"

#define TOOLBARHEIGHT 40

@interface ListPickView()<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,copy)CallBack closecallback;
@property(nonatomic,strong)UIPickerView *pickView;
@property(nonatomic,strong)UIView * toolBar;
@property(nonatomic,strong)UIDatePicker *datePicker;
@property(nonatomic,strong)NSArray * dataList;

@end

@implementation ListPickView

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        self.backgroundColor=[[UIColor alloc] initWithWhite:0 alpha:0.3];
    }
    return self;
}

-(instancetype)initPickviewWithArray:(NSArray *)array{
    self=[super init];
    if(self){
        self.dataList=array;
        self.frame=[UIScreen mainScreen].bounds;
        self.pickView=[[UIPickerView alloc] init];
        self.pickView.backgroundColor=[UIColor whiteColor];
        self.pickView.delegate=self;
        self.pickView.dataSource=self;
        self.pickView.frame=CGRectMake(0, self.frame.size.height+TOOLBARHEIGHT, self.frame.size.width, self.pickView.frame.size.height);
        [self addSubview:self.pickView];
        [self setUpToolBar:self.pickView.frame];
        
    }
    return self;
}

-(instancetype)initPickviewWithArray:(NSArray *)array andSlectedRow:(NSInteger)row{
    self=[super init];
    if(self){
        self.dataList=array;
        self.frame=[UIScreen mainScreen].bounds;
        self.pickView=[[UIPickerView alloc] init];
        self.pickView.backgroundColor=[UIColor whiteColor];
        self.pickView.delegate=self;
        self.pickView.dataSource=self;
        self.pickView.frame=CGRectMake(0, self.frame.size.height+TOOLBARHEIGHT, self.frame.size.width, self.pickView.frame.size.height-44);
        [self.pickView selectRow:row inComponent:0 animated:NO];
        [self addSubview:self.pickView];
        [self setUpToolBar:self.pickView.frame];
        
    }
    return self;
}

-(instancetype)initDatePickWithDate:(NSDate *)defaulDate datePickerMode:(UIDatePickerMode)datePickerMode{
    self=[super init];
    if(self){
          self.frame=[UIScreen mainScreen].bounds;
        self.datePicker = [[UIDatePicker alloc] init];
        self.datePicker.datePickerMode = datePickerMode;
        self.datePicker.backgroundColor=[UIColor whiteColor];
        self.datePicker.date = defaulDate;
        [self.datePicker setLocale:[NSLocale currentLocale]];
//        [self.datePicker setCalendar:[NSCalendar currentCalendar]];
        self.datePicker.frame=CGRectMake(0, self.frame.size.height+TOOLBARHEIGHT, self.frame.size.width, self.datePicker.frame.size.height);
        [self addSubview:self.datePicker];
        
        [self setUpToolBar:self.datePicker.frame];
    }
    return self;
}

-(instancetype)initDatePickWithDate:(NSDate *)defaulDate maximumDate:(NSDate *)maximumDate datePickerMode:(UIDatePickerMode)datePickerMode{
    self=[super init];
    if(self){
        self.frame=[UIScreen mainScreen].bounds;
        self.datePicker = [[UIDatePicker alloc] init];
        self.datePicker.datePickerMode = datePickerMode;
        self.datePicker.backgroundColor=[UIColor whiteColor];
        self.datePicker.date = defaulDate;
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *adcomps = [[NSDateComponents alloc] init];
        [adcomps setYear:-100];
        NSDate *date100 = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
        self.datePicker.minimumDate=date100;
        self.datePicker.maximumDate=maximumDate;
        [self.datePicker setLocale:[NSLocale currentLocale]];
        self.datePicker.frame=CGRectMake(0, self.frame.size.height+TOOLBARHEIGHT, self.frame.size.width, self.datePicker.frame.size.height);
        [self addSubview:self.datePicker];
        
        [self setUpToolBar:self.datePicker.frame];
    }
    return self;
}

-(instancetype)initDatePickWithDate:(NSDate *)defaulDate minimumDate:(NSDate *)minimumDate maximumDate:(NSDate *)maximumDate datePickerMode:(UIDatePickerMode)datePickerMode{
    self=[super init];
    if(self){
        self.frame=[UIScreen mainScreen].bounds;
        self.datePicker = [[UIDatePicker alloc] init];
        self.datePicker.datePickerMode = datePickerMode;
        self.datePicker.backgroundColor=[UIColor whiteColor];
        self.datePicker.date = defaulDate;
        if (minimumDate) {
            self.datePicker.minimumDate=minimumDate;
        }
        if (maximumDate) {
            self.datePicker.maximumDate=maximumDate;
        }
        [self.datePicker setLocale:[NSLocale currentLocale]];
        self.datePicker.frame=CGRectMake(0, self.frame.size.height+TOOLBARHEIGHT, self.frame.size.width, self.datePicker.frame.size.height);
        [self addSubview:self.datePicker];
        
        [self setUpToolBar:self.datePicker.frame];
    }
    return self;
}


-(void)setUpToolBar:(CGRect) rect{
    rect.origin.y-=TOOLBARHEIGHT;
    rect.size.height=TOOLBARHEIGHT;
    self.toolBar=[[UIView alloc] initWithFrame:rect];
    self.toolBar.backgroundColor=[UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1];
    
    UIButton * leftItem=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftItem setTitle:@"取消" forState:UIControlStateNormal];
    [leftItem setTitle:@"取消" forState:UIControlStateSelected];
    [leftItem addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    [leftItem setTintColor:[UIColor whiteColor]];
    leftItem.titleLabel.font=[UIFont systemFontOfSize:15];
    leftItem.frame=CGRectMake(0, 0, 55, self.toolBar.bounds.size.height);
    [self.toolBar addSubview:leftItem];
    
    UIButton * rightItem=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightItem setTitle:@"確定" forState:UIControlStateNormal];
    [rightItem setTitle:@"確定" forState:UIControlStateSelected];
    [rightItem addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    [rightItem setTintColor:[UIColor whiteColor]];
    rightItem.titleLabel.font=[UIFont systemFontOfSize:15];
    rightItem.frame=CGRectMake(rect.size.width-55, 0, 55, self.toolBar.bounds.size.height);
    [self.toolBar addSubview:rightItem];
    
    [self addSubview:self.toolBar];
}

-(void)doneClick
{
    NSString * result=@"";
    if(self.pickView){
        NSInteger cIndex = [self.pickView selectedRowInComponent:0];
        result=self.dataList[cIndex];
        self.closecallback(result,nil,cIndex);
        
    }else if(self.datePicker){
//        NSDateFormatter *fmat = [[NSDateFormatter alloc] init];
//        [fmat setDateFormat:@"yyyy-MM-dd"];
//        result = [fmat stringFromDate:self.datePicker.date];
        self.closecallback(@"",self.datePicker.date,0);
    }
    
    [self remove];
}


-(void)show:(CallBack) pCloseCallback{
    self.closecallback=pCloseCallback;
     [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        if(self.pickView){
            self.pickView.frame=CGRectMake(0, self.frame.size.height-self.pickView.frame.size.height, self.pickView.frame.size.width, self.pickView.frame.size.height);
            CGRect rect=self.pickView.bounds;
            rect.origin.y=self.frame.size.height-self.pickView.frame.size.height-TOOLBARHEIGHT;
            rect.size.height=TOOLBARHEIGHT;
            self.toolBar.frame=rect;
        }else if(self.datePicker){
            self.datePicker.frame=CGRectMake(0, self.frame.size.height-self.datePicker.frame.size.height, self.datePicker.frame.size.width, self.datePicker.frame.size.height);
            CGRect rect=self.datePicker.bounds;
            rect.origin.y=self.frame.size.height-self.datePicker.frame.size.height-TOOLBARHEIGHT;
            rect.size.height=TOOLBARHEIGHT;
            self.toolBar.frame=rect;
        }
    } completion:^(BOOL finished) {
        
    }];

}

-(void)remove{
    [UIView animateWithDuration:0.3 animations:^{
        if(self.pickView){
            self.pickView.frame=CGRectMake(0, self.frame.size.height+TOOLBARHEIGHT, self.pickView.frame.size.width, self.pickView.frame.size.height);
            CGRect rect=self.pickView.bounds;
            rect.origin.y=self.frame.size.height;
            rect.size.height=TOOLBARHEIGHT;
            self.toolBar.frame=rect;
        }else if(self.datePicker){
            self.datePicker.frame=CGRectMake(0, self.frame.size.height+TOOLBARHEIGHT, self.datePicker.frame.size.width, self.datePicker.frame.size.height);
            CGRect rect=self.datePicker.bounds;
            rect.origin.y=self.frame.size.height;
            rect.size.height=TOOLBARHEIGHT;
            self.toolBar.frame=rect;
        }
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

    
}



#pragma mark piackView 数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataList.count;
}

#pragma mark UIPickerViewdelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.dataList[row];
}
// 覆盖，修改字体大小
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.minimumScaleFactor = 0.6;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:20]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
