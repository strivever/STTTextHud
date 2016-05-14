//
//  STTextHud.m
//  LiqForDoctors
//
//  Created by StriEver on 16/5/10.
//  Copyright © 2016年 iMac. All rights reserved.
//

#import "STTextHud.h"
#import "AppDelegate.h"
#import "GCLoadingView.h"
#import "NSString+Size.h"
#define  defaeltDelay 1.5
//定义高度
#define kUIScreenSize [UIScreen mainScreen].bounds.size
#define kUIScreenWidth kUIScreenSize.width
#define kUIScreenHeight kUIScreenSize.height
@interface STTextHud ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic)NSTimeInterval delay;
@property (nonatomic,strong) UIView * coverView;
@property (weak, nonatomic) IBOutlet UIView *loadView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelTopContraint;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelBottomContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTopContraint;
@property (nonatomic, strong) UIActivityIndicatorView * waitView;
@property (nonatomic, strong) GCLoadingView *actIndicator;
@end
@implementation STTextHud
- (instancetype)init{
    if (self = [super init]) {
        self = [[NSBundle mainBundle]loadNibNamed:@"STTextHud" owner:nil options:nil][0];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.9];
        self.priority = Priority_Default;
    }
    return self;
}
- (GCLoadingView *)actIndicator{
    if (!_actIndicator) {
        _actIndicator = [[GCLoadingView alloc]initWithFrame:CGRectMake(0, 0, 90, 90)];
        [self.imageV removeFromSuperview];
        self.loadView.hidden = NO;
        if (self.hudStyle == STHudLoadingWithTitle) {
            self.labelTopContraint.constant = 30;
            self.titleLabel.numberOfLines = 1;
            self.bounds = CGRectMake(0, 0, 115, 125);
        }else if(self.hudStyle == STHudLoadingWithoutTitle){
            self.titleLabel.hidden = YES;
            self.bounds = CGRectMake(0, 0, 90, 90);
        }
        [self.loadView addSubview:_actIndicator];
        
    }
    return _actIndicator;
}
- (UIActivityIndicatorView *)waitView{
    if (!_waitView) {
        _waitView =  [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _waitView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [self.imageV addSubview:_waitView];
    }
    return _waitView;
}
- (void)showText:(NSString *)text withSecond:(NSInteger)delay{
    _coverView = [UIView new];
    UIWindow * current_window = nil;
    
    NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication]windows]reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows)
        if (window.windowLevel == UIWindowLevelNormal) {
            current_window = window;
            break;
        }
    //默认优先级
    for (UIView * vv in current_window.subviews) {
        if ([vv isKindOfClass:[self class]]) {
            STTextHud * hud = (STTextHud *)vv;
            if (self.priority >= hud.priority ) {
                [hud hidStHud];
            }
        }
    }
    _coverView.center = current_window.center;
    _coverView.bounds = CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight);
    if (!_backViewIsEnable) {
         [current_window addSubview:_coverView];
    }
    [current_window addSubview:self];
    
    UIFont * font;
    //默认隐藏loadingView
    self.loadView.hidden = YES;
    self.titleLabel.text = text;
    if (self.hudStyle == STHudText) {
        self.imageTopContraint.constant = 20;
        self.imageHeightContraint.constant = 0;
        self.imageV.hidden = YES;
        self.labelTopContraint.constant = 0;
        font = [UIFont systemFontOfSize:15];
        CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, 21)];
        CGFloat hudWidth = textSize.width;
        if (hudWidth <= kUIScreenWidth - 100 - 40) {
            hudWidth += 41;
        }else{
            hudWidth  = kUIScreenWidth - 100;
        }
        self.center = CGPointMake(kUIScreenWidth/2.0, kUIScreenHeight/2.0);
        self.bounds = CGRectMake(0, 0, hudWidth, [text sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(hudWidth - 40, MAXFLOAT)].height + 41);
    }else if(self.hudStyle == STHudLoadingWithTitle || self.hudStyle ==STHudLoadingWithoutTitle){//loading 有标题
        self.center = CGPointMake(kUIScreenWidth/2.0, kUIScreenHeight/2.0);
        [self.actIndicator startAnimating];
        self.titleLabel.text = text;
    }else if(self.hudStyle == STHudLoadingWithCustomView){
        if (self.customView) {
            self.loadView.hidden = NO;
            self.imageV.hidden = YES;
            self.customView.frame = CGRectMake(0, 0, 90, 90);
            [self.loadView addSubview:self.customView];
            if (text.length > 0 && text) {
                self.labelTopContraint.constant = 30;
                self.titleLabel.numberOfLines = 1;
                self.bounds = CGRectMake(0, 0, 115, 125);
            }else{
                self.titleLabel.hidden = YES;
                self.bounds = CGRectMake(0, 0, 90, 90);
            }
        }
    }else{
        if (self.hudStyle == STHudSucess) {
            self.imageV.image = [UIImage imageNamed:@"STSuccess"];
        }else if (self.hudStyle == STHudError){
            self.imageV.image = [UIImage imageNamed:@"STError"];
        }else if (self.hudStyle == STHudWait){
            [self.waitView startAnimating];
            self.imageV.image = nil;
        }
        CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, 21)];
        CGFloat hudWidth = textSize.width;
        if (hudWidth + 40 <= 115) {
            hudWidth = 115;
        }else if(hudWidth + 40 >= kUIScreenWidth - 100 ){
            hudWidth = kUIScreenWidth - 100;
        }else{
            hudWidth += 41;
        }
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        font = [UIFont systemFontOfSize:16];
        self.center = CGPointMake(kUIScreenWidth/2.0, kUIScreenHeight/2.0);
        self.bounds = CGRectMake(0, 0, hudWidth, [text sizeWithFont:font maxSize:CGSizeMake(hudWidth - 40, MAXFLOAT)].height + 101);
    }
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10;
    self.delay = delay;
    [self hideHud];
}
- (void)setBackViewIsEnable:(BOOL)backViewIsEnable{
    _backViewIsEnable = backViewIsEnable;
    if (_backViewIsEnable) {
        [_coverView removeFromSuperview];
    }
}
- (void)hideHud{
    if (self.delay == 0) {
        self.delay = defaeltDelay;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hidStHud];
    });
}
- (void)hidStHud{
    if (_waitView) {
        [_waitView stopAnimating];
    }
    self.hidden = YES;
    _coverView.hidden = YES;
    [_coverView removeFromSuperview];
    [self removeFromSuperview];
}


