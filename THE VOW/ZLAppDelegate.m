//
//  ZLAppDelegate.m
//  THE VOW
//
//  Created by libs on 14-4-9.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import "ZLAppDelegate.h"
#import "ZLHistoryManager.h"

@implementation ZLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //初始化内购
    [self initInAppPurchaseManager];
    return YES;
}

-(ZLMainViewController *)getMainViewController
{
    return (ZLMainViewController *)([(UINavigationController *)(self.window.rootViewController) topViewController]);
}

-(void)playAudio:(ZL_AUDIO_TYPE)audioType
{
#ifndef TEST_STOREKIT
    if (self.gameScene) {
        [self.gameScene playAudioEffectType:audioType];
    }
#endif
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    //[ZLHistoryManager setLastLoginTime:[NSDate date]];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //[ZLHistoryManager setLastLoginTime:[NSDate date]];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    //[ZLHistoryManager setLastLoginTime:[NSDate date]];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //[ZLHistoryManager setLastLoginTime:[NSDate date]];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)initAudioPlayer
{
    mAudioPlayer=[[ZLAudioPlayer alloc] init];
}

-(void)startBGAudio:(ZL_BGMUSIC_TYPE)musictype
{
    if (!mAudioPlayer) {
        [self initAudioPlayer];
    }
    [mAudioPlayer stop];
    [mAudioPlayer play];
}

-(void)stopBGAudio
{
    [mAudioPlayer stop];
}

#pragma mark - 内购

-(void)initInAppPurchaseManager
{
    self.mStoreKitManager=[[ZLStoreKitManager alloc] init];
    self.mStoreKitManager.delegate=self;
}

-(NSDictionary *)getIAPProductsData
{
    if (self.iapData==nil) {
        NSString *filePath=[[NSBundle mainBundle] pathForResource:@"iapproducts" ofType:@"plist"];
        self.iapData=[NSDictionary dictionaryWithContentsOfFile:filePath];
    }
    return self.iapData;
}

//请求商品列表
-(void)startRequestProduct
{
    //NSSet *set=[NSSet setWithObjects:@"com.chengxin.thevow.gold3",@"com.chengxin.thevow.gold2",@"com.chengxin.thevow.gold1",@"com.chengxin.thevow.donation1",@"com.chengxin.thevow.immunity1", nil];
    if ([self getIAPProductsData]&&[[self getIAPProductsData] count]) {
        [self.mStoreKitManager initProductRequest:[NSSet setWithArray:[[self getIAPProductsData] allKeys]]];
    }
}

//购买商品
-(void)purchaseProduct:(SKProduct *)product count:(int)count
{
     [self.mStoreKitManager purchaseProduct:product count:count];
}

-(void)cancelRequestProductAction
{
    if (self.mStoreKitManager) {
        [self.mStoreKitManager cancelAllAction];
    }
}

#pragma mark - ZLStoreKitManagerDelegate

-(void)storeKitManager_onReceiveProducts:(NSArray *)products
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ZL_IAP_PRODUCTS_NOTIFICATION object:nil userInfo:[NSDictionary dictionaryWithObject:products?products:@"" forKey:@"products"]];
    ZLTRACE(@"product count:%d",[products count]);
}

-(void)storeKitManager_onRequestProductError
{
    ZLTRACE(@"");
    [[NSNotificationCenter defaultCenter] postNotificationName:ZL_IAP_PRODUCTS_NOTIFICATION object:nil userInfo:[NSDictionary dictionaryWithObject:@"" forKey:@"products"]];
}

-(void)storeKitManager_onPurchaseSuccess:(NSString *)productIdentifier withCount:(int)count
{
    if (count&&productIdentifier&&[self getIAPProductsData]) {
        NSString *strProduct=[self.iapData objectForKey:productIdentifier];
        if (strProduct) {
            NSArray *arrData=[strProduct componentsSeparatedByString:@";"];
            if (arrData&&[arrData count]==2) {
                int gold=[[arrData objectAtIndex:1] intValue];
                int miss=[[arrData objectAtIndex:0] intValue];
                [ZLHistoryManager addNewScore:gold*count];
                [ZLHistoryManager addNewMissCount:miss*count];
                
                NSString *alertMessage;
                if (gold&&miss) {
                     alertMessage=[NSString stringWithFormat:NSLocalizedString(@"You have got %d X %d gold and %d X %d miss.",nil),count,gold,count,miss];
                }else if(gold){
                    alertMessage=[NSString stringWithFormat:NSLocalizedString(@"You have got %d X %d gold.",nil),count,gold];
                }else if(miss){
                    alertMessage=[NSString stringWithFormat:NSLocalizedString(@"You have got %d X %d miss.",nil),count,miss];
                }
                if (alertMessage) {
                    ZLAlertView *alertView=[[ZLAlertView alloc] initWithMessage:alertMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) confirmButtonTitles:nil];
                    [alertView show];
                    [[NSNotificationCenter defaultCenter] postNotificationName:ZL_REFRESS_GOLDS_NOTIFICATION object:nil];
                }
            }
        }
    }
}
@end
