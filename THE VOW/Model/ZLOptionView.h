//
//  ZLOptionView.h
//  THE VOW
//
//  Created by libs on 14-4-13.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZLOptionViewDelegate;

@interface ZLOptionView : UIView
{
    UIScrollView    *mChipScrollView;
    UIButton        *mOptionButton;
    ZL_CHIPS_TYPE   chipType;
}
@property(nonatomic,assign)id<ZLOptionViewDelegate> delegate;

-(void)setOptionButtonImage:(UIImage *)image;
@end


@protocol ZLOptionViewDelegate <NSObject>

-(void)onTapOptionUpDownButton:(ZLOptionView *)optionView;

-(void)onOptionViewChangeChipType:(ZL_CHIPS_TYPE)type;

@end