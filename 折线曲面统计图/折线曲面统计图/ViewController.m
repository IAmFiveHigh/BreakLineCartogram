//
//  ViewController.m
//  折线曲面统计图
//
//  Created by 我是五高你敢信 on 2017/2/24.
//  Copyright © 2017年 我是五高你敢信. All rights reserved.
//

#import "ViewController.h"
#import "LHCLineView.h"


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *array = @[@"1",@"2",@"3",@"4",@"5",@"6",@"200",@"150",@"60"];
    
    LHCLineView *lineView = [[LHCLineView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_WIDTH) withStyle:LHCChartViewStyleBrokenLine];
    [lineView setDataArray:array];
    [lineView setLineViewTitle:@"demoView"];
    [self.view addSubview:lineView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
