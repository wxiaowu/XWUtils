//
//  NSDate_Util.m
//  XWUtilsDemo
//
//  Created by xiaowu on 2019/6/12.
//  Copyright © 2019年 xiaowu. All rights reserved.
//

#import "NSDate_Util.h"

@implementation NSDateFormatter (Cache)

static NSMutableDictionary<NSString *, NSDateFormatter *> *xw_formatter_cache;
+ (NSDateFormatter *)xw_formatterFromCacheFormat:(NSString *)format{
    if (!xw_formatter_cache) {
        xw_formatter_cache = [NSMutableDictionary new];
    }
    NSDateFormatter *formatter = nil;
    formatter = [xw_formatter_cache objectForKey:format] ?: ({
        NSDateFormatter *newFormatter = [NSDateFormatter new];
        [newFormatter setTimeZone:[NSTimeZone localTimeZone]]; //设置本地时区
        newFormatter.dateFormat = format;
        [xw_formatter_cache setObject:newFormatter forKey:format];
        newFormatter;
    });
    return formatter;
}

@end

@implementation NSDateComponents (Component)

+ (NSDateComponents *)xw_dateComponentsWithDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *comps  = [calendar components:unitFlags fromDate:date];
    return comps;
}

@end

@implementation NSDate (transform)

#pragma mark ----日期转时间戳----
+ (NSTimeInterval)xw_currentTimeInterval {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0]; // 获取当前时间0秒后的时间
    NSTimeInterval time = [date timeIntervalSince1970] * 1000; // *1000 是精确到毫秒，不乘就是精确到秒
    return time;
}

#pragma mark ----时间戳转格式化日期字符串----
+ (NSString *)xw_dateFormatStringWithTimeInterval:(NSTimeInterval)timeInterval andFormat:(NSString *)format {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval / 1000];
    return [[NSDateFormatter xw_formatterFromCacheFormat:format] stringFromDate: date];
}

#pragma mark ----日期转格式化日期字符串----
+ (NSString *)xw_currentFormatStringWithFormat:(NSString *)format {
    NSDate *date = [NSDate date];
    return [date xw_toFormatStringWithFormat:format];
}

- (NSString *)xw_toFormatStringWithFormat:(NSString *)format {
    return [[NSDateFormatter xw_formatterFromCacheFormat:format] stringFromDate:self];
}

@end

@implementation NSDate (Utils)

#pragma mark ----日期比较----
- (BOOL)xw_isEarlierThan:(NSDate *)date{
    return [self compare:date] == NSOrderedAscending;
}

- (BOOL)xw_isLaterThan:(NSDate *)date{
    return [self compare:date] == NSOrderedDescending;
}

#pragma mark ----星期几----
- (NSString *)xw_weakdayStr{
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday fromDate:self];
    switch (comps.weekday) {
        case 1:
            return @"星期天";
        case 2:
            return @"星期一";
        case 3:
            return @"星期二";
        case 4:
            return @"星期三";
        case 5:
            return @"星期四";
        case 6:
            return @"星期五";
    }
    return @"星期六";
}

#pragma mark ----比较差值----
- (NSDateComponents *)xw_deltaFrom:(NSDate *)from {
    // 日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 比较时间
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:from toDate:self options:0];
    
}

#pragma mark ----判断时间----
- (BOOL)xw_isThisYear {
    // 日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];
    
    return nowYear == selfYear;
}

//- (BOOL)xw_isToday {
//    // 日历
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//
//    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
//
//    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
//    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
//
//    return nowCmps.year == selfCmps.year
//    && nowCmps.month == selfCmps.month
//    && nowCmps.day == selfCmps.day;
//}

- (BOOL)xw_isToday {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    NSString *selfString = [fmt stringFromDate:self];
    
    return [nowString isEqualToString:selfString];
}

- (BOOL)xw_isYesterday {
    // 2014-12-31 23:59:59 -> 2014-12-31
    // 2015-01-01 00:00:01 -> 2015-01-01
    
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSDate *nowDate = [fmt dateFromString:[fmt stringFromDate:[NSDate date]]];
    NSDate *selfDate = [fmt dateFromString:[fmt stringFromDate:self]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.year == 0
    && cmps.month == 0
    && cmps.day == 1;
}


@end

@implementation NSString (DateExtension)
#pragma mark ----格式化日期字符串转日期----
- (NSDate *)xw_dateValue:(NSString *)format {
    return [[NSDateFormatter xw_formatterFromCacheFormat:format] dateFromString:self];
}

#pragma mark ----格式化日期字符串转时间戳----
- (NSTimeInterval)xw_timeIntervalValue:(NSString *)format {
    return [[self xw_dateValue:format] timeIntervalSince1970];
}

@end

