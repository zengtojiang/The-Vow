//
//  ZLShopViewController.h
//  THE VOW
//
//  Created by libs on 14-4-14.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLStoreProductCell.h"
#import "ZLAlertView.h"
#import "ZLStoreKitManager.h"


@interface ZLShopViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource,ZLStoreProductCellDelegate,ZLAlertViewDelegate>
{
    UICollectionView     *mCollectionView;
    NSMutableArray  *mProductArray;
    int             currentBuyingIndex;
    int             buyCount;
    UIActivityIndicatorView *mActivityView;
}

@end
