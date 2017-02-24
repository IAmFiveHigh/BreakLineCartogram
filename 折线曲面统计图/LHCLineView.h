//
//  LHCLineView.h
//  LHCChartView
//
//  Created by 我是五高你敢信 on 2016/11/26.
//  Copyright © 2016年 我是五高你敢信. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, LHCChartViewStyle) {
    LHCChartViewStyleBrokenLine,
    LHCChartViewStyleCurveLine
};

@interface LHCLineView : UIView

/** 数据源数组 */
@property (nonatomic, strong) NSArray *dataArray;
/** 图表title */
@property (nonatomic, copy) NSString *LineViewTitle;

- (instancetype)initWithFrame:(CGRect)frame withStyle:(LHCChartViewStyle)style;

@end
