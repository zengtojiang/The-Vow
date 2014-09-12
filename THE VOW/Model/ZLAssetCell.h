//
//  ZLAssetCell.h
//  THE VOW
//
//  Created by libs on 14-4-9.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSStretchableButton.h"
#import "HSStretchableImageView.h"


@interface ZLAssetObject : NSObject

@property(nonatomic,copy)NSString   *assetName;
@property(nonatomic,assign)int      assetIndex;
@property(nonatomic,assign)int      gold;
@property(nonatomic,assign)int      assetValue;//资产价值
@property(nonatomic,assign)int      genDuration;
@property(nonatomic,retain)NSDate   *lastDate;

-(id)initWithData:(NSDictionary *)data;

-(NSDictionary *)dicData;
@end

@protocol ZLAssetCellDelegate;
@interface ZLAssetCell : UICollectionViewCell
{
    UIImageView     *imvIcon;
    UILabel         *lblName;
    //UILabel         *lblDescprition;
    UILabel         *lblTime;
    HSStretchableButton        *btnReap;
    HSStretchableButton        *btnSell;//出售
}
@property(nonatomic,assign)id<ZLAssetCellDelegate> cellDelegate;
@property(nonatomic,assign)ZLAssetObject *assetObject;

-(void)setCellData:(ZLAssetObject *)cellData;

-(void)refreshReapTime;
@end

@protocol ZLAssetCellDelegate <NSObject>

-(void)onSellAssetsOfCell:(ZLAssetCell *)cell;

-(void)onReapAssetsOfCell:(ZLAssetCell *)cell;

@end