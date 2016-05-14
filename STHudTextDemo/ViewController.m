//
//  ViewController.m
//  STHudTextDemo
//
//  Created by StriEver on 16/5/14.
//  Copyright © 2016年 StriEver. All rights reserved.
//

#import "ViewController.h"
#import "STTextHud/STTextHudTool.h"
#define customDelay 3
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnClickAction:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
            [STTextHudTool showText:@"我是没有设置延迟的提示信息哦"];
            break;
        case 1:
            [STTextHudTool showText:@"我是设置了延迟的提示信息哦" withSecond:customDelay];
            break;
        case 2:
            [STTextHudTool showSuccessText:@"提交成功"];
            break;
        case 3:
            [STTextHudTool showSuccessText:@"提交成功" withSecond:customDelay];
            break;
        case 4:
            [STTextHudTool showErrorText:@"密码错误"];
            break;
        case 5:
            [STTextHudTool showErrorText:@"网络较差" withSecond:customDelay];
            break;
        case 6:
            [STTextHudTool loading];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(customDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [STTextHudTool hideSTHud];
            });
            break;
        case 7:
            [STTextHudTool loadingWithTitle:@"加载中..."];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(customDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [STTextHudTool hideSTHud];
            });
            break;
        case 8:
            [STTextHudTool showWaitText:@"正在加载数据"];
            break;
        case 9:
            [STTextHudTool showWaitText:@"正在加载" delay:customDelay];
            break;
            
        default:
            break;
    }
}

@end
