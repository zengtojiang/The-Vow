//
//  HSDateFormatter.h
//  HSMCBStandardEdition
//
//  Created by jiangll on 13-9-3.
//  Copyright (c) 2013年 hisunsray. All rights reserved.
//
/**
 提供公共的日期时间转换接口
 */
#import <Foundation/Foundation.h>

@interface HSDateFormatter : NSObject


//把秒转换为05:45格式的时间
+(NSString *)secondsToMinutes:(int)seconds;

//把秒转换为00:05:45格式的时间
+(NSString *)secondsToHoursMinutes:(int)seconds;

@end
