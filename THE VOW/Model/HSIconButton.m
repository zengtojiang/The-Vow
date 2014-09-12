//
//  HSIconButton.m
//  HSMCBStandardEdition
//
//  Created by jiangll on 13-9-11.
//  Copyright (c) 2013年 hisunsray. All rights reserved.
//

#import "HSIconButton.h"

@implementation HSIconButton
@synthesize normalImage;
@synthesize selectedImage;
@synthesize lblTitle;
@synthesize imvIcon;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        imvIcon=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self addSubview:imvIcon];
        
        lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 63, 40)];
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.textAlignment = NSTextAlignmentLeft;
        lblTitle.font = [UIFont systemFontOfSize:14.0f];
        lblTitle.textColor = [UIColor whiteColor];
        [self addSubview:lblTitle];
        bSelected=NO;
    }
    return self;
}

-(void)setSelected:(BOOL)selected
{
    bSelected=selected;
    imvIcon.image=selected?self.selectedImage:self.normalImage;
}

-(BOOL)isSelected
{
    return bSelected;
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
