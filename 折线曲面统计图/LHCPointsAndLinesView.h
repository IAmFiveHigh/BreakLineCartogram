//
//  LHCPointsAndLinesView.h
//  LHCChartView
//
//  Created by 我是五高你敢信 on 2016/11/28.
//  Copyright © 2016年 我是五高你敢信. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, LHCLineViewStyle) {
    LHCLineViewStyleBrokenLine,
    LHCLineViewStyleCurveLine
};

@interface LHCPointsAndLinesView : UIView

- (instancetype)initWithFrame:(CGRect)frame points:(NSArray *)points style:(LHCLineViewStyle)style;

@end
