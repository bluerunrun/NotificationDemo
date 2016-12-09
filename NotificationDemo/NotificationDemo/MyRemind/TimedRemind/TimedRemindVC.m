//
//  TimedRemindVC.m
//  MacauTXH
//
//  Created by inspiration on 16/9/14.
//  Copyright © 2016年 com.zxd.MacauTXH. All rights reserved.
//

#import "TimedRemindVC.h"
#import "ListPickView.h"
#import "clsOtherFun.h"
#import "clsAlert.h"

@interface TimedRemindVC ()
@property (weak, nonatomic) IBOutlet UIButton *btnIsAlert;
@property (weak, nonatomic) IBOutlet UILabel *lbTime;

@property (nonatomic, strong) clsAlert *cls;
@end

@implementation TimedRemindVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.cls = [clsAlert getClsByType:AlertType_Timed];
    self.lbTime.text = self.cls.TIME;
    self.btnIsAlert.selected = self.cls.ISON;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)switchAction:(id)sender {
    self.btnIsAlert.selected = !self.btnIsAlert.selected;
    self.cls.ISON = self.btnIsAlert.selected;
    [clsAlert modifyCls:self.cls];
}


- (IBAction)changeSportTime:(id)sender {
    ListPickView *pickView = [[ListPickView alloc] initDatePickWithDate:[clsOtherFun custHourMinFromString:self.cls.TIME] datePickerMode:UIDatePickerModeTime];
    __weak __typeof(&*self)weakSelf = self;
    [pickView show:^(NSString *pSelectData, NSDate *pSelectDate, NSInteger pSelectIndex) {
        NSString *time = [clsOtherFun custHourMinFromDate:pSelectDate];
        weakSelf.cls.TIME = time;
        [clsAlert modifyCls:weakSelf.cls];
        weakSelf.lbTime.text = weakSelf.cls.TIME;
    }];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
