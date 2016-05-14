//
//  STTextHud.h
//  LiqForDoctors
//
//  Created by StriEver on 16/5/10.
//  Copyright © 2016年 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, STHudStyle) {
    STHudError,
    STHudSucess,
    STHudCustomView,
    STHudText,
    STHudWait,
    STHudLoadingWithTitle,
    STHudLoadingWithoutTitle,
    STHudLoadingWithCustomView,
};
//设置显示优先级
typedef NS_ENUM(NSInteger, ShowPriority) {
    Priority_Hight = 1000,
    Priority_Default = 750,
    Priority_Low = 500,
};
@interface STTextHud : UIView
@property (nonatomic)STHudStyle hudStyle;
@property (nonatomic)ShowPriority priority;
/**
 *  自定义View
 */
@property (nonatomic, strong) UIView * customView;
/**
 *  背景是否可以点击
 */
@property (nonatomic, assign) BOOL backViewIsEnable;
- (void)showText:(NSString *)text withSecond:(NSInteger)delay;
- (void)hidStHud;
@end
