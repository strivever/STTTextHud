//
//  STTextHudTool.m
//  LiqForDoctors
//
//  Created by StriEver on 16/5/11.
//  Copyright © 2016年 iMac. All rights reserved.
//

#import "STTextHudTool.h"
#import "STTextHud.h"
#import "AppDelegate.h"
#define defaultDely 1.5
//超长时间
#define timeOut   15
@implementation STTextHudTool
+ (void)showText:(NSString *)text{
    [self showText:text withSecond:defaultDely];
}
+ (void)showText:(NSString *)text withSecond:(NSInteger)delay{
    STTextHud * hud = [[STTextHud alloc]init];
    hud.hudStyle = STHudText;
    [hud showText:text withSecond:delay];
}
+ (void)showSuccessText:(NSString *)text{
    [self showSuccessText:text withSecond:defaultDely];
}
+ (void)showSuccessText:(NSString *)text withSecond:(NSInteger)delay{
    STTextHud * hud = [[STTextHud alloc]init];
    hud.hudStyle = STHudSucess;
    [hud showText:text withSecond:delay];
}
+ (void)showErrorText:(NSString *)text{
    [self showErrorText:text withSecond:defaultDely];
}
+ (void)showErrorText:(NSString *)text withSecond:(NSInteger)delay{
    STTextHud * hud = [[STTextHud alloc]init];
    hud.hudStyle = STHudError;
    [hud showText:text withSecond:delay];
}
+ (void)showWaitText:(NSString *)text delay:(NSInteger)delay{
    STTextHud * hud = [[STTextHud alloc]init];
    hud.hudStyle = STHudWait;
    [hud showText:text withSecond:delay];
}
+ (void)showHightPriorityWaitText:(NSString *)text withSecond:(NSInteger)second{
    STTextHud * hud = [[STTextHud alloc]init];
    hud.hudStyle = STHudWait;
    hud.priority = Priority_Hight;
    [hud showText:text withSecond:second];
}
+ (void)showWaitText:(NSString *)text{
    STTextHud * hud = [[STTextHud alloc]init];
    hud.hudStyle = STHudWait;
    [hud showText:text withSecond:timeOut];
}
+ (void)loading{
    [self loadingWithTitle:nil];
}
+(void)loadingWithTitle:(NSString *)title{
    STTextHud * hud = [[STTextHud alloc]init];
    if (!title || title.length == 0) {
        hud.hudStyle = STHudLoadingWithoutTitle;
    }else{
        hud.hudStyle = STHudLoadingWithTitle;
    }
    [hud showText:title withSecond:timeOut];
}
+ (void)showTextTitle:(NSString *)title WithCustomVew:(UIView *)customView{
    STTextHud * hud = [[STTextHud alloc]init];
    hud.priority = Priority_Hight;
    hud.hudStyle = STHudLoadingWithCustomView;
    hud.customView = customView;
    [hud showText:title withSecond:111];
}


+ (void)hideSTHud{
    UIWindow * current_window = nil;
    NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication]windows]reverseObjectEnumerator];
    //NSArray *array = [frontToBackWindows allObjects];
    for (UIWindow *window in frontToBackWindows)
        if (window.windowLevel == UIWindowLevelNormal) {
            current_window = window;
            break;
        }
    [current_window.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[STTextHud class]]) {
            STTextHud * hud = (STTextHud *)obj;
            if (hud.priority !=Priority_Hight) {
               [hud hidStHud];
            }
        }
    }];
}
@end
