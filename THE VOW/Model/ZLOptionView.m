//
//  ZLOptionView.m
//  THE VOW
//
//  Created by libs on 14-4-13.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import "ZLOptionView.h"
#import "ZLHistoryManager.h"

@implementation ZLOptionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *buttonImage=[UIImage imageNamed:@"down.png"];
        mOptionButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [mOptionButton setImage:buttonImage forState:UIControlStateNormal];
        [self addSubview:mOptionButton];
        mOptionButton.frame=CGRectMake((self.frame.size.width-buttonImage.size.width)/2, 0, buttonImage.size.width, buttonImage.size.height);
        [mOptionButton addTarget:self action:@selector(onTapDownButton) forControlEvents:UIControlEventTouchUpInside];
        if(![ZLHistoryManager hasTapOptionButton]){
            [self startOptionButtonAnimation];
        }
//        UIImageView *imvBG=[[UIImageView alloc] initWithFrame:CGRectMake(0, ZL_OPTION_CONTENT_TOPMARGIN, self.bounds.size.width, ZL_OPTION_CONTENT_HEIGHT)];
//        imvBG.image=[UIImage imageNamed:@"tabbarBlue.png"];//[UIImage imageNamed:@"bg_gameover.png"];
//        [self addSubview:imvBG];
        
        [self initParams];
        
        int buttonHeight=60;
        
        mChipScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(3, buttonImage.size.height+8, self.frame.size.width-6, buttonHeight)];
        mChipScrollView.scrollEnabled=YES;
        mChipScrollView.userInteractionEnabled=YES;
        
        HSStretchableImageView *imvBG=[[HSStretchableImageView alloc] initWithFrame:CGRectMake(0, buttonImage.size.height+5, self.bounds.size.width, self.frame.size.height-buttonImage.size.height-5)];
        imvBG.image=[UIImage imageNamed:@"optionbg.png"];
        [imvBG stretchImage];
       // imvBG.image=[UIImage imageNamed:@"tabbarBlue.png"];//[UIImage imageNamed:@"bg_gameover.png"];
        [self addSubview:imvBG];
        
        /*
         UIImageView *scrollBG=[[UIImageView alloc] initWithFrame:mChipScrollView.frame];
         scrollBG.image=[UIImage imageNamed:@"bg_cq.png"];
         [self addSubview:scrollBG];
         */
        
        [self addSubview:mChipScrollView];
        
        float leftMargin=10;
        float contentLength=leftMargin;
        for (int i=ZLChipTypeOne; i<=ZLChipTypeFiveHundred; i++) {
            contentLength +=buttonHeight+leftMargin;
            UIButton *characterView=[[UIButton alloc] initWithFrame:CGRectMake(leftMargin*(i)+(i-1)*buttonHeight, 5, buttonHeight-10, buttonHeight-10)];
            //[characterView setBackgroundImage:[UIImage imageNamed:@"alpha.png"] forState:UIControlStateSelected];
            [characterView setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"Vector%d.png",(i-1)]] forState:UIControlStateNormal];
            [characterView setImage:[UIImage imageNamed:@"bet_zq.png"] forState:UIControlStateSelected];
            [characterView setSelected:(i==chipType)];
            //[characterView setMaskViewShow:i!=mCharacterType];
            characterView.tag=300+i;
            [characterView addTarget:self action:@selector(onTapChipTypeView:) forControlEvents:UIControlEventTouchUpInside];
            [mChipScrollView addSubview:characterView];
        }
        [mChipScrollView setContentSize:CGSizeMake(contentLength, buttonHeight)];
    }
    return self;
}

-(void)startOptionButtonAnimation
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatCount:MAXFLOAT];
    [UIView setAnimationRepeatAutoreverses:YES];
    mOptionButton.alpha=0.3;
    [UIView commitAnimations];
}

-(void)initParams
{
    chipType=[ZLHistoryManager getChipType];
}

-(void)setOptionButtonImage:(UIImage *)image
{
    [mOptionButton setImage:image forState:UIControlStateNormal];
}

-(void)onTapChipTypeView:(UIButton *)sender
{
    chipType=(int)sender.tag-300;
    [ZLHistoryManager setChipType:chipType];
    [self resetChipTypeState];
    [self.delegate onOptionViewChangeChipType:chipType];
}

-(void)resetChipTypeState
{
    for (UIView *child in [mChipScrollView subviews]) {
        if ([child isKindOfClass:[UIButton class]]) {
            UIButton *characterView=(UIButton *)child;
            [characterView setSelected:((characterView.tag-300)==chipType)];
            //[characterView setMaskViewShow:(characterView.tag-300)!=mCharacterType];
        }
    }
}

-(void)onTapDownButton
{
    if (![ZLHistoryManager hasTapOptionButton]) {
        [ZLHistoryManager setHasTapOptionButton];
        [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            mOptionButton.alpha=1;
        } completion:NULL];
    }
    [self.delegate onTapOptionUpDownButton:self];
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
