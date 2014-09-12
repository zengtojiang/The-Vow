//
//  ZLMyScene.h
//  THE VOW
//

//  Copyright (c) 2014年 icow. All rights reserved.
//

#ifndef TEST_STOREKIT
#import <SpriteKit/SpriteKit.h>


@interface ZLMyScene : SKScene
{
    SKSpriteNode *runpan;
    BOOL         bRunning;
    
    NSMutableArray  *resultArray;
    int          currentNumberIndex;
    int          rotateNumber;
    
    SKAction     *playRotateAudio;
    SKAction     *playWinAudio;
    SKAction     *playLoseAudio;
    SKAction     *playMissAudio;
    SKAction     *playTapButtonAudio;
    SKAction     *playGoldAudio;
}

-(void)startRotate;

-(void)playAudioEffectType:(ZL_AUDIO_TYPE)audioType;
@end
#endif
