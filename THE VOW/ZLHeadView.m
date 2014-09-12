//
//  ZLHeadView.m
//  THE VOW
//
//  Created by libs on 14-4-9.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import "ZLHeadView.h"
#import "ZLHistoryManager.h"

@implementation ZLHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.userInteractionEnabled=YES;
        //self.backgroundColor=[UIColor clearColor];
        //self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbarBlue.png"]];
        self.image=[UIImage imageNamed:@"tabbg3.png"];//[UIImage imageNamed:@"skillbg6.png"];//
        
//        HSStretchableImageView *imvBG=[[HSStretchableImageView alloc] initWithFrame:self.bounds];
//        imvBG.image=[UIImage imageNamed:@"tabbg2.png"];
//        [imvBG stretchImage];
//        // imvBG.image=[UIImage imageNamed:@"tabbarBlue.png"];//[UIImage imageNamed:@"bg_gameover.png"];
//        [self addSubview:imvBG];
        
        //imvGold=[[UIImageView alloc] initWithFrame:CGRectMake(15, (self.frame.size.height-20-32)/2+20, 25, 32)];
        UIImage *iconImage=[UIImage imageNamed:@"goldicon5.png"];
        imvGold=[[UIImageView alloc] initWithFrame:CGRectMake(10, (self.frame.size.height-iconImage.size.height)/2, iconImage.size.width, iconImage.size.height)];
        imvGold.image=iconImage;
        [self addSubview:imvGold];
        
        //lblGold=[[UILabel alloc] initWithFrame:CGRectMake(50, (self.frame.size.height-20-20)/2+20, 170, 20)];
        lblGold=[[UILabel alloc] initWithFrame:CGRectMake(50, (self.frame.size.height-20)/2, 160, 20)];
        lblGold.backgroundColor=[UIColor clearColor];
        lblGold.font=[UIFont fontWithName:ZL_DEFAULT_FONT_NAME size:ZL_BIG_FONT_SIZE];
        lblGold.adjustsFontSizeToFitWidth=YES;
        lblGold.textColor=ZL_HEADVIEW_TEXTCOLOR;//[UIColor whiteColor];
        [self addSubview:lblGold];
        
        
        lblMiss=[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-110, (self.frame.size.height-20)/2, 100, 20)];
        lblMiss.backgroundColor=[UIColor clearColor];
        lblMiss.font=[UIFont fontWithName:ZL_DEFAULT_FONT_NAME size:ZL_MIDDLE_FONT_SIZE];
        lblMiss.adjustsFontSizeToFitWidth=YES;
        lblMiss.textColor=ZL_HEADVIEW_TEXTCOLOR;
        [self addSubview:lblMiss];
        /*
        imvClass=[[UIImageView alloc] initWithFrame:CGRectMake(220, (self.frame.size.height-20-32)/2+20, 84, 32)];
        imvClass.image=[UIImage imageNamed:@"classbg1.png"];
        [self addSubview:imvClass];
        
        UIImageView *imvClassicon=[[UIImageView alloc] initWithFrame:CGRectMake(4, 0, 25, 30)];
        imvClassicon.image=[UIImage imageNamed:@"classicon.png"];
        [imvClass addSubview:imvClassicon];
        
        lblClass=[[UILabel alloc] initWithFrame:CGRectMake(35, 6, 60, 20)];
        lblClass.backgroundColor=[UIColor clearColor];
        lblClass.font=[UIFont systemFontOfSize:12];
        lblClass.textColor=[UIColor whiteColor];
        [imvClass addSubview:lblClass];
         */
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)resetAssets
{
    lblGold.text=[NSString stringWithFormat:@"%d",[ZLHistoryManager getLastScore]];
    lblMiss.text=[NSString stringWithFormat:@"%@: %d",NSLocalizedString(@"MISS", nil),[ZLHistoryManager getLastMissCount]];
    //lblClass.text=[NSString stringWithFormat:@"%d",[ZLHistoryManager getLastClass]];
}

@end
