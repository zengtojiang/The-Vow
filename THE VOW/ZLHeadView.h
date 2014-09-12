//
//  ZLHeadView.h
//  THE VOW
//
//  Created by libs on 14-4-9.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSStretchableImageView.h"

@interface ZLHeadView : HSStretchableImageView
{
    UIImageView     *imvGold;
    UILabel         *lblGold;
//    UIImageView     *imvClass;
    UILabel         *lblMiss;
}

-(void)resetAssets;
@end
