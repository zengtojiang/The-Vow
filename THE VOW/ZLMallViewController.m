//
//  ZLMallViewController.m
//  THE VOW
//
//  Created by libs on 14-4-9.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import "ZLMallViewController.h"
#import "ZLAssetCell.h"
#import "ZLHistoryManager.h"
#import "ZLAppDelegate.h"

@interface ZLMallViewController ()

@end

@implementation ZLMallViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initNavigationBar];
    [self initProducts];
    [self initCollectionView];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    mCollectionView.delegate=nil;
    mCollectionView.dataSource=nil;
    [mCollectionView removeFromSuperview];
    mCollectionView=nil;
    [mProductArray removeAllObjects];
    mProductArray=nil;
    for (UIView *subView in [self.view subviews]) {
        [subView removeFromSuperview];
    }
}

-(void)reloadProductData
{
    [self initProducts];
    if (mCollectionView) {
        [mCollectionView reloadData];
    }
}

-(void)initProducts
{
    if (!mProductArray) {
        mProductArray=[[NSMutableArray alloc] init];
    }
    [mProductArray removeAllObjects];
    NSString *assetPath=[[NSBundle mainBundle] pathForResource:@"assets" ofType:@"plist"];
    NSArray *assetArray=[NSArray arrayWithContentsOfFile:assetPath];
    if (assetArray&&[assetArray count]>1)
    {
        for (int i=1; i<[assetArray count]; i++) {
            ZLAssetObject *assetObject=[[ZLAssetObject alloc] initWithData:[assetArray objectAtIndex:i]];
            assetObject.genDuration=assetObject.genDuration*60;
            [mProductArray addObject:assetObject];
        }
    }
}

-(void)initNavigationBar
{
    UIImageView *bgView=[[UIImageView alloc] initWithFrame:self.view.bounds];
     bgView.image=[UIImage imageNamed:iPhone5?@"bg3-568h.png":@"bg3.png"];
    [self.view addSubview:bgView];
//    UIImageView *bgView=[[UIImageView alloc] initWithFrame:self.view.bounds];
//    bgView.image=[UIImage imageNamed:@"theme2.jpg"];
//    [self.view addSubview:bgView];
    
    HSStretchableImageView *imvHead=[[HSStretchableImageView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, ZL_HEADVIEW_HEIGHT-20)];
    imvHead.image=[UIImage imageNamed:@"skillbg6.png"];//tabbg2.png
    [imvHead stretchImage];
    //imvHead.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbarBlue.png"]];
    [self.view addSubview:imvHead];
    
    UILabel *lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, ZL_HEADVIEW_HEIGHT-20-5)];
    lblTitle.font=[UIFont fontWithName:ZL_DEFAULT_FONT_NAME size:ZL_BIG_FONT_SIZE];
    lblTitle.text=NSLocalizedString(@"Mall",nil);
    lblTitle.textColor=ZL_HEADVIEW_TEXTCOLOR;//[UIColor whiteColor];
    lblTitle.textAlignment=NSTextAlignmentCenter;
    lblTitle.backgroundColor=[UIColor clearColor];
    [self.view addSubview:lblTitle];
    
//    UIButton *btnShop=[UIButton buttonWithType:UIButtonTypeCustom];
//    UIImage *buttonImage=[UIImage imageNamed:@"gotoshop.png"];
//    [btnShop setBackgroundImage:buttonImage forState:UIControlStateNormal];//@"buttonGreen.png"
//    btnShop.frame=CGRectMake(self.view.frame.size.width-buttonImage.size.width-10, (ZL_HEADVIEW_HEIGHT-20-buttonImage.size.height)/2+20, buttonImage.size.width, buttonImage.size.height);
//    //[btnShop setTitle:@"Shop" forState:UIControlStateNormal];
//    btnShop.titleLabel.font=[UIFont fontWithName:ZL_DEFAULT_FONT_NAME size:ZL_SMALL_FONT_SIZE];
//    [btnShop setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    //[btnShop stretchImage];
//    [self.view addSubview:btnShop];
//    [btnShop addTarget:self action:@selector(onTapShopButton) forControlEvents:UIControlEventTouchUpInside];
}

