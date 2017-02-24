//
//  LHCPointsAndLinesView.m
//  LHCChartView
//
//  Created by 我是五高你敢信 on 2016/11/28.
//  Copyright © 2016年 我是五高你敢信. All rights reserved.
//


#import "LHCPointsAndLinesView.h"

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


@interface LHCPointsAndLinesView ()
//
@property (nonatomic, strong) NSArray *points;
//
@property (nonatomic, assign) CGPoint lastPoint;
//风格
@property (nonatomic, assign) LHCLineViewStyle style;

@end

@implementation LHCPointsAndLinesView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (instancetype)initWithFrame:(CGRect)frame points:(NSArray *)points style:(LHCLineViewStyle)style {
    if (self = [super initWithFrame:frame]) {
        self.points = points;
        self.backgroundColor = RGBA(45, 200, 160, 1);
        self.style = style;
    }return self;
}

- (void)drawRect:(CGRect)rect {
    
    
    CGPoint originPoint = CGPointFromString(self.points[0]);

    
    //主连线
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:originPoint];
    
    //遮罩层连线
    UIBezierPath *shadowPath = [UIBezierPath bezierPath];
    shadowPath.lineCapStyle = kCGLineCapRound;
    shadowPath.lineJoinStyle = kCGLineJoinMiter;
    [shadowPath moveToPoint:originPoint];
    
    for (int i = 1; i < self.points.count; i++) {
        CGPoint prePoint = CGPointFromString(self.points[i-1]);
        CGPoint nowPoint = CGPointFromString(self.points[i]);
        //曲线
        if (_style == LHCLineViewStyleCurveLine) {
            [path addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+prePoint.x)/2, prePoint.y) controlPoint2:CGPointMake((nowPoint.x+prePoint.x)/2, nowPoint.y)];
        }else { //折线
            [path addLineToPoint:nowPoint];

            CGContextRef ctx = UIGraphicsGetCurrentContext();
            CGContextAddArc(ctx, nowPoint.x, nowPoint.y, 3, 0, M_PI*2, YES);
            [[UIColor whiteColor] set];
            CGContextFillPath(ctx);
            
        }
        
        [shadowPath addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+prePoint.x)/2, prePoint.y) controlPoint2:CGPointMake((nowPoint.x+prePoint.x)/2, nowPoint.y)];
        
        if (i == self.points.count - 1) {
            [path moveToPoint:nowPoint];//…………
            self.lastPoint = nowPoint;
        }
    }
    //遮罩层连线到右下角然后回到原点
    CGPoint rightBottomPoint = CGPointMake(self.lastPoint.x, originPoint.y);
    [shadowPath addLineToPoint:rightBottomPoint];
    
    [shadowPath addLineToPoint:originPoint];
    
    if (_style == LHCLineViewStyleCurveLine) {
        //遮罩层
        CAShapeLayer *shadowLayer = [CAShapeLayer layer];
        shadowLayer.path = shadowPath.CGPath;
        shadowLayer.fillColor = [UIColor greenColor].CGColor;
        
        //渐变层
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(-self.bounds.size.width, 44, self.bounds.size.width * 2, originPoint.y);
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        gradientLayer.cornerRadius = 5;
        gradientLayer.masksToBounds = YES;
        gradientLayer.colors = @[(__bridge id)RGBA(45, 200, 160, 1).CGColor,(__bridge id)RGBA(45, 200, 160, 0).CGColor];
        gradientLayer.locations = @[@(0.5f)];
        
        CALayer *baseLayer = [CALayer layer];
        [baseLayer addSublayer:gradientLayer];
        [baseLayer setMask:shadowLayer];
        [self.layer addSublayer:baseLayer];

        CABasicAnimation *anmi1 = [CABasicAnimation animation];
        anmi1.keyPath = @"bounds";
        anmi1.duration = 2.0f;
        anmi1.fromValue = [NSValue valueWithCGRect:CGRectMake(-self.bounds.size.width, 0, 0, originPoint.y)];
        anmi1.toValue = [NSValue valueWithCGRect:CGRectMake(-self.bounds.size.width, 0, 2*self.lastPoint.x, originPoint.y)];
        
        anmi1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        anmi1.fillMode = kCAFillModeForwards;
        anmi1.autoreverses = NO;
        anmi1.removedOnCompletion = NO;
        
        [gradientLayer addAnimation:anmi1 forKey:@"bounds"];
    }
    
    
    CAShapeLayer *animateLayer = [CAShapeLayer layer];
    animateLayer.path = path.CGPath;
    animateLayer.fillColor = [UIColor clearColor].CGColor;
    animateLayer.strokeColor = [UIColor whiteColor].CGColor;
    animateLayer.lineWidth = 2;
    [self.layer addSublayer:animateLayer];
    
    CABasicAnimation *animate = [CABasicAnimation animation];
    animate.keyPath = @"strokeEnd";
    animate.fromValue = [NSNumber numberWithFloat:0];
    animate.toValue = [NSNumber numberWithFloat:1.0f];
    animate.duration =2.0f;
    animate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animate.autoreverses = NO;
    [animateLayer addAnimation:animate forKey:@"stroke"];

    
}


@end
