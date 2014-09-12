//
//  ZLHistoryManager.h
//  ScooterBoy
//
//  Created by libs on 14-3-16.
//  Copyright (c) 2014年 icow. All rights reserved.
//
/**
 历史记录保持器
 */
#import <Foundation/Foundation.h>
#import "ZLAssetCell.h"

@interface ZLHistoryManager : NSObject

//初始化资产
+(void)initialAssets:(int)coin;

#pragma mark - 金币
//get最新分数
+(int)getLastScore;

//set最新分数
+(void)setLastScore:(int)score;

//添加分数
+(void)addNewScore:(int)score;

//减少分数
+(void)reduceScore:(int)score;

#pragma mark - miss
+(int)getLastMissCount;

+(void)setLastMissCount:(int)count;

//添加分数
+(void)addNewMissCount:(int)misscount;

//减少分数
+(void)reduceMissCount;

//是否自动miss
+(BOOL)isAutoMiss;

+(void)changeAutoMissStatus;

#pragma mark - 是否点击过option button
+(BOOL)hasTapOptionButton;

+(void)setHasTapOptionButton;

#pragma  mark - 资产

//获取资产列表
+(NSArray *)getAllAssetObjects;

//添加资产
+(void)addNewAssets:(ZLAssetObject *)assetObject;

//出售资产，返回是否记录成功
+(BOOL)sellAssets:(ZLAssetObject *)assetObject;

//收割资产产出，金币入账、更新收割时间
+(void)reapAssets:(ZLAssetObject *)assetObject;

#pragma mark - 游戏方式
+(NSArray *)getSelectedGameMode;

+(void)addGameMode:(ZL_GAME_MODE)mode;

+(void)deleteGameMode:(ZL_GAME_MODE)mode;

#pragma mark - 筹码类型
+(ZL_CHIPS_TYPE)getChipType;

+(void)setChipType:(ZL_CHIPS_TYPE)type;

#pragma  mark - 等级
+(int)getLastClass;

+(void)addNewClass:(int)addNumber;

+(NSDate *)getLastLoginTime;

+(void)setLastLoginTime:(NSDate *)date;

#pragma mark - 其他设置

//音效开关是否打开
+(BOOL)voiceOpened;

//设置音效开关
+(void)setVoiceOpened:(BOOL)open;

//背景音乐开关是否打开
+(BOOL)musicOpened;

//设置背景音乐开关
+(void)setMusicOpened:(BOOL)open;

//是否是第一次进入应用
+(BOOL)isFirstLaunch;

//设置为不是第一次进入应用
+(void)setFirstLaunch;

@end
