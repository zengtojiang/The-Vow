//
//  ZLAssetCell.m
//  THE VOW
//
//  Created by libs on 14-4-9.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import "ZLAssetCell.h"
#import "HSDateFormatter.h"

@implementation ZLAssetObject

-(id)initWithData:(NSDictionary *)data
{
    self=[super init];
    if (self) {
        self.gold=[[data objectForKey:@"gold"] intValue];
        self.assetValue=[[data objectForKey:@"value"] intValue];
        self.genDuration=[[data objectForKey:@"duration"] intValue];
        self.assetName=[data objectForKey:@"name"];
        self.lastDate=[data objectForKey:@"date"];
    }
    return self;
}

-(NSDictionary *)dicData;
{
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:self.gold],@"gold",[NSNumber numberWithInt:self.assetValue],@"value",[NSNumber numberWithInt:self.genDuration],@"duration",self.assetName,@"name",self.lastDate,@"date", nil];
}
@end

@implementation ZLAssetCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        HSStretchableImageView *imvbg=[[HSStretchableImageView alloc] initWithFrame:self.bounds];
        imvbg.image=[UIImage imageNamed:@"cell_bg.png"];
        [imvbg  stretchImage];
        self.backgroundView=imvbg;
        
        UIImageView *imvIconBG=[[UIImageView alloc] initWithFrame:CGRectMake(8, (ZL_HOME_TABLEVIEW_HEIGHT-60)/2, 60, 60)];
        imvIconBG.image=[UIImage imageNamed:@"optionbg2.png"];
        [self.contentView addSubview:imvIconBG];
        
        imvIcon=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
        //imvIcon.image=[UIImage imageNamed:@"optionbg2.png"];
        [imvIconBG addSubview:imvIcon];
    
        lblName=[[UILabel alloc] initWithFrame:CGRectMake(73, 5, 220, 38)];
        lblName.backgroundColor=[UIColor clearColor];
        lblName.numberOfLines=0;
        lblName.contentMode=UIViewContentModeTopLeft;
        lblName.font=[UIFont fontWithName:ZL_DEFAULT_FONT_NAME size:ZL_SMALL_FONT_SIZE];
        lblName.textColor=ZL_CELLTITLE_TEXTCOLOR;//[UIColor whiteColor];
        [self.contentView addSubview:lblName];
        
        lblTime=[[UILabel alloc] initWithFrame:CGRectMake(73, 42, 100, 20)];
        lblTime.backgroundColor=[UIColor clearColor];
        lblTime.numberOfLines=1;
        lblTime.textAlignment=NSTextAlignmentLeft;
        lblTime.font=[UIFont fontWithName:ZL_DEFAULT_FONT_NAME size:ZL_SMALL_FONT_SIZE];
        lblTime.textColor=[UIColor whiteColor];
        [self.contentView addSubview:lblTime];
        
        btnReap=[HSStretchableButton buttonWithType:UIButtonTypeCustom];
        [btnReap setBackgroundImage:[UIImage imageNamed:@"buttonBlue.png"] forState:UIControlStateNormal];//@"buttonGreen.png"
        [btnReap setBackgroundImage:[UIImage imageNamed:@"buttonBlue_disabled.png"] forState:UIControlStateDisabled];
        btnReap.frame=CGRectMake(145, 42, 60, 30);
        [btnReap setTitle:NSLocalizedString(@"Reap",nil) forState:UIControlStateNormal];
        btnReap.titleLabel.font=[UIFont fontWithName:ZL_DEFAULT_FONT_NAME size:ZL_SMALL_FONT_SIZE];
        [btnReap setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnReap setTitleColor:ZL_DISABLE_TEXTCOLOR forState:UIControlStateDisabled];
        [btnReap stretchImage];
        [self.contentView addSubview:btnReap];
        [btnReap addTarget:self action:@selector(onTapReap) forControlEvents:UIControlEventTouchUpInside];
        
        btnSell=[HSStretchableButton buttonWithType:UIButtonTypeCustom];
        [btnSell setBackgroundImage:[UIImage imageNamed:@"buttonRed.png"] forState:UIControlStateNormal];//@"buttonBlue.png"
        [btnSell setBackgroundImage:[UIImage imageNamed:@"buttonRed_disabled.png"] forState:UIControlStateDisabled];
        btnSell.frame=CGRectMake(225,42,60,30);//CGRectMake(240, 35, 60, 30);
        [btnSell stretchImage];
        [btnSell setTitle:NSLocalizedString(@"Sell",nil) forState:UIControlStateNormal];
        btnSell.titleLabel.font=[UIFont fontWithName:ZL_DEFAULT_FONT_NAME size:ZL_SMALL_FONT_SIZE];
        [btnSell setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnSell setTitleColor:ZL_DISABLE_TEXTCOLOR forState:UIControlStateDisabled];
        [self.contentView addSubview:btnSell];
        [btnSell addTarget:self action:@selector(onTapSell) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


-(void)setCellData:(ZLAssetObject *)cellData
{
    self.assetObject=cellData;
    //lblName.text=[NSString stringWithFormat:NSLocalizedString(@"%@(Yields %d gold in every %d minutes)", nil),NSLocalizedString(cellData.assetName, nil),cellData.gold,cellData.genDuration/60];
     lblName.text=[NSString stringWithFormat:NSLocalizedString(@"%1$@(Yields %2$d gold in every %3$d minutes)", nil),NSLocalizedString(cellData.assetName, nil),cellData.gold,cellData.genDuration/60];
    
    [self refreshReapTime];
    if ([cellData.assetName isEqualToString:ZL_INNATE_TALENT_NAME]) {
        btnSell.enabled=NO;
    }else{
        btnSell.enabled=YES;
    }
    if (cellData.assetIndex==0) {
         imvIcon.image=[UIImage imageNamed:@"asset4.png"];
    }else if([cellData.assetName isEqualToString:@"Dream City"]){
        imvIcon.image=[UIImage imageNamed:@"asset2.png"];
    }else if([cellData.assetName isEqualToString:@"Castle"]||[cellData.assetName isEqualToString:@"Village"]){
        imvIcon.image=[UIImage imageNamed:@"asset3.png"];
    }else{
        imvIcon.image=[UIImage imageNamed:@"asset1.png"];
    }
   
    /*
    int duration=[[NSDate date] timeIntervalSinceDate:cellData.lastDate];//[cellData.lastDate timeIntervalSinceNow];
    ZLTRACE(@"duration:%d genDuration:%d",duration,cellData.genDuration);
    if (duration>=cellData.genDuration) {
        btnReap.enabled=YES;
        imvBackground.image=[UIImage imageNamed:@"cellbgyellow.png"];
        lblTime.text=@"";
    }else{
        btnReap.enabled=NO;
        lblTime.text=[HSDateFormatter secondsToMinutes:cellData.genDuration-duration];
        imvBackground.image=[UIImage imageNamed:@"cellbgblue.png"];
    }
     */
    //lblDescprition.text=[NSString stringWithFormat:@"Generate %d gold in every %d minutes",cellData.gold,cellData.genDuration];
}

-(void)refreshReapTime
{
    int duration=[[NSDate date] timeIntervalSinceDate:self.assetObject.lastDate];//[cellData.lastDate timeIntervalSinceNow];
    //ZLTRACE(@"duration:%d genDuration:%d",duration,cellData.genDuration);
    if (duration>=self.assetObject.genDuration) {
        btnReap.enabled=YES;
        //imvBackground.image=[UIImage imageNamed:@"cellbgyellow.png"];
        lblTime.text=@"00:00";//[NSString stringWithFormat:@"%02d:%02d",minutes,newSeconds];
    }else{
        btnReap.enabled=NO;
        lblTime.text=[HSDateFormatter secondsToMinutes:self.assetObject.genDuration-duration];
        //imvBackground.image=[UIImage imageNamed:@"cellbgblue.png"];
    }
}

-(void)onTapReap
{
    [self.cellDelegate onReapAssetsOfCell:self];
}

-(void)onTapSell
{
    [self.cellDelegate onSellAssetsOfCell:self];
}
@end
