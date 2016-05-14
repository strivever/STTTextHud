//
//  STTextHudTool.h
//  LiqForDoctors
//
//  Created by StriEver on 16/5/11.
//  Copyright © 2016年 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface STTextHudTool : NSObject
/**
 *  错误提示 默认
 *
 *  @param text 文本
 */
+ (void)showErrorText:(NSString *)text;
/**
 *  粗无提示
 *
 *  @param text  文本
 *  @param delay 显示时间
 */
+ (void)showErrorText:(NSString *)text withSecond:(NSInteger)delay;
/**
 *  纯文本提示
 *
 *  @param text 问题
 */
+ (void)showText:(NSString *)text;
/**
 *  纯文本提示
 *
 *  @param text  文本
 *  @param delay 显示时间
 */
+ (void)showText:(NSString *)text withSecond:(NSInteger)delay;

/**
 *  成功提示
 *
 *  @param text 文本
 */
+ (void)showSuccessText:(NSString *)text;
/**
 *  成功提示
 *
 *  @param text  文本
 *  @param delay 显示时间
 */
+ (void)showSuccessText:(NSString *)text withSecond:(NSInteger)delay;
/**
 *  菊花等待提示
 *
 *  @param text 文本
 */
+ (void)showWaitText:(NSString *)text;
/**
 *  菊花等待提示
 *
 *  @param text  文本
 *  @param delay 显示时间
 */
+ (void)showWaitText:(NSString *)text delay:(NSInteger)delay;
//显示级别较高，不会被其他的hud移除 直到自己消失
+ (void)showHightPriorityWaitText:(NSString *)text withSecond:(NSInteger)second;
/**
 *  网络请求加载界面
 */
+ (void)loading;
/**
 *  带标题的网络请求加载界面
 *
 *  @param title 标题
 */
+(void)loadingWithTitle:(NSString *)title;
/**
 *  隐藏hud
 */
+ (void)hideSTHud;
+ (void)showTextTitle:(NSString *)title WithCustomVew:(UIView *)customView;
@end
