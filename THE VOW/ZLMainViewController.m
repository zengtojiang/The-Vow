//
//  ZLMainViewController.m
//  THE VOW
//
//  Created by libs on 14-4-9.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import "ZLMainViewController.h"
#import "ZLHomeViewController.h"
#import "ZLMallViewController.h"
#import "ZLHistoryManager.h"
#import "ZLAppDelegate.h"
#import "ZLGameViewController.h"
#import "ZLDefaultViewController.h"


@interface ZLMainViewController ()

@end

@implementation ZLMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //[self CreatSubViewController];
    }
    return self;
}

- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden=YES;
    [super viewDidLoad];
    [self CreatSubViewController];
    if ([ZLHistoryManager isFirstLaunch]) {
//        [ZLHistoryManager setFirstLaunch];
//        int  initCoin=[ZLHistoryManager initialAssets];
//        ZLAlertView *alertView=[[ZLAlertView alloc] initWithMessage:[NSString stringWithFormat:@"You get the %d initial gold",initCoin] delegate:self cancelButtonTitle:@"OK" confirmButtonTitles:nil];
//        alertView.tag=1000;
//        [alertView show];
        
        // [self showGuideView];
        // [(ZLAppDelegate *)([UIApplication sharedApplication].delegate) startBGAudio:ZL_BGMUSIC_TYPE_GUIDE];
    }else{
        // [(ZLAppDelegate *)([UIApplication sharedApplication].delegate) startBGAudio:ZL_BGMUSIC_TYPE_NORMAL];
    }
    [(ZLAppDelegate *)([UIApplication sharedApplication].delegate) startBGAudio:ZL_BGMUSIC_TYPE_NORMAL];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.selectedViewController) {
        [self.selectedViewController viewWillAppear:animated];
    }
    //[self reloadHeadView];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    if (self.viewControllers==nil||[self.viewControllers count]<=0) {
//        [self CreatSubViewController];
//    }
    if ([ZLHistoryManager isFirstLaunch]) {
        [ZLHistoryManager setFirstLaunch];
#ifndef TEST_STOREKIT
        [[self.viewControllers objectAtIndex:1] startInitRotate];
#endif
    }
}


-(void)showGuideView
{
    ZLGuideView *guideView=[[ZLGuideView alloc] initWithFrame:self.view.bounds];
    guideView.delegate=self;
    [self.view addSubview:guideView];
}

- (void)CreatSubViewController
{
    ZLHomeViewController *assetsVC=[[ZLHomeViewController alloc] init];
    
#ifndef TEST_STOREKIT
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ZLGameViewController *gameVC=[storyBoard instantiateViewControllerWithIdentifier:@"gamevc"];
    //ZLGameViewController    *gameVC=[[ZLGameViewController alloc] init];
   // ZLActivityViewController *activityVC=[[ZLActivityViewController alloc] init];
#else
    ZLDefaultViewController *gameVC=[[ZLDefaultViewController alloc] init];
#endif
    ZLMallViewController *mallVC=[[ZLMallViewController alloc] init];
  
	self.viewControllers = [NSArray arrayWithObjects:
                            assetsVC,
                            gameVC,
                            //activityVC,
                            mallVC,nil];
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskPortrait;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - ZLAlertViewDelegate
- (void)alertView:(ZLAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1000) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ZL_REFRESS_GOLDS_NOTIFICATION object:nil];
    }
}

#pragma mark - ZLGuideViewDelegate

-(void)onGuideViewEnded:(ZLGuideView *)view
{
    [view removeFromSuperview];
    if ([ZLHistoryManager musicOpened]){
        [(ZLAppDelegate *)([UIApplication sharedApplication].delegate) startBGAudio:ZL_BGMUSIC_TYPE_NORMAL];
    }
}

@end
