//
//  ViewController+ShowAlert.h
//  MacauTXH
//
//  Created by canduo on 13/9/2016.
//  Copyright © 2016年 com.zxd.MacauTXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ShowAlert)

-(void)showAlert:(NSString *)message;

-(void)showAlert:(NSString *)message :(NSArray*)actions;

-(void)showAlert:(NSString *)title :(NSString *)message :(NSArray*)actions;


@end
