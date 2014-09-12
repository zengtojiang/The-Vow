//
//  ZLMallViewController.h
//  THE VOW
//
//  Created by libs on 14-4-9.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLProductCell.h"
#import "ZLAlertView.h"

@interface ZLMallViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource,ZLProductCellDelegate,ZLAlertViewDelegate>
{
    UICollectionView     *mCollectionView;
    NSMutableArray  *mProductArray;
    int             currentBuyingIndex;
}
@end
