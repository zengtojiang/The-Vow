//
//  ZLProductCell.h
//  THE VOW
//
//  Created by libs on 14-4-11.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLAssetCell.h"
#import "HSStretchableImageView.h"
#import "HSStretchableButton.h"

@protocol ZLProductCellDelegate;
@interface ZLProductCell : UICollectionViewCell
{
    UIImageView     *imvIcon;
    UILabel         *lblName;//名字
    UILabel         *lblPrice;//标价
    //UILabel         *lblDesc;//描述
    HSStretchableButton        *btnBuy;
}
@property(nonatomic,assign)id<ZLProductCellDelegate> cellDelegate;
@property(nonatomic,assign)ZLAssetObject *productObject;

-(void)setCellData:(ZLAssetObject *)cellData;

@end

@protocol ZLProductCellDelegate <NSObject>

-(void)onTapBuyOneOfCell:(ZLProductCell *)cell;

@end