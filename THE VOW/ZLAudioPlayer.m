//
//  ZLAudioPlayer.m
//  Toothpaste
//
//  Created by libs on 14-3-23.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import "ZLAudioPlayer.h"

@implementation ZLAudioPlayer

-(void)setBackgroundAudioFileName:(NSString *)fileName fileType:(NSString *)fileType
{
    NSString *filePath=[[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
    mPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:NULL];
    mPlayer.delegate=self;
    mPlayer.numberOfLoops=1;
    mPlayer.volume=0.1;
}

-(void)play
{
    int  audioType=arc4random()%2;
    if (audioType==0) {
        [self setBackgroundAudioFileName:@"music1" fileType:@"mp3"];
    }else if(audioType==1){
        [self setBackgroundAudioFileName:@"music2" fileType:@"aac"];
    }
    [mPlayer play];
}

-(void)pause
{
    [mPlayer pause];
}

-(void)resume
{
    [mPlayer play];
}

-(void)stop
{
    [mPlayer stop];
    mPlayer=nil;
}

-(void)replay{
    [self stop];
    [self play];
}

#pragma mark - VAudioPlayerDelegate
/* audioPlayerDidFinishPlaying:successfully: is called when a sound has finished playing. This method is NOT called if the player is stopped due to an interruption. */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self performSelector:@selector(replay) withObject:nil afterDelay:0.5];
}

@end
