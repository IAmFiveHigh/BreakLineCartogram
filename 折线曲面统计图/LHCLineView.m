//
//  LHCLineView.m
//  LHCChartView
//
//  Created by 我是五高你敢信 on 2016/11/26.
//  Copyright © 2016年 我是五高你敢信. All rights reserved.
//

#import "LHCLineView.h"
#import "LHCPointsAndLinesView.h"
#import "YKHelper.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface LHCLineView () {
    //x轴每个元素宽度
    CGFloat XWidth;
    //y轴每个元素高度
    CGFloat YHeight;
    CGFloat titleLabelHeigh;
    CGFloat leftMargin;
    CGFloat rigthMargin;
    CGFloat bottomMargin;
}

/** Y轴数据 */
@property (nonatomic, strong) NSArray *coordinateOfY;
/** X轴数据 */
@property (nonatomic, strong) NSArray *coordinateOfX;
//字体样式字典
@property (nonatomic, strong) NSDictionary *textStyleDict;

@property (nonatomic, strong) UIView *backgroundView;
//图标标题label
@property (nonatomic, strong) UILabel *titleLabel;
//图标副标题label
@property (nonatomic, strong) UILabel *viceTitleLabel;
//副标题String
@property (nonatomic, copy) NSString *viceTitleString;

@property (nonatomic, strong) UILabel *lineCoordinateX;

@property (nonatomic, strong) UILabel *lineCoordinateY;

@property (nonatomic, assign) LHCChartViewStyle style;
@end

@implementation LHCLineView



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//MARK: 背景
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, self.bounds.size.width, self.bounds.size.height)];
        _backgroundView.layer.masksToBounds = YES;
        _backgroundView.layer.cornerRadius = 5;

        _backgroundView.backgroundColor = RGBA(45, 200, 160, 1);
        [_backgroundView addSubview:self.titleLabel];
        [_backgroundView addSubview:self.lineCoordinateY];
        [_backgroundView addSubview:self.lineCoordinateX];
        
    }return _backgroundView;
}
//MARK:标题
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 8, SCREEN_WIDTH/2, titleLabelHeigh)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        
    }return _titleLabel;
}

- (UILabel *)viceTitleLabel {
    if (!_viceTitleLabel) {
        
        CGFloat width = [YKHelper widthForString:self.viceTitleString size:CGSizeMake(0, titleLabelHeigh) fontSize:14];
        _viceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-width-20, 8, width, titleLabelHeigh)];
        _viceTitleLabel.text = self.viceTitleString;
        _viceTitleLabel.textColor = [UIColor whiteColor];
        _viceTitleLabel.font = [UIFont systemFontOfSize:14];
        _viceTitleLabel.alpha = 0.8;
    }
    return _viceTitleLabel;
}

//MARK: 横纵坐标系
- (UILabel *)lineCoordinateX {
    if (!_lineCoordinateX) {
        _lineCoordinateX = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, titleLabelHeigh, 2, self.bounds.size.height - titleLabelHeigh - bottomMargin)];
        _lineCoordinateX.backgroundColor = [UIColor whiteColor];
        
    }return _lineCoordinateX;
}

- (UILabel *)lineCoordinateY {
    if (!_lineCoordinateY) {
        _lineCoordinateY = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, self.bounds.size.height - bottomMargin,self.bounds.size.width - leftMargin - rigthMargin, 2)];
        _lineCoordinateY.backgroundColor = [UIColor whiteColor];
    }return _lineCoordinateY;
}

//MARK: 创建横纵坐标轴单位Label
- (void)createLineXUnit {
    for (int i =0 ; i<self.coordinateOfX.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin + XWidth / 2 + XWidth * i, self.bounds.size.height - bottomMargin , XWidth, bottomMargin)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = self.coordinateOfX[i];
        label.textColor = [UIColor whiteColor];
        [self.backgroundView addSubview:label];
    }
}

- (void)createLineYUnit {
    for (NSInteger i = self.coordinateOfY.count-1; i >= 0; i--) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin - 26, self.bounds.size.height - bottomMargin - 13/2 - i*YHeight, 26, 13)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = self.coordinateOfY[i];
        label.textColor = [UIColor whiteColor];
        [self.backgroundView addSubview:label];
    }
}

//MARK: 创建表格线
- (void)createLinesX {
    for (int i=0; i < self.coordinateOfX.count; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(leftMargin + XWidth + i * XWidth, titleLabelHeigh, 1, self.bounds.size.height - titleLabelHeigh - bottomMargin)];
        view.backgroundColor = [UIColor whiteColor];
        view.alpha = 0.5;
        [self.backgroundView addSubview:view];
    }
}

