//
//  ZLAudioPlayer.h
//  Toothpaste
//
//  Created by libs on 14-3-23.
//  Copyright (c) 2014年 icow. All rights reserved.
//
/**
 音频播放
 */
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(int, ZL_BGMUSIC_TYPE) {
    ZL_BGMUSIC_TYPE_GUIDE=1,//引导页
    ZL_BGMUSIC_TYPE_WAR=2,//战斗
    ZL_BGMUSIC_TYPE_NORMAL=3,//其他时候放的背景音乐
};


@interface ZLAudioPlayer : NSObject<AVAudioPlayerDelegate>
{
    AVAudioPlayer *mPlayer;//背景音乐播放器
}

-(void)setBackgroundAudioFileName:(NSString *)fileName fileType:(NSString *)fileType;

-(void)play;

-(void)pause;

-(void)resume;

-(void)stop;

@end
