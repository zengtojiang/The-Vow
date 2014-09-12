//
//  ZLMyScene.m
//  THE VOW
//
//  Created by libs on 14-4-9.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#ifndef TEST_STOREKIT
#import "ZLMyScene.h"

@implementation ZLMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        [self initParams];
        [self initBackground];
        [self initAudioAction];
    }
    return self;
}

-(void)initParams
{
    bRunning=NO;
    currentNumberIndex=0;
    self.physicsWorld.gravity=CGVectorMake(0, 0);
    resultArray=[[NSMutableArray alloc] initWithObjects:
                 [NSNumber numberWithInt:0],[NSNumber numberWithInt:-26],[NSNumber numberWithInt:3],
                 [NSNumber numberWithInt:-35],[NSNumber numberWithInt:12],[NSNumber numberWithInt:-28],
                 [NSNumber numberWithInt:7],[NSNumber numberWithInt:-29],[NSNumber numberWithInt:18],
                 [NSNumber numberWithInt:-22],[NSNumber numberWithInt:9], [NSNumber numberWithInt:-31],
                 [NSNumber numberWithInt:14],[NSNumber numberWithInt:-20], [NSNumber numberWithInt:1],
                 [NSNumber numberWithInt:-33],[NSNumber numberWithInt:16],[NSNumber numberWithInt:-24],
                 [NSNumber numberWithInt:5],[NSNumber numberWithInt:-10], [NSNumber numberWithInt:23],
                 [NSNumber numberWithInt:-8],[NSNumber numberWithInt:30],[NSNumber numberWithInt:-11],
                 [NSNumber numberWithInt:36], [NSNumber numberWithInt:-13],[NSNumber numberWithInt:27],
                 [NSNumber numberWithInt:-6],[NSNumber numberWithInt:34],[NSNumber numberWithInt:-17],
                 [NSNumber numberWithInt:25],[NSNumber numberWithInt:-2],[NSNumber numberWithInt:21],
                 [NSNumber numberWithInt:-4], [NSNumber numberWithInt:19],[NSNumber numberWithInt:-15],
                 [NSNumber numberWithInt:32],nil];
    /*
    resultArray=[[NSMutableArray alloc] initWithObjects:
                 [NSNumber numberWithInt:0],[NSNumber numberWithInt:26],[NSNumber numberWithInt:3],
                 [NSNumber numberWithInt:35],[NSNumber numberWithInt:12],[NSNumber numberWithInt:28],
                 [NSNumber numberWithInt:7],[NSNumber numberWithInt:29],[NSNumber numberWithInt:18],
                 [NSNumber numberWithInt:22],[NSNumber numberWithInt:9], [NSNumber numberWithInt:31],
                 [NSNumber numberWithInt:14],[NSNumber numberWithInt:20], [NSNumber numberWithInt:1],
                 [NSNumber numberWithInt:33],[NSNumber numberWithInt:16],[NSNumber numberWithInt:24],
                 [NSNumber numberWithInt:5],[NSNumber numberWithInt:10], [NSNumber numberWithInt:23],
                 [NSNumber numberWithInt:8],[NSNumber numberWithInt:30],[NSNumber numberWithInt:11],
                 [NSNumber numberWithInt:36], [NSNumber numberWithInt:13],[NSNumber numberWithInt:27],
                 [NSNumber numberWithInt:6],[NSNumber numberWithInt:34],[NSNumber numberWithInt:17],
                 [NSNumber numberWithInt:25],[NSNumber numberWithInt:2],[NSNumber numberWithInt:21],
                 [NSNumber numberWithInt:4], [NSNumber numberWithInt:19],[NSNumber numberWithInt:15],
                 [NSNumber numberWithInt:32],nil];
     */
    
    //self.physicsWorld.contactDelegate=self;
}

-(void)initBackground
{
    //SKSpriteNode *bgNode=[SKSpriteNode spriteNodeWithTexture:[SKSharedAtles textureWithType:ZLTextureTypeGameBG]];
    
    SKSpriteNode *bgNode=[SKSpriteNode spriteNodeWithImageNamed:iPhone5?@"bg-568.png":@"bg.png"];//@"bg_yingying.png"
    bgNode.zPosition=0;
    bgNode.anchorPoint=CGPointMake(0, 0);
    bgNode.position=CGPointZero;
    //bgNode.position=CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    //bgNode.size=CGSizeMake(self.size.width, self.size.height-64);
    [self addChild:bgNode];
    
    SKSpriteNode *spinBG=[SKSpriteNode spriteNodeWithImageNamed:@"spinning_bg2.png"];
    spinBG.zPosition=0;
    spinBG.anchorPoint=CGPointMake(0.5, 0.5);
    spinBG.position=CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame)*(1-ZL_SPINNING_YPOSITION));
    [self addChild:spinBG];
    
    runpan=[SKSpriteNode spriteNodeWithImageNamed:@"spinning.png"];
    runpan.zPosition=0;
    runpan.anchorPoint=CGPointMake(0.5, 0.5);
    runpan.position=CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame)*(1-ZL_SPINNING_YPOSITION));
    runpan.physicsBody=[SKPhysicsBody bodyWithCircleOfRadius:runpan.size.width/2];
    runpan.physicsBody.angularDamping=0;
    //runpan.physicsBody.angularDamping=0.4;
    [self addChild:runpan];
}

