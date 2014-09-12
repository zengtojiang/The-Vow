//
//  UIImage+PatternImage.h
//  HSMCBStandardEdition
//
//  Created by jiangll on 13-8-22.
//  Copyright (c) 2013年 hisunsray. All rights reserved.
//
//由pattern图片生成所需图片
#import <UIKit/UIKit.h>

@interface UIImage (PatternImage)
-(UIImage*)patternImageWithSize:(CGSize)size;

//截取部分图像
-(UIImage*)getSubImage:(CGRect)rect;
@end