- (void)createLinesY {
    for (int i=1; i<self.coordinateOfY.count; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(leftMargin, titleLabelHeigh + i * YHeight, XWidth * self.coordinateOfX.count, 1)];
        view.backgroundColor = [UIColor whiteColor];
        view.alpha = 0.5;
        [self.backgroundView addSubview:view];
    }
}

//MARK: 创建点
- (void)createPoint {
    NSMutableArray *array = @[].mutableCopy;
    
    //原点
    CGPoint originPoint = CGPointMake(leftMargin, self.bounds.size.height - bottomMargin);
    [array addObject:NSStringFromCGPoint(originPoint)];
    //设置单位width
    NSInteger xTmp = (self.dataArray.count - 1) / 10 + 1;
    CGFloat xUnit = 1 / (CGFloat)xTmp;
    CGFloat widthUnit = XWidth * xUnit;
    
    //
    CGFloat max = [self MaxNumberInDataArray];
    NSInteger shortTime = (NSInteger)max / 6 + 1;
    CGFloat totalHeight = shortTime * 6;
    
    for (int i= 1; i<self.dataArray.count; i++) {
        CGFloat x = i * widthUnit + originPoint.x;
        CGFloat y = originPoint.y - [self.dataArray[i] floatValue] / totalHeight * YHeight * 6;
        [array addObject:NSStringFromCGPoint(CGPointMake(x, y))];
    }
    
    LHCPointsAndLinesView *view = [[LHCPointsAndLinesView alloc] initWithFrame:self.bounds points:array style:_style];
    [self.backgroundView addSubview:view];
    [self.backgroundView sendSubviewToBack:view];
    
}

//MARK:- 设置数据
- (void)setLineViewTitle:(NSString *)LineViewTitle {
    _LineViewTitle = LineViewTitle;
    self.titleLabel.text = _LineViewTitle;
}


- (void)setDataArray:(NSArray *)dataArray {

    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:dataArray];
    [array insertObject:@"0" atIndex:0];
    _dataArray = array;
    
    [self createXAxisArrayAndYAxisArray];
    
    self.viceTitleString = [NSString stringWithFormat:@"平均成绩:%ld分", [self averageNumberInDataArray]];
    [self.backgroundView addSubview: self.viceTitleLabel];
    [self createPoint];
}

//MARK:创建x坐标轴y最标轴数组
- (void)createXAxisArrayAndYAxisArray {
    if (self.dataArray.count <= 10) {
        [self setCoordinateOfX:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"]];
    }else {
        NSMutableArray *xArrays = @[].mutableCopy;
        NSInteger tmp = self.dataArray.count / 10 + 1;
        for (int i = 1; i<=10; i++) {
            NSInteger a = i * tmp;
            [xArrays addObject:[NSString stringWithFormat:@"%ld",a]];
        }
        [self setCoordinateOfX:xArrays];
    }
    
    CGFloat max = [self MaxNumberInDataArray];
    NSInteger unit = (NSInteger)max / 6 + 1;
    NSMutableArray *yArrays = @[].mutableCopy;
    for (int i = 0; i<6; i++) {
        NSInteger a = i * unit;
        [yArrays addObject:[NSString stringWithFormat:@"%ld",a]];
    }
    [self setCoordinateOfY:yArrays];
    
}
//MARK:根据X轴数组和Y轴数组创建界面
- (void)setCoordinateOfX:(NSArray *)coordinateOfX {
    _coordinateOfX = coordinateOfX;
    
    [self createLineXUnit];
    [self createLinesX];
}

- (void)setCoordinateOfY:(NSArray *)coordinateOfY {
    _coordinateOfY = coordinateOfY;
    
    [self createLineYUnit];
    [self createLinesY];
}


- (instancetype)initWithFrame:(CGRect)frame withStyle:(LHCChartViewStyle)style{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        titleLabelHeigh = 44;
        rigthMargin = 15;
        XWidth = (self.bounds.size.width - rigthMargin) / 11;
        YHeight = (self.bounds.size.height - titleLabelHeigh) / 7;
        leftMargin = XWidth;
        bottomMargin = YHeight;
        self.style = style;
        [self addSubview:self.backgroundView];
    }
    return  self;
}
//MARK:- 内部方法
//返回数组最大值
- (CGFloat)MaxNumberInDataArray {
    NSNumber *max = [self.dataArray valueForKeyPath:@"@max.floatValue"];
    return [max floatValue];
}

//FIXME: - 不知为何无法求得平均数了
- (NSInteger)averageNumberInDataArray {
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataArray];
    [array removeObjectAtIndex:0];
    NSLog(@"%@",array);
    NSInteger ave = [[array valueForKeyPath:@"@avg.floatValue"]  integerValue];
    NSLog(@"%ld",ave);
    return ave ;
}


@end
