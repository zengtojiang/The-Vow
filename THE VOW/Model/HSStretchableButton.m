//
//  HSStretchableButton.m
//  HSMCBStandardEdition
//
//  Created by jiangll on 13-8-1.
//  Copyright (c) 2013年 hisunsray. All rights reserved.
//

#import "HSStretchableButton.h"

@implementation HSStretchableButton

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
    UIImage *normalImage=[self backgroundImageForState:UIControlStateNormal];
    UIImage *highlightedImage=[self backgroundImageForState:UIControlStateHighlighted];
    UIImage *selectedImage=[self backgroundImageForState:UIControlStateSelected];
    UIImage *hiliSelectedImage=[self backgroundImageForState:(UIControlStateHighlighted|UIControlStateSelected)];
    UIImage *disabledImage=[self backgroundImageForState:UIControlStateDisabled];
    if (normalImage) {
        CGSize normalSize=normalImage.size;
        [self setBackgroundImage:[normalImage resizableImageWithCapInsets:UIEdgeInsetsMake(normalSize.height/2.0f,normalSize.width/2.0f,normalSize.height/2.0f,normalSize.width/2.0f) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
        //[self setBackgroundImage:[normalImage resizableImageWithCapInsets:UIEdgeInsetsMake(normalSize.height/2.0f,0,normalSize.height/2.0f,0)] forState:UIControlStateNormal];
        
    }
    if (highlightedImage) {
        CGSize highlightedSize=highlightedImage.size;
        [self setBackgroundImage:[highlightedImage resizableImageWithCapInsets:UIEdgeInsetsMake(highlightedSize.height/2.0f,highlightedSize.width/2.0f,highlightedSize.height/2.0f,highlightedSize.width/2.0f) resizingMode:UIImageResizingModeStretch]forState:UIControlStateHighlighted];
    }
    if (selectedImage) {
        CGSize selectedSize=selectedImage.size;
        [self setBackgroundImage:[selectedImage resizableImageWithCapInsets:UIEdgeInsetsMake(selectedSize.height/2.0f,selectedSize.width/2.0f,selectedSize.height/2.0f,selectedSize.width/2.0f) resizingMode:UIImageResizingModeStretch] forState:UIControlStateSelected];
        
    }
    if (hiliSelectedImage) {
        CGSize highlightedSize=hiliSelectedImage.size;
        [self setBackgroundImage:[hiliSelectedImage resizableImageWithCapInsets:UIEdgeInsetsMake(highlightedSize.height/2.0f,highlightedSize.width/2.0f,highlightedSize.height/2.0f,highlightedSize.width/2.0f) resizingMode:UIImageResizingModeStretch]forState:(UIControlStateHighlighted|UIControlStateSelected)];
    }
    
    if (disabledImage) {
        CGSize disabledImageSize=disabledImage.size;
        [self setBackgroundImage:[disabledImage resizableImageWithCapInsets:UIEdgeInsetsMake(disabledImageSize.height/2.0f,disabledImageSize.width/2.0f,disabledImageSize.height/2.0f,disabledImageSize.width/2.0f) resizingMode:UIImageResizingModeStretch]forState:(UIControlStateDisabled)];
    }
}

-(void)patternImage
{
    float patternPlace=4.0f;
    UIImage *normalImage=[self backgroundImageForState:UIControlStateNormal];
    UIImage *highlightedImage=[self backgroundImageForState:UIControlStateHighlighted];
    UIImage *selectedImage=[self backgroundImageForState:UIControlStateSelected];
    UIImage *hiliSelectedImage=[self backgroundImageForState:(UIControlStateHighlighted|UIControlStateSelected)];
    UIImage *disabledImage=[self backgroundImageForState:UIControlStateDisabled];
    if (normalImage) {
        CGSize normalSize=normalImage.size;
        [self setBackgroundImage:[normalImage resizableImageWithCapInsets:UIEdgeInsetsMake(normalSize.height/patternPlace,normalSize.width/patternPlace,normalSize.height/patternPlace,normalSize.width/patternPlace) resizingMode:UIImageResizingModeTile] forState:UIControlStateNormal];
        //[self setBackgroundImage:[normalImage resizableImageWithCapInsets:UIEdgeInsetsMake(normalSize.height/2.0f,0,normalSize.height/2.0f,0)] forState:UIControlStateNormal];
        
    }
    if (highlightedImage) {
        CGSize highlightedSize=highlightedImage.size;
        [self setBackgroundImage:[highlightedImage resizableImageWithCapInsets:UIEdgeInsetsMake(highlightedSize.height/patternPlace,highlightedSize.width/patternPlace,highlightedSize.height/patternPlace,highlightedSize.width/patternPlace) resizingMode:UIImageResizingModeTile]forState:UIControlStateHighlighted];
    }
    if (selectedImage) {
        CGSize selectedSize=selectedImage.size;
        [self setBackgroundImage:[selectedImage resizableImageWithCapInsets:UIEdgeInsetsMake(selectedSize.height/patternPlace,selectedSize.width/patternPlace,selectedSize.height/patternPlace,selectedSize.width/patternPlace) resizingMode:UIImageResizingModeTile] forState:UIControlStateSelected];
        
    }
    if (hiliSelectedImage) {
        CGSize highlightedSize=hiliSelectedImage.size;
        [self setBackgroundImage:[hiliSelectedImage resizableImageWithCapInsets:UIEdgeInsetsMake(highlightedSize.height/patternPlace,highlightedSize.width/patternPlace,highlightedSize.height/patternPlace,highlightedSize.width/patternPlace) resizingMode:UIImageResizingModeTile]forState:(UIControlStateHighlighted|UIControlStateSelected)];
    }
    
    if (disabledImage) {
        CGSize disabledImageSize=disabledImage.size;
        [self setBackgroundImage:[disabledImage resizableImageWithCapInsets:UIEdgeInsetsMake(disabledImageSize.height/patternPlace,disabledImageSize.width/patternPlace,disabledImageSize.height/patternPlace,disabledImageSize.width/patternPlace) resizingMode:UIImageResizingModeTile]forState:(UIControlStateDisabled)];
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
