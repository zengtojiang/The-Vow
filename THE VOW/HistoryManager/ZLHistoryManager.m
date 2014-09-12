//
//  ZLHistoryManager.m
//  ScooterBoy
//
//  Created by libs on 14-3-16.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import "ZLHistoryManager.h"

@implementation ZLHistoryManager

//初始化资产
+(void)initialAssets:(int)coin
{
//    int initCoin=(arc4random()%9+1)*powf(10,arc4random()%3+2);
    [ZLHistoryManager setLastScore:coin];
    NSString *assetPath=[[NSBundle mainBundle] pathForResource:@"assets" ofType:@"plist"];
    NSArray *assetArray=[NSArray arrayWithContentsOfFile:assetPath];
    if (assetArray&&[assetArray count]) {
        ZLAssetObject *assetObject=[[ZLAssetObject alloc] initWithData:[assetArray firstObject]];
        assetObject.genDuration=assetObject.genDuration*60;
        [ZLHistoryManager addNewAssets:assetObject];
    }
    [ZLHistoryManager setLastMissCount:2];
}

#pragma mark - 金币
//get最新分数
+(int)getLastScore
{
    return (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ZL_LAST_SCORE"];
}

//set最新分数
+(void)setLastScore:(int)score
{
    [[NSUserDefaults standardUserDefaults] setInteger:score forKey:@"ZL_LAST_SCORE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//添加分数
+(void)addNewScore:(int)score
{
    int lastscore=[ZLHistoryManager getLastScore];
    [ZLHistoryManager setLastScore:lastscore+score];
}

//减少分数
+(void)reduceScore:(int)score
{
    int lastscore=[ZLHistoryManager getLastScore];
    [ZLHistoryManager setLastScore:lastscore-score];
}

#pragma mark - miss
+(int)getLastMissCount;
{
    return (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ZL_MISS_COUNT"];
}

+(void)setLastMissCount:(int)count;
{
    [[NSUserDefaults standardUserDefaults] setInteger:count forKey:@"ZL_MISS_COUNT"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//添加分数
+(void)addNewMissCount:(int)misscount;
{
    int lastcount=[ZLHistoryManager getLastMissCount];
    [ZLHistoryManager setLastMissCount:lastcount+misscount];
}

//减少分数
+(void)reduceMissCount;
{
    int lastcount=[ZLHistoryManager getLastMissCount];
    [ZLHistoryManager setLastMissCount:lastcount-1];
}

//是否自动miss
+(BOOL)isAutoMiss
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"ZL_AUTO_MISS"];
}

+(void)changeAutoMissStatus
{
    BOOL isAuto=[ZLHistoryManager isAutoMiss];
    [[NSUserDefaults standardUserDefaults] setBool:!isAuto forKey:@"ZL_AUTO_MISS"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 是否点击过option button
+(BOOL)hasTapOptionButton
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"ZL_TAPPED_OPTION"];
}

+(void)setHasTapOptionButton
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ZL_TAPPED_OPTION"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma  mark - 资产

//获取资产列表
+(NSArray *)getAllAssetObjects
{
    NSArray *assets =[[NSUserDefaults standardUserDefaults] arrayForKey:@"ZL_ASSET_LIST"];
    if (!assets||![assets count]) {
        return nil;
    }
    NSMutableArray *assetArray=[NSMutableArray arrayWithCapacity:[assets count]];
    for (int i=0; i<[assets count]; i++) {
        ZLAssetObject *item=[[ZLAssetObject alloc] initWithData:[assets objectAtIndex:i]];
        item.assetIndex=i;
        [assetArray addObject:item];
    }
    return assetArray;
}

//获取资产列表
+(NSArray *)getAllAssets
{
    NSArray *assets =[[NSUserDefaults standardUserDefaults] arrayForKey:@"ZL_ASSET_LIST"];
    if (!assets||![assets count]) {
        return nil;
    }
    return assets;
}

//添加资产
+(void)addNewAssets:(ZLAssetObject *)assetObject
{
    NSArray *lastAssets=[ZLHistoryManager getAllAssets];
    NSMutableDictionary *dicData=[NSMutableDictionary dictionaryWithDictionary:[assetObject dicData]];
    [dicData setObject:[NSDate date] forKey:@"date"];
    NSMutableArray *assetsArray=[NSMutableArray array];
    if (lastAssets) {
        [assetsArray addObjectsFromArray:lastAssets];
    }
    [assetsArray addObject:dicData];
    [[NSUserDefaults standardUserDefaults] setObject:assetsArray forKey:@"ZL_ASSET_LIST"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)sellAssets:(ZLAssetObject *)assetObject;
{
    NSArray *lastAssets=[ZLHistoryManager getAllAssets];
    if (lastAssets) {
        int assetsCount=(int)[lastAssets count];
        if (assetsCount>assetObject.assetIndex) {
            [ZLHistoryManager addNewScore:assetObject.assetValue*ZL_ASSETS_SELL_DISCOUNT];
            NSMutableArray *assetsArray=[NSMutableArray arrayWithArray:lastAssets];
            [assetsArray removeObjectAtIndex:assetObject.assetIndex];
            [[NSUserDefaults standardUserDefaults] setObject:assetsArray forKey:@"ZL_ASSET_LIST"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            return YES;
        }
    }
    return NO;
}

//收割资产产出
+(void)reapAssets:(ZLAssetObject *)assetObject
{
    NSArray *lastAssets=[ZLHistoryManager getAllAssets];
    
    if (lastAssets&&[lastAssets count]>assetObject.assetIndex) {
        NSMutableArray *assetsArray=[NSMutableArray array];
        [assetsArray addObjectsFromArray:lastAssets];
        [ZLHistoryManager addNewScore:assetObject.gold];
        NSMutableDictionary *dicData=[NSMutableDictionary dictionaryWithDictionary:[assetObject dicData]];
        [dicData setObject:[NSDate date] forKey:@"date"];
        [assetsArray replaceObjectAtIndex:assetObject.assetIndex withObject:dicData];
        [[NSUserDefaults standardUserDefaults] setObject:assetsArray forKey:@"ZL_ASSET_LIST"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark - 游戏方式
+(NSArray *)getSelectedGameMode
{
    //NSString *modesStr=[[NSUserDefaults standardUserDefaults] objectForKey:@"ZL_GAMEMODE_LIST"];
    NSArray *modes=[[NSUserDefaults standardUserDefaults] objectForKey:@"ZL_GAMEMODE_LIST"];
    if (modes&&[modes count]) {
        //return [modes sortedArrayUsingSelector:@selector(compare:)];
        return [modes sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2){
            int mode1=[obj1 intValue];
            int mode2=[obj2 intValue];
            if (mode1==mode2) {
                return NSOrderedSame;
            }else if(mode1<mode2){
                return NSOrderedAscending;
            }else{
                return NSOrderedDescending;
            }
        }];
    }
    return nil;
}

+(void)addGameMode:(ZL_GAME_MODE)mode
{
    NSMutableArray *newArray=[NSMutableArray arrayWithObject:[NSNumber numberWithInt:mode]];
    NSArray *modes=[[NSUserDefaults standardUserDefaults] objectForKey:@"ZL_GAMEMODE_LIST"];
    if (modes&&[modes count]){
        [newArray addObjectsFromArray:modes];
    }
    [[NSUserDefaults standardUserDefaults] setObject:newArray forKey:@"ZL_GAMEMODE_LIST"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)deleteGameMode:(ZL_GAME_MODE)mode
{
    NSArray *modes=[[NSUserDefaults standardUserDefaults] objectForKey:@"ZL_GAMEMODE_LIST"];
    if (modes&&[modes count]){
        NSMutableArray *newArray=[NSMutableArray arrayWithArray:modes];
        [newArray removeObject:[NSNumber numberWithInt:mode]];
        [[NSUserDefaults standardUserDefaults] setObject:newArray forKey:@"ZL_GAMEMODE_LIST"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


#pragma mark - 筹码类型
+(ZL_CHIPS_TYPE)getChipType;
{
    ZL_CHIPS_TYPE chipType=(int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ZL_CHIP_TYPE"];
    if (chipType<=0) {
        //默认筹码设置
        return ZLChipTypeFive;
    }
    return chipType;
}

+(void)setChipType:(ZL_CHIPS_TYPE)type;
{
    [[NSUserDefaults standardUserDefaults] setInteger:type forKey:@"ZL_CHIP_TYPE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma  mark - 等级
+(int)getLastClass
{
    int lastclass=(int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ZL_LAST_CLASS"];
    if (lastclass<=0) {
        lastclass=1;
    }
    return lastclass;
}

+(void)addNewClass:(int)addNumber
{
    int lastClass=[ZLHistoryManager getLastClass];
    
    [[NSUserDefaults standardUserDefaults] setInteger:lastClass+addNumber forKey:@"ZL_LAST_CLASS"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSDate *)getLastLoginTime
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"ZL_LAST_LOGIN_TIME"] ;
}

+(void)setLastLoginTime:(NSDate *)date
{
    if (date) {
        NSDate *lastDate=[ZLHistoryManager getLastLoginTime];
        if (lastDate) {
            int duration=[date timeIntervalSinceDate:lastDate];
            if (duration>0) {
                [ZLHistoryManager addActiveDuration:duration];
            }
        }
        [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"ZL_LAST_LOGIN_TIME"];
        [[NSUserDefaults  standardUserDefaults] synchronize];
    }
}

//在线时间
+(int)getActiveDuration
{
    return (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ZL_ACTIVE_DURATION"];
}

+(void)addActiveDuration:(int)duration
{
    int activeDuration=[ZLHistoryManager getActiveDuration];
    activeDuration +=duration;
    int addClass=activeDuration/(10*60);//每在线10分钟晋级一次
    if (addClass>0) {
        [ZLHistoryManager addNewClass:addClass];
    }
    [[NSUserDefaults standardUserDefaults] setInteger:activeDuration%(10*60) forKey:@"ZL_ACTIVE_DURATION"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - 其他设置

//音效开关是否打开
+(BOOL)voiceOpened
{
    int voiceState=(int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ZL_VOICE_STATE"];
    if (voiceState==2) {
        return NO;
    }
    return YES;
}

//设置音效开关
+(void)setVoiceOpened:(BOOL)open;
{
    [[NSUserDefaults standardUserDefaults] setInteger:open?1:2 forKey:@"ZL_VOICE_STATE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//背景音乐开关是否打开
+(BOOL)musicOpened;
{
    int voiceState=(int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ZL_MUSIC_STATE"];
    if (voiceState==2) {
        return NO;
    }
    return YES;
}

//设置背景音乐开关
+(void)setMusicOpened:(BOOL)open;
{
    [[NSUserDefaults standardUserDefaults] setInteger:open?1:2 forKey:@"ZL_MUSIC_STATE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//是否是第一次进入应用
+(BOOL)isFirstLaunch
{
    BOOL launched=[[NSUserDefaults standardUserDefaults] boolForKey:@"ZL_LAUNCHED"];
    if (!launched) {
        return YES;
    }
    return NO;
}

//设置为不是第一次进入应用
+(void)setFirstLaunch
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ZL_LAUNCHED"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
