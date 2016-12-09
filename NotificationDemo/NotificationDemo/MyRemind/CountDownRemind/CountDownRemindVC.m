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

@end

@implementation CountDownRemindVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.btnIsAlert.selected = [clsOtherFun getTriggerCountDountON];
    self.tfSeconds.text = [NSString stringWithFormat:@"%lld",[clsOtherFun getTriggerCountDountSeconds]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)switchAction:(id)sender {
    [self.view endEditing:YES];
    self.btnIsAlert.selected = !self.btnIsAlert.selected;
    [clsOtherFun setTriggerCountDountON:self.btnIsAlert.selected];
    if (!self.btnIsAlert.selected) {
        
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 10.0) {
            [clsOtherFun cancel10LocalNotificationWithIdentifier:LocalNotificationID_CountDown];
        }else{
            [clsOtherFun cancelLocalNotificationWithIdentifier:LocalNotificationID_CountDown];
        }
    }else{
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 10.0) {
            [clsOtherFun add10LocalNotificationWithIdentifier:LocalNotificationID_CountDown Type:LocalNotificationType_CountDown Msg:@"倒计时到了！该干嘛干嘛！" Second:[self.tfSeconds.text longLongValue]];
        }
        else{
            [clsOtherFun addLocalNotificationWithIdentifier:LocalNotificationID_CountDown Type:LocalNotificationType_CountDown Msg:@"倒计时到了！该干嘛干嘛！" Second:[self.tfSeconds.text longLongValue]]
            ;
        }
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [clsOtherFun setTriggerCountDountSeconds:[self.tfSeconds.text longLongValue]];
    if (self.btnIsAlert.selected) {
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 10.0) {
            [clsOtherFun add10LocalNotificationWithIdentifier:LocalNotificationID_CountDown Type:LocalNotificationType_CountDown Msg:@"倒计时到了！该干嘛干嘛！" Second:[self.tfSeconds.text longLongValue]];
        }
        else{
            [clsOtherFun addLocalNotificationWithIdentifier:LocalNotificationID_CountDown Type:LocalNotificationType_CountDown Msg:@"倒计时到了！该干嘛干嘛！" Second:[self.tfSeconds.text longLongValue]]
            ;
        }
    }
}


@end
