//
//  ZLGuideViewController.m
//  THE VOW
//
//  Created by libs on 14-4-9.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import "ZLGuideViewController.h"

@interface ZLGuideViewController ()

@end

@implementation ZLGuideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSString *path=[[NSBundle mainBundle] pathForResource:@"guidechats" ofType:@"plist"];
        arrChats=[[NSArray alloc] initWithContentsOfFile:path];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    imvBG=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide1.jpg"]];
    imvBG.frame=self.view.bounds;
    [self.view addSubview:imvBG];
    
    lblBG=[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-100, self.view.frame.size.width, 100)];
    lblBG.backgroundColor=[UIColor blackColor];
    lblBG.alpha=0.5;
    [self.view addSubview:lblBG];
    
    lblChat=[[UILabel alloc] initWithFrame:CGRectMake(15, self.view.frame.size.height-110, self.view.frame.size.width-30, 80)];
    lblChat.textColor=[UIColor whiteColor];
    lblChat.font=[UIFont fontWithName:@"Chalkduster" size:24];
    lblChat.numberOfLines=0;
    [self.view addSubview:lblChat];
    lblChat.text=[arrChats objectAtIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
