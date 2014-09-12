//
//  HSStretchableImageView.m
//  HSMCBStandardEdition
//
//  Created by jiangll on 13-8-1.
//  Copyright (c) 2013年 hisunsray. All rights reserved.
//

#import "HSStretchableImageView.h"

@implementation HSStretchableImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)stretchImage
{
    UIImage *normalImage=[self image];
    UIImage *highlightedImage=[self highlightedImage];
    if (normalImage) {
        CGSize normalSize=normalImage.size;
        [self setImage: [normalImage resizableImageWithCapInsets:UIEdgeInsetsMake(normalSize.height/2.0f,normalSize.width/2.0f,normalSize.height/2.0f,normalSize.width/2.0f) resizingMode:UIImageResizingModeStretch]];
    }
    if (highlightedImage) {
        CGSize highlightedSize=highlightedImage.size;
        [self setHighlightedImage: [highlightedImage resizableImageWithCapInsets:UIEdgeInsetsMake(highlightedSize.height/2.0f,highlightedSize.width/2.0f,highlightedSize.height/2.0f,highlightedSize.width/2.0f) resizingMode:UIImageResizingModeStretch]];
    }
}


-(void)patternImage
{
    float patternPlace=4.0f;
    UIImage *normalImage=[self image];
    UIImage *highlightedImage=[self highlightedImage];
    if (normalImage) {
        CGSize normalSize=normalImage.size;
        [self setImage: [normalImage resizableImageWithCapInsets:UIEdgeInsetsMake(normalSize.height/patternPlace,normalSize.width/patternPlace,normalSize.height/patternPlace,normalSize.width/patternPlace) resizingMode:UIImageResizingModeTile]];
    }
    if (highlightedImage) {
        CGSize highlightedSize=highlightedImage.size;
        [self setHighlightedImage: [highlightedImage resizableImageWithCapInsets:UIEdgeInsetsMake(highlightedSize.height/patternPlace,highlightedSize.width/patternPlace,highlightedSize.height/patternPlace,highlightedSize.width/patternPlace) resizingMode:UIImageResizingModeTile]];
    }
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
