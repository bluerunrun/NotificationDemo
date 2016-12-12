//
//  ViewController+ShowAlert.m
//  MacauTXH
//
//  Created by canduo on 13/9/2016.
//  Copyright © 2016年 com.zxd.MacauTXH. All rights reserved.
//

#import "UIViewController+ShowAlert.h"

@implementation  UIViewController (ShowAlert)

-(void)showAlert:(NSString *)message{
    UIAlertAction * cancle=[UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleCancel handler:nil];
    [self showAlert:@"提示" :message :@[cancle]];
}

-(void)showAlert:(NSString *)message :(NSArray*)actions{
    [self showAlert:@"提示" :message :actions];
}

-(void)showAlert:(NSString *)title :(NSString *)message :(NSArray*)actions{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if(actions){
        for (UIAlertAction * action in actions) {
            [alert addAction:action];
        }
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
