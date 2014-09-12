//
//  ZLGuideView.m
//  THE VOW
//
//  Created by libs on 14-4-9.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import "ZLGuideView.h"

@implementation ZLGuideView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSString *path=[[NSBundle mainBundle] pathForResource:@"guidechats" ofType:@"plist"];
        arrChats=[[NSArray alloc] initWithContentsOfFile:path];
        _arrIndex=0;
        
        // Do any additional setup after loading the view.
        imvBG=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide3.jpg"]];
        imvBG.frame=self.bounds;
        [self addSubview:imvBG];
        
        lblBG=[[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-140, self.frame.size.width, 140)];
        lblBG.backgroundColor=[UIColor blackColor];
        lblBG.alpha=0.5;
        [self addSubview:lblBG];
        
        lblChat=[[UILabel alloc] initWithFrame:CGRectMake(12, self.frame.size.height-130, self.frame.size.width-24, 120)];
        lblChat.textColor=[UIColor whiteColor];
        lblChat.font=[UIFont fontWithName:@"Chalkduster" size:20];
        lblChat.numberOfLines=0;
        [self addSubview:lblChat];
        lblChat.text=[arrChats objectAtIndex:_arrIndex];
        
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGuide:)];
        //tapGesture.numberOfTouches=1;
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

-(void)onTapGuide:(UIGestureRecognizer *)gesture
{
    if (gesture.state==UIGestureRecognizerStateEnded) {
        _arrIndex++;
        if (_arrIndex>=[arrChats count]) {
            [self onReachGuideEnd];
        }else{
            [self resetGuideChat];
        }
    }
}


-(void)onReachGuideEnd
{
    [self.delegate onGuideViewEnded:self];
}

-(void)resetGuideChat
{
    [UIView beginAnimations:nil context:NULL];
    lblChat.text=[arrChats objectAtIndex:_arrIndex];
    [UIView commitAnimations];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
