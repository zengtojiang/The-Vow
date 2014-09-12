//
//  ZLStoreProductCell.m
//  THE VOW
//
//  Created by libs on 14-4-15.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import "ZLStoreProductCell.h"
#import "ZLAppDelegate.h"

@implementation ZLStoreProductCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        HSStretchableImageView *imvbg=[[HSStretchableImageView alloc] initWithFrame:self.bounds];
        //imvBackground.image=[UIImage imageNamed:@"cellbgbro.png"];
        imvbg.image=[UIImage imageNamed:@"cell_bg_gray.png"];
        [imvbg stretchImage];
        self.backgroundView=imvbg;
        
        UIImageView *imvbg1=[[UIImageView alloc] initWithFrame:self.bounds];
        imvbg1.image=[UIImage imageNamed:@"storebg.png"];
        [self.contentView addSubview:imvbg1];
        
         UIImageView *imviconbg=[[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-60)/2,20,60,60)];
         imviconbg.image=[UIImage imageNamed:@"optionbg.png"];
         [self.contentView addSubview:imviconbg];
        
        imvIcon=[[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-50)/2,25,50,50)];
        //imvIcon.image=[UIImage imageNamed:@"renmo2.png"];
        [self.contentView addSubview:imvIcon];
        
        float lblLeftMargin=10;
        float textHeight=18;
        
        lblName=[[UILabel alloc] initWithFrame:CGRectMake(lblLeftMargin,80,self.frame.size.width-2*lblLeftMargin,textHeight*2)];
        lblName.backgroundColor=[UIColor clearColor];
        lblName.numberOfLines=2;
        lblName.textAlignment=NSTextAlignmentCenter;
        lblName.font=[UIFont fontWithName:ZL_DEFAULT_FONT_NAME size:ZL_SMALL_FONT_SIZE];
        lblName.textColor=ZL_HEADVIEW_TEXTCOLOR;//[UIColor whiteColor];
        [self.contentView addSubview:lblName];
        
        /*
        lblDesc=[[UILabel alloc] initWithFrame:CGRectMake(lblLeftMargin,100,self.frame.size.width-2*lblLeftMargin,textHeight)];
        lblDesc.backgroundColor=[UIColor clearColor];
        lblDesc.numberOfLines=1;
        lblDesc.textAlignment=NSTextAlignmentCenter;
        lblDesc.font=[UIFont fontWithName:ZL_DEFAULT_FONT_NAME size:ZL_SMALL_FONT_SIZE];
        lblDesc.textColor=ZL_CELLTITLE_TEXTCOLOR;
        [self.contentView addSubview:lblDesc];
        */
        btnStep=[[UIStepper alloc] init];
        //btnStep.frame=CGRectMake(lblLeftMargin+25,120,,30);
        btnStep.center=CGPointMake(self.frame.size.width/2,135);
        [self.contentView addSubview:btnStep];
        [btnStep addTarget:self action:@selector(onChangeStepperValue:) forControlEvents:UIControlEventValueChanged];
        btnStep.minimumValue=1;
        btnStep.stepValue=1;
        btnStep.maximumValue=100;
        btnStep.value=1;
        
        btnBuy=[HSStretchableButton buttonWithType:UIButtonTypeCustom];
        [btnBuy setBackgroundImage:[UIImage imageNamed:@"buttonGreen.png"] forState:UIControlStateNormal];
        btnBuy.frame=CGRectMake(10,160,130,30);
        [btnBuy stretchImage];
        //[btnBuy setTitle:[NSString stringWithFormat:NSLocalizedString(@"Buy(%d)",nil),btnStep.value] forState:UIControlStateNormal];
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

-(void)setCellData:(SKProduct *)cellData
{
    btnStep.value=1;
    self.buyCount=1;
    self.productObject=cellData;
    
    NSString *identifier=self.productObject.productIdentifier;
    ZLTRACE(@"number:%@",[identifier substringFromIndex:19]);
    NSInteger lastNumber=[[identifier substringFromIndex:19] integerValue];
    if (lastNumber==1||lastNumber==2) {
        imvIcon.image=[UIImage imageNamed:@"donateIcon.png"];
    }else if(lastNumber==3){
        imvIcon.image=[UIImage imageNamed:@"goldbag1.png"];
    }else if(lastNumber==4){
        imvIcon.image=[UIImage imageNamed:@"goldbag3.png"];
    }else{
        imvIcon.image=[UIImage imageNamed:@"asset.png"];
    }
    /*
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString *groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
    [formatter setGroupingSeparator:groupingSeparator];
    [formatter setGroupingSize:3];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    [formatter setUsesGroupingSeparator:YES];
    */
    NSString *currencySymbol=[self.productObject.priceLocale objectForKey:NSLocaleCurrencySymbol];
    float price=[self.productObject.price floatValue];
    
    [btnBuy setTitle:[NSString stringWithFormat:@"%@(%d/%@%.2f)",NSLocalizedString(@"Buy",nil),self.buyCount,currencySymbol,self.buyCount*price] forState:UIControlStateNormal];
    //imvIcon.image=[UIImage imageNamed:[NSString stringWithFormat:@"renmo%d.png",arc4random()%2+1]];
    //lblPrice.text=[NSString stringWithFormat:@"Price: %d",[cellData.price integerValue]];
    
    ZLAppDelegate *appDelegate=(ZLAppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *iapData=appDelegate.iapData;
    BOOL hasName=NO;
    if (iapData&&[iapData count]) {
        NSString *strProduct=[iapData objectForKey:self.productObject.productIdentifier];
        if (strProduct) {
            //cellData.localizedDescription
            NSArray *arrData=[strProduct componentsSeparatedByString:@";"];
            if (arrData&&[arrData count]==2) {
                int gold=[[arrData objectAtIndex:1] intValue];
                int miss=[[arrData objectAtIndex:0] intValue];
                if (gold&&miss) {
                    lblName.text=[NSString stringWithFormat:@"%@(%d %@%d %@)",cellData.localizedTitle,gold,NSLocalizedString(@"GOLD and", nil),miss,NSLocalizedString(@"MISS", nil)];
                    hasName=YES;
                }
                /*
                else if(gold){
                    lblName.text=[NSString stringWithFormat:@"%@(%d %@)",cellData.localizedTitle,gold,NSLocalizedString(@"GOLD", nil)];
                    hasName=YES;
                }else if(miss){
                    lblName.text=[NSString stringWithFormat:@"%@(%d %@)",cellData.localizedTitle,miss,NSLocalizedString(@"MISS", nil)];
                    hasName=YES;
                }
                 */
            }
        }
    }
    if (!hasName) {
        lblName.text=[NSString stringWithFormat:@"%@",cellData.localizedTitle];
    }
    //lblName.text=[NSString stringWithFormat:@"%@(%@)",cellData.localizedTitle,cellData.localizedDescription];
}

-(void)onTapBuyProduct
{
    [self.cellDelegate onTapBuyOneOfCell:self];
}

-(void)onChangeStepperValue:(UIStepper *)stepper
{
    self.buyCount=stepper.value;
    NSString *currencySymbol=[self.productObject.priceLocale objectForKey:NSLocaleCurrencySymbol];
    float price=[self.productObject.price floatValue];
    
    [btnBuy setTitle:[NSString stringWithFormat:NSLocalizedString(@"Buy(%d/%@%.2f)",nil),self.buyCount,currencySymbol,self.buyCount*price] forState:UIControlStateNormal];
    //[btnBuy setTitle:[NSString stringWithFormat:NSLocalizedString(@"Buy(%d)",nil),self.buyCount] forState:UIControlStateNormal];
}

@end