-(void)initCollectionView
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    //UICollectionViewLayout *collectionViewLayout=
    mCollectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, ZL_HEADVIEW_HEIGHT, self.view.frame.size.width, self.view.frame.size.height-ZL_HEADVIEW_HEIGHT) collectionViewLayout:flowLayout];//[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    mCollectionView.backgroundColor=[UIColor clearColor];
//    UIImageView *bgView=[[UIImageView alloc] initWithFrame:self.view.bounds];
//    bgView.image=[UIImage imageNamed:@"bg2.jpg"];
//    mCollectionView.backgroundView=bgView;
    [mCollectionView registerClass:[ZLProductCell class] forCellWithReuseIdentifier:@"productcell"];
    mCollectionView.delegate=self;
    ///mCollectionView.separatorStyle=UITableViewCellSeparatorStyleNone;
    mCollectionView.dataSource=self;
    [self.view addSubview:mCollectionView];
}

-(void)showEmptyView
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - ZLAlertViewDelegate
- (void)alertView:(ZLAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    PLAY_TAP_BUTTON_AUDIO;
    if (alertView.tag==10000) {
        if (buttonIndex==[alertView cancelButtonIndex]) {
            
        }else{
            if (currentBuyingIndex>=0&&currentBuyingIndex<[mProductArray count]) {
                ZLAssetObject *product=[mProductArray objectAtIndex:currentBuyingIndex];
                [ZLHistoryManager reduceScore:product.assetValue];
                [ZLHistoryManager addNewAssets:product];
                [[NSNotificationCenter defaultCenter] postNotificationName:ZL_REFRESS_GOLDS_NOTIFICATION object:nil];
                ZLAlertView *alertView=[[ZLAlertView alloc] initWithMessage:[NSString stringWithFormat:NSLocalizedString(@"You have got one %@ with %d gold successfully.",nil),NSLocalizedString(product.assetName,nil),product.assetValue] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) confirmButtonTitles:nil];
                [alertView show];
                currentBuyingIndex =-1;
            }
        }
    }
}

#pragma mark - ZLProductCellDelegate

-(void)onTapBuyOneOfCell:(ZLProductCell *)cell
{
    PLAY_TAP_BUTTON_AUDIO;
    int index=(int)cell.tag-100;
    int assetValue=cell.productObject.assetValue;
    if ([ZLHistoryManager getLastScore]<assetValue) {
        ZLAlertView *alertView=[[ZLAlertView alloc] initWithMessage:NSLocalizedString(@"Sorry, you have not enough gold.",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) confirmButtonTitles:nil];
        [alertView show];
    }else{
        currentBuyingIndex=index;
        ZLAlertView *alertView=[[ZLAlertView alloc] initWithMessage:[NSString stringWithFormat:NSLocalizedString(@"Are you sure to buy %1$@ with %2$d gold?",nil),NSLocalizedString(cell.productObject.assetName,nil),cell.productObject.assetValue] delegate:self cancelButtonTitle:NSLocalizedString(@"NO",nil) confirmButtonTitles:NSLocalizedString(@"YES",nil)];
        alertView.tag=10000;
        [alertView show];
    }
}

#pragma mark - UICollectionViewDatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [mProductArray count];
}

/*
//设置分区
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
 */

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"productcell";
    ZLProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    //[cell sizeToFit];
    if (!cell) {
    }
    cell.cellDelegate=self;
    cell.tag=100+indexPath.row;
    [cell setCellData:[mProductArray objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - collectionView delegate



//设置元素的的大小框
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //UIEdgeInsets top = {5,10,15,5};
    UIEdgeInsets top = {10,ZL_TABLEVIEW_LEFTMARGIN,10,ZL_TABLEVIEW_LEFTMARGIN};
    return top;
}

//设置顶部的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={0,0};
    return size;
}
//设置元素大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //return CGSizeMake(120,130);
    return CGSizeMake(self.view.frame.size.width-2*ZL_TABLEVIEW_LEFTMARGIN,ZL_PRODUCT_CELL_HEIGHT);
    //return CGSizeMake(240,(kDeviceHeight-kNavHeight*2-kTabBarHeight-20)/4.0);
}

@end
