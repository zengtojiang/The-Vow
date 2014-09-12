//
//  HSDateFormatter.m
//  HSMCBStandardEdition
//
//  Created by jiangll on 13-9-3.
//  Copyright (c) 2013年 hisunsray. All rights reserved.
//

#import "HSDateFormatter.h"

@implementation HSDateFormatter

//把秒转换为05:45格式的时间
+(NSString *)secondsToMinutes:(int)seconds
{
    //int hours=seconds/3600;
    //int minutes=seconds/60;
    int newSeconds=seconds%60;
    int hours=seconds/3600;
    int minutes=(seconds-hours*3600)/60;
    if (hours<0) {
        hours=0;
    }
    if (minutes<0) {
        minutes=0;
    }
    if (newSeconds<0) {
        newSeconds=0;
    }
    if (hours>0) {
        return [NSString stringWithFormat:@"%02d:%02d:%02d",hours,minutes,newSeconds];
    }
    return [NSString stringWithFormat:@"%02d:%02d",minutes,newSeconds];
}

//把秒转换为00:05:45格式的时间
+(NSString *)secondsToHoursMinutes:(int)seconds
{
    int newSeconds=seconds%60;
    int hours=seconds/3600;
    int minutes=(seconds-hours*3600)/60;
    if (hours<0) {
        hours=0;
    }
    if (minutes<0) {
        minutes=0;
    }
    if (newSeconds<0) {
        newSeconds=0;
    }
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours,minutes,newSeconds];
}

@end
