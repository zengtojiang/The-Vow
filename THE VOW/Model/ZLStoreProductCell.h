//
//  ZLStoreProductCell.h
//  THE VOW
//
//  Created by libs on 14-4-15.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLAssetCell.h"
#import "HSStretchableImageView.h"
#import "HSStretchableButton.h"
#import <StoreKit/StoreKit.h>

@protocol ZLStoreProductCellDelegate;

@interface ZLStoreProductCell : UICollectionViewCell
{
    UIImageView     *imvIcon;
    UILabel         *lblName;//名字
   // UILabel         *lblDesc;//描述
    UIStepper       *btnStep;
    HSStretchableButton        *btnBuy;
}
@property(nonatomic,assign)id<ZLStoreProductCellDelegate> cellDelegate;
@property(nonatomic,assign)SKProduct *productObject;
@property(nonatomic,assign)int    buyCount;

-(void)setCellData:(SKProduct *)cellData;

@end

@protocol ZLStoreProductCellDelegate <NSObject>

-(void)onTapBuyOneOfCell:(ZLStoreProductCell *)cell;

@end
