//
//  ZLAppDelegate.h
//  THE VOW
//
//  Created by libs on 14-4-9.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLAudioPlayer.h"
#import "ZLMainViewController.h"
#ifndef TEST_STOREKIT
#import "ZLMyScene.h"
#endif
#import "ZLStoreKitManager.h"

@interface ZLAppDelegate : UIResponder <UIApplicationDelegate,ZLStoreKitManagerDelegate>
{
    ZLAudioPlayer   *mAudioPlayer;
}
@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,retain)NSDictionary *iapData;
#ifndef TEST_STOREKIT
@property(nonatomic,assign)ZLMyScene *gameScene;
#endif
@property(nonatomic,retain)ZLStoreKitManager   *mStoreKitManager;

-(void)startBGAudio:(ZL_BGMUSIC_TYPE)musictype;

-(void)stopBGAudio;

-(void)playAudio:(ZL_AUDIO_TYPE)audioType;

-(ZLMainViewController *)getMainViewController;

#pragma mark - 内购
//请求商品列表
-(void)startRequestProduct;

//购买商品
-(void)purchaseProduct:(SKProduct *)product count:(int)count;

-(void)cancelRequestProductAction;
@end
