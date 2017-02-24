//
//  YKHelper.h
//  优快学车
//
//  Created by 云飞孙 on 16/7/29.
//  Copyright © 2016年 云飞孙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 把一些通用/常用的，相对独立的功能，封装在一个类中。
@interface YKHelper : NSObject

+ (void)printModelWithDictionary:(NSDictionary *)dict;

// 传入一个plist文件，返回一个数组
+ (NSArray *)arrayWithPlistFile:(NSString *)file;
// 传入一个plist文件，返回一个字典
+ (NSDictionary *)dictionaryWithPlistFile:(NSString *)file;

+ (NSString *)timeIntervalStringByDateString:(NSString *)dateString;

+ (CGFloat)heightForString:(NSString *)string size:(CGSize)size fontSize:(CGFloat)fontSize;

+ (CGFloat)widthForString:(NSString *)string size:(CGSize)size fontSize:(CGFloat)fontSize;

// 返回今天的日期的字符串:2016-01-14
+ (NSString *)today;

//将多少秒的整数转化为小时、分钟、秒格式
+ (NSString *)timeFormatted:(int)totalSeconds;

//将一个UIImage整体变色
+ (UIImage *)imageWithColor:(UIColor *)color image:(UIImage *)image;

//根据字符串返回一个rgb颜色
+(UIColor *)colorWithHex:(NSString *)hexColor;

//根据view返回它上面所有元素的image
+ (UIImage*)screenView:(UIView *)view;

//返回一个将字符串按照从小到大排序后的字符串
+ (NSString *)stringWithString:(NSString *)string;

//计算文件大小
+ (NSString *)fileSizeWithPath:(NSString *)path;

//判断是否为空对象
+ (BOOL)isNull:(id)object;

//将空对象转化为@""字符串
+ (NSString*)convertNull:(id)object;

@end
