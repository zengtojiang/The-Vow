//
//  ZLGameViewController.h
//  THE VOW
//
//  Created by libs on 14-4-9.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#ifndef TEST_STOREKIT
#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "ZLHeadView.h"
#import "HSIconButton.h"
#import "ZLOptionView.h"
#import "ZLAlertView.h"
#import "HSStretchableButton.h"

typedef NS_ENUM(int, ZLColorType)
{
    ZLColorRed=0,
    ZLColorBlack=1,
    ZLColorGreen=2,
};


@interface ZLGameViewController : UIViewController<ZLOptionViewDelegate,ZLAlertViewDelegate>
{
    ZLHeadView  *_headView;
    
    //HSStretchableButton    *_playButton;
    UIButton        *_playButton;
    HSIconButton    *mBtnAutoMiss;//自动miss
    HSStretchableButton   *mBtnShop;//商店
    
    //颜色
    HSIconButton    *mBtnColorRed;
    HSIconButton    *mBtnColorBlack;
    HSIconButton    *mBtnColorGreen;
    ZLColorType     _betColorType;
    
    UIButton    *btnChipIcon;
    UILabel     *lblChipCount;
    UIStepper   *stepChips;
    
    ZL_CHIPS_TYPE   chipType;//筹码值
    
    int         _maxChipsCount;//最多多少筹码
    int         _betChipCount;
    
    ZLColorType      _resultType;
    
    ZLOptionView    *mOptionView;
    BOOL        _optionViewOpened;
    BOOL        _initRotation;
}

-(void)startInitRotate;
@end
#endif
