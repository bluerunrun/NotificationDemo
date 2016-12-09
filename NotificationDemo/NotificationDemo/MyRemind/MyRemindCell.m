//
//  MyRemindCell.m
//  MacauTXH
//
//  Created by huweidong on 13/9/16.
//  Copyright © 2016年 com.zxd.MacauTXH. All rights reserved.
//

#import "MyRemindCell.h"

@interface MyRemindCell()

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

@end

@implementation MyRemindCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadData{
    self.lbTitle.text=self.titleStr;
}

@end
