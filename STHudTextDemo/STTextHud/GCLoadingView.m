//
//  GCLoadingView.m
//  LiquoriceDoctorProject
//
//  Created by HenryCheng on 15/12/4.
//  Copyright © 2015年 iMac. All rights reserved.
//

#define kNotification_AppNotify @"APP_NOTIFICATION"
#define kAppActiveState         @"AppActiveState"
#define kAppDidBecomeActive     @"AppDidBecomeActive"
#define kBgSize 90.0f
#define kEdgeSize 0.0f
#define kAnimationDuration 1.0f

#import "GCLoadingView.h"

@interface GCLoadingView ()

@property (strong, nonatomic) UIImageView *bgImageView;
@property (strong, nonatomic) UIImageView *aniImageView;
@property (nonatomic ,assign) BOOL isAnimating;
@property (nonatomic, strong) CAShapeLayer *indefiniteAnimatedLayer;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat strokeThickness;
@property (nonatomic, strong) UIColor *strokeColor;

@end

@implementation GCLoadingView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.radius = 24.0f;
        self.strokeThickness = 2.0f;
        self.strokeColor = [UIColor whiteColor];

        self.bgImageView = [[UIImageView alloc] init];
        self.bgImageView.frame = CGRectMake((CGRectGetWidth(self.frame) - kBgSize)/2, (CGRectGetHeight(self.frame) - kBgSize)/2, kBgSize, kBgSize);
        self.bgImageView.image = nil;
        [self addSubview:self.bgImageView];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.9];
        self.aniImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kEdgeSize, kEdgeSize, kBgSize - 2 * kEdgeSize, kBgSize - 2 * kEdgeSize)];
        [self.bgImageView addSubview:self.aniImageView];

        self.isAnimating = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(customActivityIndicatorView_appStateChanedNotification:) name:kNotification_AppNotify object:nil];
    }
    return self;
}

//修改app从后台切入前台的时候动画停止的bug
- (void)customActivityIndicatorView_appStateChanedNotification:(NSNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    if ([[userInfo objectForKey:kAppActiveState] isEqualToString:kAppDidBecomeActive]) {
        if(self.isAnimating){
            [self setIsAnimating:YES];
        }
    }
}

- (void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    self.bgImageView.frame = CGRectMake((CGRectGetWidth(self.frame) - kBgSize)/2, (CGRectGetHeight(self.frame) - kBgSize)/2, kBgSize, kBgSize);
}

- (void)startAnimating {
    
    self.isAnimating = YES;
}

- (void)setIsAnimating:(BOOL)isAnimating {
    
    _isAnimating = isAnimating;
    if (isAnimating) {

//        NSMutableArray *anmationImage1 = [NSMutableArray array];
//        for (int i = 0; i < 4; i ++) {
//            NSString *imageStr = [NSString stringWithFormat:@"loading_%d",i+1];
//            [anmationImage1 addObject:[UIImage imageNamed:imageStr]];
//            
//        }
//        self.aniImageView.animationImages = anmationImage1;
//        self.aniImageView.animationDuration = kAnimationDuration;
//        self.aniImageView.animationRepeatCount = GID_MAX;
//        [self.aniImageView startAnimating];
        CALayer *layer = self.indefiniteAnimatedLayer;
        [self.bgImageView.layer addSublayer:layer];
        layer.position = CGPointMake(CGRectGetWidth(self.bgImageView.bounds) / 2, CGRectGetHeight(self.bgImageView.bounds) / 2);
        
    } else {

    }
    self.hidden = !isAnimating;
}

- (void)stopAnimating {
    
    self.isAnimating = NO;
    [_indefiniteAnimatedLayer removeFromSuperlayer];
    _indefiniteAnimatedLayer = nil;
}
- (CAShapeLayer*)indefiniteAnimatedLayer {
    if(!_indefiniteAnimatedLayer) {
        CGPoint arcCenter = CGPointMake(self.radius+self.strokeThickness/2+5, self.radius+self.strokeThickness/2+5);
        CGRect rect = CGRectMake(0.0f, 0.0f, arcCenter.x*2, arcCenter.y*2);
        
        UIBezierPath* smoothedPath = [UIBezierPath bezierPathWithArcCenter:arcCenter
                                                                    radius:self.radius
                                                                startAngle:(CGFloat) (M_PI*3/2)
                                                                  endAngle:(CGFloat) (M_PI/2+M_PI*5)
                                                                 clockwise:YES];
        
        _indefiniteAnimatedLayer = [CAShapeLayer layer];
        _indefiniteAnimatedLayer.contentsScale = [[UIScreen mainScreen] scale];
        _indefiniteAnimatedLayer.frame = rect;
        _indefiniteAnimatedLayer.fillColor = [UIColor clearColor].CGColor;
        _indefiniteAnimatedLayer.strokeColor = self.strokeColor.CGColor;
        _indefiniteAnimatedLayer.lineWidth = self.strokeThickness;
        _indefiniteAnimatedLayer.lineCap = kCALineCapRound;
        _indefiniteAnimatedLayer.lineJoin = kCALineJoinBevel;
        _indefiniteAnimatedLayer.path = smoothedPath.CGPath;
        
        CALayer *maskLayer = [CALayer layer];
        
        maskLayer.contents = (__bridge id)[[UIImage imageNamed:@"angle-mask@3x"] CGImage];
        maskLayer.frame = _indefiniteAnimatedLayer.bounds;
        _indefiniteAnimatedLayer.mask = maskLayer;
        
        NSTimeInterval animationDuration = 1;
        CAMediaTimingFunction *linearCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        animation.fromValue = (id) 0;
        animation.toValue = @(M_PI*2);
        animation.duration = animationDuration;
        animation.timingFunction = linearCurve;
        animation.removedOnCompletion = NO;
        animation.repeatCount = INFINITY;
        animation.fillMode = kCAFillModeForwards;
        animation.autoreverses = NO;
        [_indefiniteAnimatedLayer.mask addAnimation:animation forKey:@"rotate"];
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.duration = animationDuration;
        animationGroup.repeatCount = INFINITY;
        animationGroup.removedOnCompletion = NO;
        animationGroup.timingFunction = linearCurve;
        
        CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        strokeStartAnimation.fromValue = @0.015;
        strokeStartAnimation.toValue = @0.515;
        
        CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        strokeEndAnimation.fromValue = @0.485;
        strokeEndAnimation.toValue = @0.985;
        
        animationGroup.animations = @[strokeStartAnimation, strokeEndAnimation];
        [_indefiniteAnimatedLayer addAnimation:animationGroup forKey:@"progress"];
        
    }
    return _indefiniteAnimatedLayer;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotification_AppNotify object:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
