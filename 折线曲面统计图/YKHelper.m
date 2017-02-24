//
//  YKHelper.m
//  优快学车
//
//  Created by 云飞孙 on 16/7/29.
//  Copyright © 2016年 云飞孙. All rights reserved.
//

#import "YKHelper.h"

@implementation YKHelper

+ (void)printModelWithDictionary:(NSDictionary *)dict {
    for (NSString *key in dict) {
        printf("@property (nonatomic, copy) NSString <Optional>*%s;\n", [key UTF8String]);
    }
}

+ (NSArray *)arrayWithPlistFile:(NSString *)file {
    NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:nil];
    return [NSArray arrayWithContentsOfFile:path];
}

+ (NSDictionary *)dictionaryWithPlistFile:(NSString *)file {
    NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:nil];
    return [NSDictionary dictionaryWithContentsOfFile:path];
}


+ (NSString *)timeIntervalStringByDateString:(NSString *)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.S";
    NSDate *date = [formatter dateFromString:dateString];
    NSTimeInterval interval = [date timeIntervalSinceNow];
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:interval];
    formatter.dateFormat = @"HH:mm:ss";
    return [formatter stringFromDate:newDate];
}

+ (NSString *)today {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter stringFromDate:date];
}

+ (NSString *)timeFormatted:(int)totalSeconds {
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    //int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

+ (CGFloat)heightForString:(NSString *)string size:(CGSize)size fontSize:(CGFloat)fontSize {
    return [string boundingRectWithSize:CGSizeMake(size.width, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]} context:nil].size.height;
}

+ (CGFloat)widthForString:(NSString *)string size:(CGSize)size fontSize:(CGFloat)fontSize {
    return [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, size.height) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]} context:nil].size.width;
}

+ (UIColor *)colorWithHex:(NSString *)hexColor {
    return [self colorWithHex:hexColor alpha:1.0f];
}

+(UIColor *)colorWithHex:(NSString *)hexColor alpha:(float)alpha{
    //删除空格
    NSString *colorStr = [[hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

    if ([colorStr length] < 6||[colorStr length]>7)
    {
        return [UIColor clearColor];
    }
    
    if ([colorStr hasPrefix:@"#"])
    {
        colorStr = [colorStr substringFromIndex:1];
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    //red
    NSString *redString = [colorStr substringWithRange:range];
    //green
    range.location = 2;
    NSString *greenString = [colorStr substringWithRange:range];
    //blue
    range.location = 4;
    NSString *blueString= [colorStr substringWithRange:range];
    
    // Scan values
    unsigned int red, green, blue;
    [[NSScanner scannerWithString:redString] scanHexInt:&red];
    [[NSScanner scannerWithString:greenString] scanHexInt:&green];
    [[NSScanner scannerWithString:blueString] scanHexInt:&blue];
    return [UIColor colorWithRed:((float)red/ 255.0f) green:((float)green/ 255.0f) blue:((float)blue/ 255.0f) alpha:alpha];
}


+ (UIImage *)imageWithColor:(UIColor *)color image:(UIImage *)image {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark -截屏

+ (UIImage*)screenView:(UIView *)view {
    CGRect rect = view.frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //[self.navigationController.view.layer renderInContext:context];带导航的截图
    [view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark -返回一个将字符串按照从小到大排序后的字符串
+ (NSString *)stringWithString:(NSString *)string {
    
    NSMutableArray *array = [[NSMutableArray alloc ] init];
    for (int i=0; i<string.length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *substring = [string substringWithRange:range];
        [array addObject:substring];
    }
    NSArray *tmp = [array sortedArrayUsingSelector:@selector(compare:)];
    return [tmp componentsJoinedByString:@""];
}

#pragma mark -计算文件大小
+ (NSString *)fileSizeWithPath:(NSString *)path
{
    // 总大小
    unsigned long long size = 0;
    NSString *sizeText = nil;
    // 文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 文件属性
    NSDictionary *attrs = [mgr attributesOfItemAtPath:path error:nil];
    // 如果这个文件或者文件夹不存在,或者路径不正确直接返回0;
    if (attrs == nil) {
        return @"0";
    }
    
    if ([attrs.fileType isEqualToString:NSFileTypeDirectory]) { // 如果是文件夹
        // 获得文件夹的大小  == 获得文件夹中所有文件的总大小
        NSDirectoryEnumerator *enumerator = [mgr enumeratorAtPath:path];
        for (NSString *subpath in enumerator) {
            // 全路径
            NSString *fullSubpath = [path stringByAppendingPathComponent:subpath];
            // 累加文件大小
            size += [mgr attributesOfItemAtPath:fullSubpath error:nil].fileSize;
        }
    } else { // 如果是文件
        size = attrs.fileSize;
    }
    
    if (size >= pow(10, 9)) { // size >= 1GB
        sizeText = [NSString stringWithFormat:@"%.2fG", size / pow(10, 9)];
    } else if (size >= pow(10, 6)) { // 1GB > size >= 1MB
        sizeText = [NSString stringWithFormat:@"%.2fM", size / pow(10, 6)];
    } else if (size >= pow(10, 3)) { // 1MB > size >= 1KB
        sizeText = [NSString stringWithFormat:@"%.2fK", size / pow(10, 3)];
    } else { // 1KB > size
        sizeText = [NSString stringWithFormat:@"%zdB", size];
    }
    return sizeText;
}

+ (BOOL)isNull:(id)object {
    // 判断是否为空串
    if ([object isEqual:[NSNull null]]) {
        return NO;
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        return NO;
    }
    else if (object==nil){
        return NO;
    }
    return YES;
}

+ (NSString*)convertNull:(id)object {
    
    // 转换空串
    
    if ([object isEqual:[NSNull null]]) {
        return @" ";
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        return @" ";
    }
    else if (object==nil){
        return @"无";
    }
    return object;
    
}

@end
