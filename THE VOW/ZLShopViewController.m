//
//  ZLShopViewController.m
//  THE VOW
//
//  Created by libs on 14-4-14.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import "ZLShopViewController.h"
#import "ZLHistoryManager.h"
#import "ZLAppDelegate.h"

@interface ZLShopViewController ()

@end

@implementation ZLShopViewController

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
    [self registerNotification];
    [self initNavigationBar];
    [self startRequestProducts];
}

-(void)registerNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveProducts:) name:ZL_IAP_PRODUCTS_NOTIFICATION object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initProducts];
    [self initCollectionView];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    mCollectionView.delegate=nil;
    mCollectionView.dataSource=nil;
    [mCollectionView removeFromSuperview];
    mCollectionView=nil;
    [mProductArray removeAllObjects];
    mProductArray=nil;
}

-(void)startRequestProducts
{
     [(ZLAppDelegate *)([UIApplication sharedApplication].delegate) startRequestProduct];
    [mActivityView startAnimating];
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
    //[mProductArray removeAllObjects];
    /*
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
     */
}

-(void)initNavigationBar
{
    UIImageView *bgView=[[UIImageView alloc] initWithFrame:self.view.bounds];
     bgView.image=[UIImage imageNamed:iPhone5?@"bg3-568h.png":@"bg3.png"];
    [self.view addSubview:bgView];
    
    HSStretchableImageView *imvHead=[[HSStretchableImageView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, ZL_HEADVIEW_HEIGHT-20)];
    imvHead.image=[UIImage imageNamed:@"skillbg6.png"];//[UIImage imageNamed:@"optionbg3.png"];//[UIImage imageNamed:@"optionbg2.png"];
    [imvHead stretchImage];
//    
//    UIImageView *bgView=[[UIImageView alloc] initWithFrame:self.view.bounds];
//    bgView.image=[UIImage imageNamed:@"theme3.jpg"];
//    [self.view addSubview:bgView];
//    
//    UIImageView *imvHead=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, ZL_HEADVIEW_HEIGHT)];
//    imvHead.image=[UIImage imageNamed:@"topbg2.png"];
    //imvHead.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbarBlue.png"]];
    [self.view addSubview:imvHead];
    
    UILabel *lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, ZL_HEADVIEW_HEIGHT-20-5)];
    lblTitle.font=[UIFont fontWithName:ZL_DEFAULT_FONT_NAME size:ZL_BIG_FONT_SIZE];
    lblTitle.text=NSLocalizedString(@"Shop",nil);
    lblTitle.textColor=ZL_HEADVIEW_TEXTCOLOR;//[UIColor whiteColor];
    lblTitle.textAlignment=NSTextAlignmentCenter;
    lblTitle.backgroundColor=[UIColor clearColor];
    [self.view addSubview:lblTitle];
    
    UIButton *btnBack=[UIButton buttonWithType:UIButtonTypeCustom];
    //[btnBack setTitle:@"Cancel" forState:UIControlStateNormal];
    UIImage *buttonImage=[UIImage imageNamed:@"backIcon6.png"];
    [btnBack setImage:buttonImage forState:UIControlStateNormal];//@"buttonGreen.png"
    btnBack.frame=CGRectMake(15, (ZL_HEADVIEW_HEIGHT-20-buttonImage.size.height)/2+20, buttonImage.size.width, buttonImage.size.height);
    [self.view addSubview:btnBack];
    [btnBack addTarget:self action:@selector(onTapBackButton) forControlEvents:UIControlEventTouchUpInside];
    
    mActivityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    mActivityView.center=CGPointMake(self.view.frame.size.width-25, 20+(ZL_HEADVIEW_HEIGHT-20)/2);
    [self.view addSubview:mActivityView];
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
    [mCollectionView registerClass:[ZLStoreProductCell class] forCellWithReuseIdentifier:@"stoerproductcell"];
    mCollectionView.delegate=self;
    ///mCollectionView.separatorStyle=UITableViewCellSeparatorStyleNone;
    mCollectionView.dataSource=self;
    [self.view addSubview:mCollectionView];
}

-(void)showEmptyView
{
    
}

-(void)onTapBackButton
{
    PLAY_TAP_BUTTON_AUDIO;
    [(ZLAppDelegate *)([UIApplication sharedApplication].delegate) cancelRequestProductAction];
    //[self dismissViewControllerAnimated:YES completion:NULL];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onReceiveProducts:(NSNotification *)notify
{
    [mActivityView stopAnimating];
    NSDictionary *data=[notify userInfo];
    if (data) {
        NSArray *array=[data objectForKey:@"products"];
        if (array&&[array isKindOfClass:[NSArray class]]) {
            [mProductArray removeAllObjects];
            [mProductArray addObjectsFromArray:array];
            [mCollectionView reloadData];
        }else{
            ZLAlertView *alertView=[[ZLAlertView alloc] initWithMessage:NSLocalizedString(@"Request Error, please try again.",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) confirmButtonTitles:nil];
            [alertView show];
        }
    }
}

#pragma mark - ZLAlertViewDelegate
- (void)alertView:(ZLAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    PLAY_TAP_BUTTON_AUDIO;
    if (alertView.tag==10000) {
        if (buttonIndex==[alertView cancelButtonIndex]) {
            
        }else{
            if (currentBuyingIndex>=0&&currentBuyingIndex<[mProductArray count]&&buyCount) {
                [(ZLAppDelegate *)([UIApplication sharedApplication].delegate) purchaseProduct:[mProductArray objectAtIndex:currentBuyingIndex] count:buyCount];
            }
        }
    }
}

#pragma mark - ZLProductCellDelegate

-(void)onTapBuyOneOfCell:(ZLStoreProductCell *)cell
{
    PLAY_TAP_BUTTON_AUDIO;
    int index=(int)cell.tag-100;
    currentBuyingIndex=index;
    buyCount=cell.buyCount;
    if (currentBuyingIndex>=0&&currentBuyingIndex<[mProductArray count]&&buyCount) {
        [(ZLAppDelegate *)([UIApplication sharedApplication].delegate) purchaseProduct:[mProductArray objectAtIndex:currentBuyingIndex] count:buyCount];
    }
    /*
    ZLAlertView *alertView=[[ZLAlertView alloc] initWithMessage:[NSString stringWithFormat:NSLocalizedString(@"Are you sure to buy %d %@?",nil),buyCount,cell.productObject.localizedTitle] delegate:self cancelButtonTitle:NSLocalizedString(@"NO",nil) confirmButtonTitles:NSLocalizedString(@"YES",nil)];
    alertView.tag=10000;
    [alertView show];
     */
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
    static NSString *identify = @"stoerproductcell";
    ZLStoreProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
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
    //UIEdgeInsets top = {5,10,15,5}; CGFloat top, left, bottom, right;
    UIEdgeInsets top = {10,5,10,4};
    return top;
}

//设置顶部的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={0,0};
    return size;
}

//设置元素大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(150,200);
    //return CGSizeMake(self.view.frame.size.width-2*ZL_TABLEVIEW_LEFTMARGIN,ZL_PRODUCT_CELL_HEIGHT);
}

@end
