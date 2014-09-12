//
//  ZLProductCell.m
//  THE VOW
//
//  Created by libs on 14-4-11.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import "ZLProductCell.h"

@implementation ZLProductCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        HSStretchableImageView *imvbg=[[HSStretchableImageView alloc] initWithFrame:self.bounds];
        //imvBackground.image=[UIImage imageNamed:@"cellbgbro.png"];
        imvbg.image=[UIImage imageNamed:@"cell_bg.png"];
        [imvbg stretchImage];
        self.backgroundView=imvbg;

        UIImageView *imvIconBG=[[UIImageView alloc] initWithFrame:CGRectMake(8, (ZL_PRODUCT_CELL_HEIGHT-60)/2, 60, 60)];
        imvIconBG.image=[UIImage imageNamed:@"optionbg2.png"];
        [self.contentView addSubview:imvIconBG];
        
        imvIcon=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
        imvIcon.image=[UIImage imageNamed:@"asset1.png"];
        [imvIconBG addSubview:imvIcon];
        
//        imvIcon=[[UIImageView alloc] initWithFrame:CGRectMake(8,(ZL_PRODUCT_CELL_HEIGHT-60)/2,60,60)];
//        imvIcon.image=[UIImage imageNamed:@"renmo2.png"];
//        [self.contentView addSubview:imvIcon];
        
        lblName=[[UILabel alloc] initWithFrame:CGRectMake(73,5,220,38)];
        lblName.backgroundColor=[UIColor clearColor];
        //lblName.numberOfLines=1;
        lblName.numberOfLines=2;
        lblName.font=[UIFont fontWithName:ZL_DEFAULT_FONT_NAME size:ZL_SMALL_FONT_SIZE];
        lblName.textColor=ZL_CELLTITLE_TEXTCOLOR;//[UIColor whiteColor];
        [self.contentView addSubview:lblName];
        
        lblPrice=[[UILabel alloc] initWithFrame:CGRectMake(73,40,140,20)];
        lblPrice.backgroundColor=[UIColor clearColor];
        lblPrice.font=[UIFont fontWithName:ZL_DEFAULT_FONT_NAME size:ZL_SMALL_FONT_SIZE];
        lblPrice.textColor=[UIColor whiteColor];
        [self.contentView addSubview:lblPrice];
        
        btnBuy=[HSStretchableButton buttonWithType:UIButtonTypeCustom];
        [btnBuy setBackgroundImage:[UIImage imageNamed:@"buttonGreen.png"] forState:UIControlStateNormal];
        btnBuy.frame=CGRectMake(225,35,60,30);
        [btnBuy stretchImage];
        [btnBuy setTitle:NSLocalizedString(@"Get It",nil) forState:UIControlStateNormal];
        btnBuy.titleLabel.font=[UIFont fontWithName:ZL_DEFAULT_FONT_NAME size:ZL_SMALL_FONT_SIZE];
        [btnBuy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:btnBuy];
        [btnBuy addTarget:self action:@selector(onTapBuyProduct) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setCellData:(ZLAssetObject *)cellData
{
    self.productObject=cellData;
    if([cellData.assetName isEqualToString:@"Dream City"]){
        imvIcon.image=[UIImage imageNamed:@"asset2.png"];
    }else if([cellData.assetName isEqualToString:@"Castle"]||[cellData.assetName isEqualToString:@"Village"]){
        imvIcon.image=[UIImage imageNamed:@"asset3.png"];
    }else{
        imvIcon.image=[UIImage imageNamed:@"asset1.png"];
    }
    //imvIcon.image=[UIImage imageNamed:[NSString stringWithFormat:@"renmo%d.png",arc4random()%2+1]];
    lblPrice.text=[NSString stringWithFormat:NSLocalizedString(@"Consume %d gold",nil),cellData.assetValue];
    //lblName.text=[NSString stringWithFormat:NSLocalizedString(@"%@(Yields %d gold in every %d minutes)", nil),NSLocalizedString(cellData.assetName, nil),cellData.gold,cellData.genDuration/60];
     lblName.text=[NSString stringWithFormat:NSLocalizedString(@"%1$@(Yields %2$d gold in every %3$d minutes)", nil),NSLocalizedString(cellData.assetName, nil),cellData.gold,cellData.genDuration/60];
}

-(void)onTapBuyProduct
{
    [self.cellDelegate onTapBuyOneOfCell:self];
}
@end
