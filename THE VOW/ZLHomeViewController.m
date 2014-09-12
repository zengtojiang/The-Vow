//
//  ZLHomeViewController.m
//  THE VOW
//
//  Created by libs on 14-4-9.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import "ZLHomeViewController.h"
#import "ZLHistoryManager.h"
#import "ZLAppDelegate.h"

@interface ZLHomeViewController ()

@end

@implementation ZLHomeViewController

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
	// Do any additional setup after loading the view.
    //[self initAssets];
    //[self initTableView];
    
   // [self initNavigationBar];
}

-(void)viewWillAppear:(BOOL)animated
{
    ZLTRACE(@"");
    [super viewWillAppear:animated];
    [self initNavigationBar];
    [self initAssets];
    [self initTableView];
    [self fireReapRefreshTimer];
}

-(void)viewDidDisappear:(BOOL)animated
{
    ZLTRACE(@"");
    [super viewDidDisappear:animated];
    mCollectionView.delegate=nil;
    mCollectionView.dataSource=nil;
    [mCollectionView removeFromSuperview];
    mCollectionView=nil;
    [mAssetsArray removeAllObjects];
    mAssetsArray=nil;
    self.sellingAsset=nil;
    [self stopReapRefreshTimer];
    for (UIView *subView in [self.view subviews]) {
        [subView removeFromSuperview];
    }
}

-(void)reloadAssetsData
{
    [self stopReapRefreshTimer];
    [self initAssets];
    if (mCollectionView) {
        [mCollectionView reloadData];
    }
    [self fireReapRefreshTimer];
}

-(void)initAssets
{
    if (!mAssetsArray) {
        mAssetsArray=[[NSMutableArray alloc] init];
    }
    [mAssetsArray removeAllObjects];
    NSArray *assets=[ZLHistoryManager getAllAssetObjects];
    if (assets) {
        [mAssetsArray addObjectsFromArray:assets];
    }else{
        [self showEmptyView];
    }
}

-(void)initNavigationBar
{
    UIImageView *bgView=[[UIImageView alloc] initWithFrame:self.view.bounds];
    bgView.image=[UIImage imageNamed:iPhone5?@"bg3-568h.png":@"bg3.png"];
    [self.view addSubview:bgView];
   
    HSStretchableImageView *imvHead=[[HSStretchableImageView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, ZL_HEADVIEW_HEIGHT-20)];
    imvHead.image=[UIImage imageNamed:@"skillbg6.png"];//[UIImage imageNamed:@"optionbg3.png"];
    [imvHead stretchImage];
    //imvHead.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbarBlue.png"]];
    [self.view addSubview:imvHead];
    
    UILabel *lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, ZL_HEADVIEW_HEIGHT-20-5)];
    lblTitle.font=[UIFont fontWithName:ZL_DEFAULT_FONT_NAME size:ZL_BIG_FONT_SIZE];
    lblTitle.text=NSLocalizedString(@"Assets Library", nil);
    lblTitle.textColor=ZL_HEADVIEW_TEXTCOLOR;//[UIColor whiteColor];
    lblTitle.textAlignment=NSTextAlignmentCenter;
    lblTitle.backgroundColor=[UIColor clearColor];
    [self.view addSubview:lblTitle];
}

-(void)initTableView
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    //UICollectionViewLayout *collectionViewLayout=
    mCollectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, ZL_HEADVIEW_HEIGHT, self.view.frame.size.width, self.view.frame.size.height-ZL_HEADVIEW_HEIGHT) collectionViewLayout:flowLayout];//[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    mCollectionView.backgroundColor=[UIColor clearColor];
//    UIImageView *bgView=[[UIImageView alloc] initWithFrame:self.view.bounds];
//    bgView.image=[UIImage imageNamed:@"bg.png"];//iPhone5?@"bg-568.png":@"bg.png"
//    mCollectionView.backgroundView=bgView;
    [mCollectionView registerClass:[ZLAssetCell class] forCellWithReuseIdentifier:@"assetcell"];
    mCollectionView.delegate=self;
    ///mCollectionView.separatorStyle=UITableViewCellSeparatorStyleNone;
    mCollectionView.dataSource=self;
    [self.view addSubview:mCollectionView];
    //[self.view sendSubviewToBack:mCollectionView];
}