-(void)initAudioAction
{
    playRotateAudio=[SKAction playSoundFileNamed:@"runBall.wav" waitForCompletion:NO];
    playWinAudio=[SKAction playSoundFileNamed:@"win1.mp3" waitForCompletion:NO];
    playLoseAudio=[SKAction playSoundFileNamed:@"lose1.mp3" waitForCompletion:NO];
    playTapButtonAudio=[SKAction playSoundFileNamed:@"button.mp3" waitForCompletion:NO];
    playGoldAudio=[SKAction playSoundFileNamed:@"gold1.mp3" waitForCompletion:NO];
    playMissAudio=[SKAction playSoundFileNamed:@"miss.mp3" waitForCompletion:NO];
}

-(void)startRotate
{
    [self onTapStartGame];
}

-(void)playAudioEffectType:(ZL_AUDIO_TYPE)audioType
{
    switch (audioType) {
        case ZLAudioTypeRotate:
        {
            [self runAction:playRotateAudio];
        }
            break;
        case ZLAudioTypeWin:
        {
            [self runAction:playWinAudio];
        }
            break;
        case ZLAudioTypeLose:
        {
            [self runAction:playLoseAudio];
        }
            break;
        case ZLAudioTypeTapButton:
        {
            [self runAction:playTapButtonAudio];
        }
            break;
        case ZLAudioTypeGold:
        {
            [self runAction:playGoldAudio];
        }
            break;
        case ZLAudioTypeMiss:
        {
            [self runAction:playMissAudio];
        }
            break;
        default:
            break;
    }
    
}

-(void)onTapStartGame
{
    //[runpan runAction:[SKAction rot]];
    [self playAudioEffectType:ZLAudioTypeRotate];
    bRunning=YES;
    rotateNumber=arc4random()%30+200;
    int cur=currentNumberIndex+rotateNumber%37;
    cur =cur%37;
    ZLTRACE(@"oldNumberIndex:%d curNum:%d",currentNumberIndex,cur);
    ZLTRACE(@"oldNumber:%d curNum:%d",[[resultArray objectAtIndex:currentNumberIndex] intValue],[[resultArray objectAtIndex:cur] intValue]);
    currentNumberIndex=cur;
    SKAction *rotateAction=[SKAction rotateByAngle:(-1.0f)*rotateNumber*2*M_PI/37 duration:5.5f];
    //[self runAction:[SKAction playSoundFileNamed:@"" waitForCompletion:NO]];
    //SKAction *rotateAction=[SKAction rotateByAngle:(-1.0f)*rotateNumber*2*M_PI/37 duration:rotateNumber*0.05f];
    rotateAction.timingMode=SKActionTimingEaseOut;
    [runpan runAction:rotateAction completion:^{
        [self onRotateFinished];
    }];
    //runpan.physicsBody.angularVelocity=arc4random()%30+20;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    if (self.paused) {
        return;
    }
    /*
    UITouch *touch=[[touches allObjects] firstObject];
    if (CGRectContainsPoint(_playButton.frame,[touch locationInNode:self])) {
        ZLTRACE(@"点中开始按钮");
        [self onTapStartGame];
    }
     */
    //[[NSNotificationCenter defaultCenter] postNotificationName:ZL_CHALLENGE_OVER_NOTIFICATION object:nil userInfo:((arc4random()%2==0)?[NSDictionary dictionaryWithObject:@"1" forKey:@"result"]:nil)];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
//    if (bRunning&&!(self.paused)) {
//         [self detectRotateState];
//    }
}

-(void)onRotateFinished
{
    ZLTRACE(@"runpan stoped");
    bRunning=NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:ZL_CHALLENGE_OVER_NOTIFICATION object:nil userInfo:[NSDictionary dictionaryWithObject:[resultArray objectAtIndex:currentNumberIndex] forKey:@"number"]];
}

-(void)detectRotateState
{
    if (runpan.physicsBody.angularVelocity==0) {
        ZLTRACE(@"runpan stoped");
        bRunning=NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:ZL_CHALLENGE_OVER_NOTIFICATION object:nil userInfo:[NSDictionary dictionaryWithObject:[resultArray objectAtIndex:currentNumberIndex] forKey:@"number"]];
    }
}
@end
#endif