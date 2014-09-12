//
//  ZLDefaultViewController.m
//  THE VOW
//
//  Created by libs on 14-4-15.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import "ZLDefaultViewController.h"
#import "ZLShopViewController.h"
#import "ZLHistoryManager.h"

@interface ZLDefaultViewController ()

@end

@implementation ZLDefaultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    lblChipCount=[[UILabel alloc] initWithFrame:CGRectMake(10, 100, 300, 30)];
    lblChipCount.backgroundColor=[UIColor clearColor];
    lblChipCount.textAlignment=NSTextAlignmentLeft;
    lblChipCount.font=[UIFont fontWithName:ZL_DEFAULT_FONT_NAME size:ZL_MIDDLE_FONT_SIZE];
    lblChipCount.textColor=[UIColor whiteColor];
    [self.view addSubview:lblChipCount];
    lblChipCount.text=[NSString stringWithFormat:@"%d/%d",[ZLHistoryManager getLastScore],[ZLHistoryManager getLastMissCount]];
    
    
    HSStretchableButton *mBtnShop=[HSStretchableButton buttonWithType:UIButtonTypeCustom];
    [mBtnShop setBackgroundImage:[UIImage imageNamed:@"buttonRed.png"] forState:UIControlStateNormal];
    [mBtnShop setBackgroundImage:[UIImage imageNamed:@"buttonRed_disabled.png"] forState:UIControlStateDisabled];
    mBtnShop.frame=CGRectMake(100, 230, 60, 30);//CGRectMake((self.view.frame.size.width-80)/2, self.view.frame.size.height-60, 80, 30);
    [mBtnShop setTitle:NSLocalizedString(@"Shop",nil) forState:UIControlStateNormal];
    [mBtnShop stretchImage];
    mBtnShop.titleLabel.font=[UIFont fontWithName:ZL_DEFAULT_FONT_NAME size:ZL_SMALL_FONT_SIZE];
    [mBtnShop setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [mBtnShop setTitleColor:ZL_DISABLE_TEXTCOLOR forState:UIControlStateDisabled];
    [self.view addSubview:mBtnShop];
    [mBtnShop addTarget:self action:@selector(onTapShopping:) forControlEvents:UIControlEventTouchUpInside];
    [self registerNotification];
}

-(void)registerNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReloadGold:) name:ZL_REFRESS_GOLDS_NOTIFICATION object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self registerNotification];
    lblChipCount.text=[NSString stringWithFormat:@"%d/%d",[ZLHistoryManager getLastScore],[ZLHistoryManager getLastMissCount]];
}

-(void)onTapShopping:(id)sender
{
    ZLShopViewController *shopVC=[[ZLShopViewController alloc] init];
    //[self presentViewController:shopVC animated:YES completion:NULL];
    [(UINavigationController *)([UIApplication sharedApplication].keyWindow.rootViewController) pushViewController:shopVC animated:YES];
}


-(void)onReloadGold:(NSNotification *)notify
{
     lblChipCount.text=[NSString stringWithFormat:@"%d/%d",[ZLHistoryManager getLastScore],[ZLHistoryManager getLastMissCount]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
