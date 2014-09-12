//
//  HSIconButton.h
//  HSMCBStandardEdition
//
//  Created by jiangll on 13-9-11.
//  Copyright (c) 2013年 hisunsray. All rights reserved.
//
/**
 左边一个icon，右边有文字的button。用于创建会议页面选择会议类型
 */
#import <UIKit/UIKit.h>

@interface HSIconButton : UIButton
{
    BOOL        bSelected;//是否选中
}
@property(nonatomic,retain)UIImageView *imvIcon;//图标
@property(nonatomic,retain)UILabel     *lblTitle;//文本

@property(nonatomic,retain)UIImage *normalImage;
@property(nonatomic,retain)UIImage *selectedImage;
-(void)setSelected:(BOOL)selected;
-(BOOL)isSelected;
@end
