//
//  UIImage+PatternImage.m
//  HSMCBStandardEdition
//
//  Created by jiangll on 13-8-22.
//  Copyright (c) 2013年 hisunsray. All rights reserved.
//

#import "UIImage+PatternImage.h"
#import <AVFoundation/AVFoundation.h>

@implementation UIImage (PatternImage)

-(UIImage*)patternImageWithSize:(CGSize)size
{
    UIImage* newImage = nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, 2.0f);
    
    [self drawAsPatternInRect:CGRectMake(0, 0, size.width, size.height)];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

//截取部分图像
-(UIImage*)getSubImage:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}
@end