-(void)showEmptyView
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - timer
-(void)fireReapRefreshTimer
{
    if (mAssetsArray&&[mAssetsArray count]) {
        mRefreshTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                         target:self
                                                       selector:@selector(refreshTimeDuration)
                                                       userInfo:nil
                                                        repeats:YES];
        [mRefreshTimer fire];
    }
}


//每一秒刷新一下定时器
- (void)refreshTimeDuration
{
    if (mCollectionView) {
       NSArray *visibleCells=[mCollectionView visibleCells];
        for (ZLAssetCell *cell in visibleCells) {
            [cell refreshReapTime];
        }
    }
}

-(void)stopReapRefreshTimer
{
    if (mRefreshTimer) {
        [mRefreshTimer invalidate];
        mRefreshTimer=nil;
    }
}


#pragma mark - UICollectionViewDatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [mAssetsArray count];
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
    static NSString *identify = @"assetcell";
    ZLAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    //[cell sizeToFit];
    if (!cell) {
    }
    cell.cellDelegate=self;
    cell.tag=100+indexPath.row;
    [cell setCellData:[mAssetsArray objectAtIndex:indexPath.row]];
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
    return CGSizeMake(self.view.frame.size.width-2*ZL_TABLEVIEW_LEFTMARGIN,ZL_HOME_TABLEVIEW_HEIGHT);
    //return CGSizeMake(240,(kDeviceHeight-kNavHeight*2-kTabBarHeight-20)/4.0);
}

//点击元素触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ZLTRACE(@"section:%d index:%d",indexPath.section,indexPath.row);
    //    DetailVideoViewController *detailVC = [[DetailVideoViewController alloc]init];
    //    [self.navigationController pushViewController:detailVC animated:YES];
    //    [detailVC release];
}

#pragma mark - ZLAssetCellDelegate

-(void)onSellAssetsOfCell:(ZLAssetCell *)cell
{
   PLAY_TAP_BUTTON_AUDIO
    ZLAlertView *alertView=[[ZLAlertView alloc] initWithMessage:[NSString stringWithFormat:NSLocalizedString(@"Are you sure to sell the %@ to get %d gold?",nil),NSLocalizedString(cell.assetObject.assetName,nil),(int)(cell.assetObject.assetValue*ZL_ASSETS_SELL_DISCOUNT)] delegate:self cancelButtonTitle:NSLocalizedString(@"NO",nil) confirmButtonTitles:NSLocalizedString(@"YES",nil)];
    alertView.tag=1000;
    [alertView show];
    self.sellingAsset=cell.assetObject;
}

-(void)onReapAssetsOfCell:(ZLAssetCell *)cell
{
    //[ZLHistoryManager reapAssets:[mAssetsArray objectAtIndex:(cell.tag-100)]];
    PLAY_TAP_BUTTON_AUDIO
    [ZLHistoryManager reapAssets:cell.assetObject];
    ZLAlertView *alertView=[[ZLAlertView alloc] initWithMessage:[NSString stringWithFormat:NSLocalizedString(@"Reap %d gold",nil),cell.assetObject.gold] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) confirmButtonTitles:nil];
    [alertView show];
    [self reloadAssetsData];
    [[NSNotificationCenter defaultCenter] postNotificationName:ZL_REFRESS_GOLDS_NOTIFICATION object:nil];
    //[ZLHistoryManager addNewScore:cell.assetObject.gold];
}

#pragma mark - ZLAlertViewDelegate
- (void)alertView:(ZLAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    PLAY_TAP_BUTTON_AUDIO
    if (alertView.tag==1000) {
        if (buttonIndex==[alertView cancelButtonIndex]) {
            
        }else{
            if ([ZLHistoryManager sellAssets:self.sellingAsset]) {
                [self reloadAssetsData];
                [[NSNotificationCenter defaultCenter] postNotificationName:ZL_REFRESS_GOLDS_NOTIFICATION object:nil];
            }else{
                ZLAlertView *alertView=[[ZLAlertView alloc] initWithMessage:NSLocalizedString(@"Failed to sell it, please try again.",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) confirmButtonTitles:nil];
                [alertView show];
            }
        }
    }
}
@end
