//
//  MyRemindViewController.m
//  MacauTXH
//
//  Created by guopu on 2016/12/5.
//  Copyright © 2016年 com.zxd.MacauTXH. All rights reserved.
//

#import "MyRemindViewController.h"
#import "MyRemindCell.h"
#import "Masonry.h"
#import "CountDownRemindVC.h"
#import "TimedRemindVC.h"
#import "LocationRemindVC.h"

static NSString * identifier=@"MyRemindCell";

@interface MyRemindViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *titleList;

@end

@implementation MyRemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"我的提醒";
    UIView *footView=[[UIView alloc] init];
    [self.tableView setTableFooterView:footView];
    self.view.backgroundColor=BGColor;
    self.titleList=@[@"倒计时提醒",@"定时提醒",@"区域提醒"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menuAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowMenu" object:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyRemindCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil] lastObject];
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
        tableView.separatorColor=SeparatorColor;
    }
    cell.titleStr=self.titleList[indexPath.row];
    [cell loadData];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.row==0){
        
        CountDownRemindVC * vc=[[CountDownRemindVC alloc] initWithNibName:@"CountDownRemindVC" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.row==1){
        
        TimedRemindVC * vc=[[TimedRemindVC alloc] initWithNibName:@"TimedRemindVC" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        
        LocationRemindVC *vc=[[LocationRemindVC alloc] initWithNibName:@"LocationRemindVC" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