//
///**
// * 开始动画
// */
//
//- (void)startIndicatorAnimating {
//    
//    if (_actIndicator == nil) {
//        _actIndicator = [[GCLoadingView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
//        NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication]windows]reverseObjectEnumerator];
//        //NSArray *array = [frontToBackWindows allObjects];
//        for (UIWindow *window in frontToBackWindows)
//            if (window.windowLevel == UIWindowLevelNormal) {
//                [window addSubview:_actIndicator];
//                break;
//            }
//        //        [self.view addSubview:_actIndicator];
//        
//        CGRect rect = CGRectZero;//self.view.frame;
//        rect.size.width = kUIScreenWidth /self.view.transform.a;
//        rect.size.height = kUIScreenHeight/self.view.transform.d;
//        _actIndicator.frame = CGRectMake((rect.size.width - _actIndicator.frame.size.width) / 2,
//                                         (rect.size.height -_actIndicator.frame.size.height)/ 2,
//                                         _actIndicator.frame.size.width,
//                                         _actIndicator.frame.size.height);
//    }
//    //    [self.view bringSubviewToFront:_actIndicator];
//    [_actIndicator startAnimating];
//}
//
///**
// * 开始动画  enable 为yes时，表明loading图的时候用户还可以点击界面上的按钮，no则相反
// */
//- (void)startIndicatorAnimatingWithViewEnable:(BOOL)enable {
//    
//    if (_backView == nil && !enable) {
//        _actIndicator = [[GCLoadingView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth , kUIScreenHeight - 64)];
//        CGRect rect = self.view.frame;
//        _backView = [[UIView alloc] initWithFrame:rect];
//        _backView.backgroundColor = [UIColor clearColor];
//        [_backView addSubview:_actIndicator];
//        [self.view addSubview:_backView];
//    }
//    
//    [self.view bringSubviewToFront:_backView];
//    [_actIndicator startAnimating];
//}
//
///**
// * 停止动画
// */
//- (void)stopIndicatorAnimating {
//    
//    [_actIndicator stopAnimating];
//    if (_backView) {
//        [_backView removeFromSuperview];
//    }
//    _backView = nil;
//}
@end
