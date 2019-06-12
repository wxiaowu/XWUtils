//
//  NSDate_Util.h
//  XWUtilsDemo
//
//  Created by xiaowu on 2019/6/12.
//  Copyright © 2019年 xiaowu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDateFormatter(Cache)

/* 由于创建Formatter是一个耗时操作, 因此将它缓存起来 */
+ (NSDateFormatter *)xw_formatterFromCacheFormat:(NSString *)format;

@end

@interface NSDateComponents (Component)

/** 获取时间组件
 * @param date : 时间
 * @return : 时间组件
 */
+ (NSDateComponents *)xw_dateComponentsWithDate:(NSDate *)date;

@end

@interface NSDate (transform)

/**
 * 获取当前时间戳，精确到毫秒ms
 */
+ (NSTimeInterval)xw_currentTimeInterval;

/** 将时间戳转格式化时间
 * @param timeInterval : 13位时间戳,精确到毫秒
 * @param format : 日期格式
 * @return : 格式化时间字符串
 */
+ (NSString *)xw_dateFormatStringWithTimeInterval:(NSTimeInterval)timeInterval andFormat:(NSString *)format;

/**
 当前日期-->日期格式化字符串
 
 * @param format : 日期格式
 * @return 当前日期格式化字符串
 */
+ (NSString *)xw_currentFormatStringWithFormat:(NSString *)format;

/**
 date-->日期格式化字符串
 
 * @param format : 日期格式
 * @return 日期格式化字符串
 */
- (NSString *)xw_toFormatStringWithFormat:(NSString *)format;

@end

@interface NSDate (Utils)

/**
 是否比date更早
 
 @param date 参照日期
 @return YES/NO
 */
- (BOOL)xw_isEarlierThan:(NSDate *)date;

/**
 是否比date更晚
 
 @param date 参照日期
 @return YES/NO
 */
- (BOOL)xw_isLaterThan:(NSDate *)date;

/**
 返回当前日期 "星期几"
 
 @return 星期几
 */
- (NSString *)xw_weakdayStr;

/**
 *  比较from和self的时间差值
 */
- (NSDateComponents *)xw_deltaFrom:(NSDate *)from;

/**
 * 是否为今年
 */
- (BOOL)xw_isThisYear;

/**
 * 是否为今天
 */
- (BOOL)xw_isToday;

/**
 * 是否为昨天
 */
- (BOOL)xw_isYesterday;

@end


@interface NSString (DateExtension)
/**
 日期字符串-->日期
 
 @param format 日期字符串的格式
 @return 日期
 */
- (NSDate *)xw_dateValue:(NSString *)format;

/**
 日期字符串-->时间戳
 
 @param format 日期字符串的格式
 @return 日期
 */
- (NSTimeInterval)xw_timeIntervalValue:(NSString *)format;

@end

NS_ASSUME_NONNULL_END





