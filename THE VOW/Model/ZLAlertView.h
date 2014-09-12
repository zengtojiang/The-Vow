//
//  ZLAlertView.h
//  THE VOW
//
//  Created by libs on 14-4-14.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSStretchableButton.h"
#import "HSStretchableImageView.h"

@protocol ZLAlertViewDelegate;
@interface ZLAlertView : UIView
{
    HSStretchableImageView     *imvAlertView;
    UILabel         *lblMessage;
    HSStretchableButton        *btnCancel;
    HSStretchableButton        *btnConfirm;
}

@property(nonatomic,assign)id<ZLAlertViewDelegate> delegate;

- (id)initWithMessage:(NSString *)message delegate:(id /*<ZLAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitles:(NSString *)otherButtonTitles;
-(NSInteger)cancelButtonIndex;
-(NSInteger)confirmButtonIndex;

-(void)show;
@end

@protocol ZLAlertViewDelegate <NSObject>

- (void)alertView:(ZLAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end