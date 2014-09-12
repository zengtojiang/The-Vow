//
//  ZLHomeViewController.h
//  THE VOW
//
//  Created by libs on 14-4-9.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLAssetCell.h"
#import "ZLAlertView.h"

@interface ZLHomeViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource,ZLAssetCellDelegate,ZLAlertViewDelegate>
{
    UICollectionView     *mCollectionView;
    NSMutableArray  *mAssetsArray;
    NSTimer         *mRefreshTimer;//计时器
}
@property(nonatomic,assign)ZLAssetObject *sellingAsset;
@end
