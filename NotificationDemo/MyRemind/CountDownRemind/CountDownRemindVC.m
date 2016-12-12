//
//  CountDownRemindVC.m
//  NotificationDemo
//
//  Created by guopu on 2016/12/8.
//  Copyright © 2016年 blue. All rights reserved.
//

#import "CountDownRemindVC.h"
#import "ListPickView.h"
#import "clsOtherFun.h"
#import "clsAlert.h"

@interface CountDownRemindVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tfSeconds;
@property (weak, nonatomic) IBOutlet UIButton *btnIsAlert;
@property (assign, nonatomic) long long seconds;
@property (assign, nonatomic) BOOL isAlert;

@end

@implementation CountDownRemindVC

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.seconds = [clsOtherFun getTriggerCountDountSeconds];
    if (self.seconds > 0) {
        self.isAlert = [clsOtherFun getTriggerCountDountON];
    }else{
        self.isAlert = NO;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotify:) name:@"LocalNotification_CountDown_Recieve" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)setIsAlert:(BOOL)isAlert{
    _isAlert = isAlert;
    self.btnIsAlert.selected = isAlert;
    [clsOtherFun setTriggerCountDountON:isAlert];
    
    if (!isAlert) {
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 10.0) {
            [clsOtherFun cancel10LocalNotificationWithIdentifier:LocalNotificationID_CountDown];
        }else{
            [clsOtherFun cancelLocalNotificationWithIdentifier:LocalNotificationID_CountDown];
        }
    }else{
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 10.0) {
            [clsOtherFun add10LocalNotificationWithIdentifier:LocalNotificationID_CountDown Msg:@"倒计时到了！该干嘛干嘛！" Second:[self.tfSeconds.text longLongValue]];
        }else{
            [clsOtherFun addLocalNotificationWithIdentifier:LocalNotificationID_CountDown Msg:@"倒计时到了！该干嘛干嘛！" Second:[self.tfSeconds.text longLongValue]]
            ;
        }
    }
}

-(void)setSeconds:(long long)seconds{
    _seconds = seconds;
    self.tfSeconds.text = [NSString stringWithFormat:@"%lld",seconds];
    [clsOtherFun setTriggerCountDountSeconds:seconds];
}

-(void)recieveNotify:(NSNotification*) notification{
    self.isAlert = NO;
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)switchAction:(id)sender {
    [self.view endEditing:YES];
    if (self.seconds <= 0) {
        [clsOtherFun showAlertMessage:@"时间不能低于0秒！"];
        self.isAlert = NO;
        return;
    }
    
    self.btnIsAlert.selected = !self.btnIsAlert.selected;
    self.isAlert = self.btnIsAlert.selected;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ([self.tfSeconds.text longLongValue] <= 0) {
        [clsOtherFun showAlertMessage:@"时间不能低于0秒！"];
        self.isAlert = NO;
        return;
    }
    
    self.seconds = [self.tfSeconds.text longLongValue];
    if (self.isAlert) {
        self.isAlert = YES;
    }
}


@end
