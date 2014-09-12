//
//  ZLGuideView.h
//  THE VOW
//
//  Created by libs on 14-4-9.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZLGuideViewDelegate;

@interface ZLGuideView : UIView
{
    int         _arrIndex;
    NSArray     *arrChats;
    UIImageView *imvBG;
    UIView      *lblBG;
    UILabel     *lblChat;
}
@property(nonatomic,assign)id<ZLGuideViewDelegate> delegate;

@end

@protocol ZLGuideViewDelegate <NSObject>

-(void)onGuideViewEnded:(ZLGuideView *)view;

@end