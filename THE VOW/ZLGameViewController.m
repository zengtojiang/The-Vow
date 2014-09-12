//
//  ZLGameViewController.m
//  THE VOW
//
//  Created by libs on 14-4-9.
//  Copyright (c) 2014年 icow. All rights reserved.
//
#ifndef TEST_STOREKIT
#import "ZLGameViewController.h"
#import "ZLMyScene.h"
#import "ZLHistoryManager.h"
#import "ZLAppDelegate.h"
#import "ZLShopViewController.h"

@interface ZLGameViewController ()

@end

#define INITIAL_ROTATE_ALERTVIEW_TAG    1000
#define WIN_ALERTVIEW_TAG               2000
#define LOSE_ALERTVIEW_TAG              3000
#define  MISS_ALERTVIEW_TAG             4000
#define  AUTOMISS_ALERTVIEW_TAG         5000

#define ZL_OPTION_LEFTMARGIN        15
#define ZL_OPTION_LEFTMARGIN2       20

@implementation ZLGameViewController

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
    
//    UIImageView *bgView=[[UIImageView alloc] initWithFrame:self.view.bounds];
//    bgView.image=[UIImage imageNamed:iPhone5?@"bg-568.png":@"bg.png"];
//    [self.view addSubview:bgView];
    
    _initRotation=NO;
	// Configure the view.
    _betChipCount=0;
    _betColorType=ZLColorRed;
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;//YES;
    skView.showsNodeCount = NO;//YES;
    
    // Create and configure the scene.
    SKScene * scene = [ZLMyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    ((ZLAppDelegate *)([UIApplication sharedApplication].delegate)).gameScene=(ZLMyScene *)scene;
    // Present the scene.
    [skView presentScene:scene];
    
    [self registerNotification];
    [self initHeadView];
    [self initPlayButton];
    [self initChipView];
    [self initColorModeView];
    [self initOptionView];

    [self refreshGoldMissStatus];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)startInitRotate
{
    _initRotation=YES;
    [self onTapRun:nil];
}

-(int)getChipValue
{
    if (chipType==ZLChipTypeOne) {
        return 1;
    }else if(chipType==ZLChipTypeFive){
        return 5;
    }else if(chipType==ZLChipTypeFifty){
        return 50;
    }else if(chipType==ZLChipTypeHundred){
        return 100;
    }else if(chipType==ZLChipTypeFiveHundred){
        return 500;
    }
    return 0;
}

-(void)initHeadView
{
    //_headView=[[ZLHeadView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 54)];
    _headView=[[ZLHeadView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, ZL_HEADVIEW_HEIGHT-20)];
    [self.view addSubview:_headView];
    [_headView stretchImage];
}

-(void)initOptionView
{
    _optionViewOpened=NO;
    UIImage *buttonImage=[UIImage imageNamed:@"up.png"];
    mOptionView=[[ZLOptionView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-buttonImage.size.height,self.view.frame.size.width,buttonImage.size.height+60+5)];
    mOptionView.delegate=self;
    [self.view addSubview:mOptionView];
    [mOptionView setOptionButtonImage:buttonImage];
}

-(void)initPlayButton
{
    UIImage *radioImage=[UIImage imageNamed:@"radio2_unselected.png"];
    float topMargin=self.view.frame.size.height-70;
    float buttonHeight=30;
    int  radioImageWidth=buttonHeight;
    UIImage *buttonImage=[UIImage imageNamed:@"playbtn2.png"];
    float buttonWidth=90;
    //float buttonWidth=(self.view.frame.size.width-ZL_OPTION_LEFTMARGIN*4-buttonImage.size.width)/2;
    
    //自动miss
    mBtnAutoMiss=[[HSIconButton alloc] initWithFrame:CGRectMake(ZL_OPTION_LEFTMARGIN2, topMargin, buttonWidth, buttonHeight)];
    mBtnAutoMiss.imvIcon.frame=CGRectMake(0, (buttonHeight-radioImageWidth)/2,radioImageWidth , radioImageWidth);
    [mBtnAutoMiss setNormalImage:radioImage];
    [mBtnAutoMiss setSelectedImage:[UIImage imageNamed:@"radio2_selected.png"]];
    mBtnAutoMiss.lblTitle.frame=CGRectMake(radioImageWidth+7, 0,90, buttonHeight);
    mBtnAutoMiss.lblTitle.font=[UIFont fontWithName:ZL_DEFAULT_FONT_NAME size:ZL_SMALL_FONT_SIZE];
    //mBtnColorRed.lblTitle.backgroundColor=[UIColor redColor];
    mBtnAutoMiss.lblTitle.textColor=[UIColor whiteColor];
    mBtnAutoMiss.lblTitle.adjustsFontSizeToFitWidth=YES;
    mBtnAutoMiss.lblTitle.text=NSLocalizedString(@"Auto miss",nil);
    [mBtnAutoMiss addTarget:self action:@selector(onChangeAutoMissStatus:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:mBtnAutoMiss];
    [mBtnAutoMiss setSelected:[ZLHistoryManager isAutoMiss]];
    
    
    _playButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_playButton setImage:buttonImage forState:UIControlStateNormal];
    //[_playButton setImage:[UIImage imageNamed:@"buttonBlue_disabled.png"] forState:UIControlStateDisabled];
    _playButton.frame=CGRectMake((self.view.frame.size.width-buttonImage.size.width)/2, topMargin-(buttonImage.size.height-buttonHeight)/2, buttonImage.size.width, buttonImage.size.height);
    [self.view addSubview:_playButton];
    [_playButton addTarget:self action:@selector(onTapRun:) forControlEvents:UIControlEventTouchUpInside];
    
    /*
    _playButton=[HSStretchableButton buttonWithType:UIButtonTypeCustom];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"buttonBlue.png"] forState:UIControlStateNormal];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"buttonBlue_disabled.png"] forState:UIControlStateDisabled];
    _playButton.frame=CGRectMake(ZL_OPTION_LEFTMARGIN*2+buttonWidth, topMargin, buttonWidth, buttonHeight);//CGRectMake((self.view.frame.size.width-80)/2, self.view.frame.size.height-60, 80, 30);//CGRectMake((self.view.frame.size.width-80)/2, self.view.frame.size.height-60, 80, 30);
    [_playButton setTitle:NSLocalizedString(@"Start",nil) forState:UIControlStateNormal];
    [_playButton stretchImage];
    _playButton.titleLabel.font=[UIFont fontWithName:ZL_DEFAULT_FONT_NAME size:ZL_SMALL_FONT_SIZE];
    [_playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_playButton setTitleColor:ZL_DISABLE_TEXTCOLOR forState:UIControlStateDisabled];
    [self.view addSubview:_playButton];
    [_playButton addTarget:self action:@selector(onTapRun:) forControlEvents:UIControlEventTouchUpInside];
    */
    //商店
    mBtnShop=[HSStretchableButton buttonWithType:UIButtonTypeCustom];
    [mBtnShop setBackgroundImage:[UIImage imageNamed:@"buttonRed.png"] forState:UIControlStateNormal];
    [mBtnShop setBackgroundImage:[UIImage imageNamed:@"buttonRed_disabled.png"] forState:UIControlStateDisabled];
    mBtnShop.frame=CGRectMake((self.view.frame.size.width-ZL_OPTION_LEFTMARGIN2-60), topMargin, 60, buttonHeight);//CGRectMake((self.view.frame.size.width-80)/2, self.view.frame.size.height-60, 80, 30);
    [mBtnShop setTitle:NSLocalizedString(@"Shop",nil) forState:UIControlStateNormal];
    [mBtnShop stretchImage];
    mBtnShop.titleLabel.font=[UIFont fontWithName:ZL_DEFAULT_FONT_NAME size:ZL_SMALL_FONT_SIZE];
    [mBtnShop setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [mBtnShop setTitleColor:ZL_DISABLE_TEXTCOLOR forState:UIControlStateDisabled];
    [self.view addSubview:mBtnShop];
    [mBtnShop addTarget:self action:@selector(onTapShopping:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)initChipView
{
    float topMargin=self.view.frame.size.height-128;
    float viewheight=35;
//    imvChipIcon=[[UIImageView alloc] initWithFrame:CGRectMake(50, topMargin, viewheight, viewheight)];
//    [self.view addSubview:imvChipIcon];
    
    
    btnChipIcon=[UIButton buttonWithType:UIButtonTypeCustom];
    //[btnChipIcon setImage:[UIImage imageNamed:@"buttonBlue.png"] forState:UIControlStateNormal];
    btnChipIcon.frame=CGRectMake(50, topMargin, viewheight, viewheight);
    [self.view addSubview:btnChipIcon];
    [btnChipIcon addTarget:self action:@selector(onTapOptionUpDownButton:) forControlEvents:UIControlEventTouchUpInside];
    
    lblChipCount=[[UILabel alloc] initWithFrame:CGRectMake(viewheight+50+10, topMargin, 120, viewheight)];
    lblChipCount.backgroundColor=[UIColor clearColor];
    lblChipCount.textAlignment=NSTextAlignmentLeft;
    lblChipCount.font=[UIFont fontWithName:ZL_DEFAULT_FONT_NAME size:ZL_MIDDLE_FONT_SIZE];
    lblChipCount.textColor=[UIColor whiteColor];
    [self.view addSubview:lblChipCount];
    
    stepChips=[[UIStepper alloc] init];
    stepChips.center=CGPointMake(240, topMargin+viewheight/2);
    [self.view addSubview:stepChips];
    [stepChips addTarget:self action:@selector(onChangeStepperValue:) forControlEvents:UIControlEventValueChanged];
}

//颜色
-(void)initColorModeView
{
    UIImage *radioImage=[UIImage imageNamed:@"radio2_unselected.png"];
    //int  radioImageWidth=radioImage.size.width;
    int  buttonHeight=30;
    int  radioImageWidth=buttonHeight;
    float leftMargin=ZL_OPTION_LEFTMARGIN2;
    float topMargin=self.view.frame.size.height-170;
    float buttonWidth=(self.view.frame.size.width-leftMargin*4)/3+5;
    
    mBtnColorRed=[[HSIconButton alloc] initWithFrame:CGRectMake(leftMargin, topMargin, buttonWidth, buttonHeight)];
    mBtnColorRed.imvIcon.frame=CGRectMake(0, (buttonHeight-radioImageWidth)/2,radioImageWidth , radioImageWidth);
    [mBtnColorRed setNormalImage:radioImage];
    [mBtnColorRed setSelectedImage:[UIImage imageNamed:@"radio2_selected.png"]];
    mBtnColorRed.lblTitle.frame=CGRectMake(radioImageWidth+7, 0,90, buttonHeight);
    mBtnColorRed.lblTitle.font=[UIFont fontWithName:ZL_DEFAULT_FONT_NAME size:ZL_SMALL_FONT_SIZE];
    //mBtnColorRed.lblTitle.backgroundColor=[UIColor redColor];
    mBtnColorRed.lblTitle.textColor=HEXCOLOR(0xe20001);
    mBtnColorRed.tag=104;
    mBtnColorRed.lblTitle.adjustsFontSizeToFitWidth=YES;
    mBtnColorRed.lblTitle.text=NSLocalizedString(@"Red",nil);
    [mBtnColorRed addTarget:self action:@selector(onTapEvenOddOption:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:mBtnColorRed];
    
    mBtnColorBlack=[[HSIconButton alloc] initWithFrame:CGRectMake(leftMargin*2+buttonWidth, topMargin, buttonWidth, buttonHeight)];
    //mBtnColorBlack=[[HSIconButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-10, topMargin, buttonWidth, buttonHeight)];
    mBtnColorBlack.imvIcon.frame=CGRectMake(0, (buttonHeight-radioImageWidth)/2,radioImageWidth , radioImageWidth);
    [mBtnColorBlack setNormalImage:radioImage];
    [mBtnColorBlack setSelectedImage:[UIImage imageNamed:@"radio2_selected.png"]];
    mBtnColorBlack.lblTitle.frame=CGRectMake(radioImageWidth+7, 0,90, buttonHeight);
    mBtnColorBlack.lblTitle.font=[UIFont fontWithName:ZL_DEFAULT_FONT_NAME size:ZL_SMALL_FONT_SIZE];
    //mBtnColorBlack.lblTitle.backgroundColor=[UIColor blackColor];
    mBtnColorBlack.lblTitle.textColor=HEXCOLOR(0x000000);
    mBtnColorBlack.tag=105;
    mBtnColorBlack.lblTitle.adjustsFontSizeToFitWidth=YES;
    mBtnColorBlack.lblTitle.text=NSLocalizedString(@"Black",nil);
    [mBtnColorBlack addTarget:self action:@selector(onTapEvenOddOption:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:mBtnColorBlack];
    
    mBtnColorGreen=[[HSIconButton alloc] initWithFrame:CGRectMake(leftMargin*3+2*buttonWidth, topMargin, buttonWidth, buttonHeight)];
    mBtnColorGreen.imvIcon.frame=CGRectMake(0, (buttonHeight-radioImageWidth)/2,radioImageWidth , radioImageWidth);
    [mBtnColorGreen setNormalImage:radioImage];
    [mBtnColorGreen setSelectedImage:[UIImage imageNamed:@"radio2_selected.png"]];
    mBtnColorGreen.lblTitle.frame=CGRectMake(radioImageWidth+7, 0,90, buttonHeight);
    mBtnColorGreen.lblTitle.font=[UIFont fontWithName:ZL_DEFAULT_FONT_NAME size:ZL_SMALL_FONT_SIZE];
    //mBtnColorBlack.lblTitle.backgroundColor=[UIColor blackColor];
    mBtnColorGreen.lblTitle.textColor=HEXCOLOR(0x007b30);
    mBtnColorGreen.tag=106;
    mBtnColorGreen.lblTitle.adjustsFontSizeToFitWidth=YES;
    mBtnColorGreen.lblTitle.text=NSLocalizedString(@"Green",nil);
    [mBtnColorGreen addTarget:self action:@selector(onTapEvenOddOption:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:mBtnColorGreen];
    [self resetEvenOddState];
}

#pragma mark - button actions

-(void)onTapEvenOddOption:(UIButton *)sender
{
    PLAY_TAP_BUTTON_AUDIO;
    int tag=(int)sender.tag;
    if(tag==104){
        _betColorType=ZLColorRed;
    }else if(tag==105){
        _betColorType=ZLColorBlack;
    }else if(tag==106){
        _betColorType=ZLColorGreen;
    }
    [self resetEvenOddState];
}

-(void)onTapRun:(UIButton *)sender
{
    //PLAY_TAP_BUTTON_AUDIO;
    self.view.userInteractionEnabled=NO;
    [(ZLAppDelegate *)([UIApplication sharedApplication].delegate) getMainViewController].leftPageButton.enabled=NO;
    [(ZLAppDelegate *)([UIApplication sharedApplication].delegate) getMainViewController].rightPageButton.enabled=NO;
    sender.enabled=NO;
    mOptionView.userInteractionEnabled=NO;
    [((ZLMyScene *)((SKView *)self.view).scene) startRotate];
}

-(void)onChangeAutoMissStatus:(id)sender
{
    PLAY_TAP_BUTTON_AUDIO;
    [ZLHistoryManager changeAutoMissStatus];
    [mBtnAutoMiss setSelected:[ZLHistoryManager isAutoMiss]];
}

-(void)onTapShopping:(id)sender
{
    PLAY_TAP_BUTTON_AUDIO;
    ZLShopViewController *shopVC=[[ZLShopViewController alloc] init];
    //[self presentViewController:shopVC animated:YES completion:NULL];
    [(UINavigationController *)([UIApplication sharedApplication].keyWindow.rootViewController) pushViewController:shopVC animated:YES];
}

-(void)onChangeStepperValue:(UIStepper *)sender
{
    PLAY_TAP_BUTTON_AUDIO;
    _betChipCount=sender.value;
    [self resetChipLabelText];
}

-(void)resetChipLabelText
{
     lblChipCount.text=[NSString stringWithFormat:@"%d/%d",_betChipCount,_maxChipsCount-_betChipCount];
    float btnMargin=10;
    float totalWidth=btnChipIcon.frame.size.width+stepChips.frame.size.width+2*btnMargin;
    float availabelWidth=self.view.frame.size.width-2*ZL_OPTION_LEFTMARGIN-totalWidth;
    CGRect lblRect=[lblChipCount textRectForBounds:CGRectMake(0, 0, availabelWidth, 20) limitedToNumberOfLines:1];
    totalWidth +=lblRect.size.width;
    float leftMargin=(self.view.frame.size.width-totalWidth)/2;
    CGRect btnFrame=btnChipIcon.frame;
    btnFrame.origin.x=leftMargin;
    btnChipIcon.frame=btnFrame;
    
    CGRect lblFrame=lblChipCount.frame;
    lblFrame.origin.x=btnFrame.origin.x+btnFrame.size.width+btnMargin;
    lblFrame.size.width=lblRect.size.width;
    lblChipCount.frame=lblFrame;
    
    CGRect stepFrame=stepChips.frame;
    stepFrame.origin.x=lblFrame.origin.x+lblFrame.size.width+btnMargin;
    stepChips.frame=stepFrame;
}



#pragma mark - status and parameters
-(void)resetChipParams
{
    chipType=[ZLHistoryManager getChipType];
    _maxChipsCount=[ZLHistoryManager getLastScore]/[self getChipValue];
    if (_betChipCount>=_maxChipsCount) {
        _betChipCount=0;
    }
}

-(void)resetChipStatus
{
    [btnChipIcon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Vector%d.png",(chipType-1)]] forState:UIControlStateNormal];
    // imvChipIcon.image=[UIImage imageNamed:[NSString stringWithFormat:@"Vector%d.png",(chipType-1)]];
    stepChips.maximumValue=_maxChipsCount;
    stepChips.minimumValue=0;
    stepChips.stepValue=1;
    [self resetChipLabelText];
}

-(void)resetButtonState
{
    self.view.userInteractionEnabled=YES;
    [(ZLAppDelegate *)([UIApplication sharedApplication].delegate) getMainViewController].leftPageButton.enabled=YES;
    [(ZLAppDelegate *)([UIApplication sharedApplication].delegate) getMainViewController].rightPageButton.enabled=YES;
    _playButton.enabled=YES;
    mOptionView.userInteractionEnabled=YES;
}

-(void)resetEvenOddState
{
    [mBtnColorRed setSelected:(_betColorType==ZLColorRed)];
    [mBtnColorBlack setSelected:(_betColorType==ZLColorBlack)];
    [mBtnColorGreen setSelected:(_betColorType==ZLColorGreen)];
}

//重新刷新金币等值
-(void)refreshGoldMissStatus
{
    [self resetChipParams];
    [self reloadHeadView];
    [self resetChipStatus];
}

-(void)reloadHeadView
{
    if (_headView) {
        [_headView resetAssets];
    }
}

-(void)refreshGameStatus
{
    [self refreshGoldMissStatus];
    [self resetButtonState];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - ZLAlertViewDelegate
- (void)alertView:(ZLAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int  tagIndex=(int)alertView.tag;
    if (tagIndex==INITIAL_ROTATE_ALERTVIEW_TAG) {
         PLAY_TAP_BUTTON_AUDIO;
        [[NSNotificationCenter defaultCenter] postNotificationName:ZL_REFRESS_GOLDS_NOTIFICATION object:nil];
    }else if(tagIndex==WIN_ALERTVIEW_TAG){
        [(ZLAppDelegate *)([UIApplication sharedApplication].delegate) playAudio:ZLAudioTypeGold];
        int doubleNumber=(_resultType==ZLColorGreen)?36:1;
        int goldCount=(_betChipCount*[self getChipValue]);
        [ZLHistoryManager addNewScore:doubleNumber*goldCount];
        [self refreshGameStatus];
    }else if(tagIndex==LOSE_ALERTVIEW_TAG){
        if (buttonIndex==[alertView cancelButtonIndex]) {
             PLAY_TAP_BUTTON_AUDIO;
            int goldCount=(_betChipCount*[self getChipValue]);
            [ZLHistoryManager reduceScore:goldCount];
            [self refreshGameStatus];
        }else{
            if ([ZLHistoryManager getLastMissCount]) {
                [ZLHistoryManager reduceMissCount];
                [self refreshGameStatus];
                [(ZLAppDelegate *)([UIApplication sharedApplication].delegate) playAudio:ZLAudioTypeMiss];
            }else{
                PLAY_TAP_BUTTON_AUDIO;
                ZLAlertView *alertView=[[ZLAlertView alloc] initWithMessage:NSLocalizedString(@"Sorry, you have none miss.",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) confirmButtonTitles:nil];
                alertView.tag=MISS_ALERTVIEW_TAG;
                [alertView show];
            }
        }
    }else if(tagIndex==MISS_ALERTVIEW_TAG){
        PLAY_TAP_BUTTON_AUDIO;
        int goldCount=(_betChipCount*[self getChipValue]);
        [ZLHistoryManager reduceScore:goldCount];
        [self refreshGameStatus];
    }else if(tagIndex==AUTOMISS_ALERTVIEW_TAG){
        PLAY_TAP_BUTTON_AUDIO;
    }
}
#pragma mark - ZLOptionViewDelegate
-(void)onTapOptionUpDownButton:(ZLOptionView *)optionView1
{
    PLAY_TAP_BUTTON_AUDIO;
    if (!_optionViewOpened) {
        //打开optionview
        _optionViewOpened=YES;
        _playButton.enabled=NO;
        mOptionView.userInteractionEnabled=NO;
        [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGRect originFrame=mOptionView.frame;
            originFrame.origin.y=self.view.frame.size.height-mOptionView.frame.size.height;
            mOptionView.frame=originFrame;
            [mOptionView setOptionButtonImage:[UIImage imageNamed:@"down.png"]];
        } completion:^(BOOL finished){
            mOptionView.userInteractionEnabled=YES;
        }];
        
    }else{
        _optionViewOpened=NO;
        UIImage *buttonImage=[UIImage imageNamed:@"up.png"];
        [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGRect originFrame=mOptionView.frame;
            originFrame.origin.y=self.view.frame.size.height-buttonImage.size.height;
            mOptionView.frame=originFrame;
            [mOptionView setOptionButtonImage:buttonImage];
        } completion:^(BOOL finished){
            [self resetButtonState];
//            [mOptionView removeFromSuperview];
//            mOptionView=nil;
        }];
    }
}

-(void)onOptionViewChangeChipType:(ZL_CHIPS_TYPE)type
{
    PLAY_TAP_BUTTON_AUDIO;
    if (chipType!=type) {
        //如果筹码发生了变化
        [self resetChipParams];
        [self resetChipStatus];
    }
}


#pragma mark - 通知
-(void)registerNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshGoldMissStatus) name:ZL_REFRESS_GOLDS_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onChallengeOver:) name:ZL_CHALLENGE_OVER_NOTIFICATION object:nil];
}


-(void)onChallengeOver:(NSNotification *)notification
{
    NSDictionary *data=[notification userInfo];
    int   betNumber=[[data objectForKey:@"number"] intValue];
    ZLTRACE(@"resultNumber:%d",betNumber);
    if (_initRotation) {
        _initRotation=NO;
        [ZLHistoryManager initialAssets:abs(betNumber)*100];
        ZLAlertView *alertView=[[ZLAlertView alloc] initWithMessage:[NSString stringWithFormat:NSLocalizedString(@"You have got %d initial gold",nil),abs(betNumber)*100] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) confirmButtonTitles:nil];
        alertView.tag=INITIAL_ROTATE_ALERTVIEW_TAG;
        [alertView show];
        [self refreshGameStatus];
    }else{
        if (betNumber==0) {
            _resultType=ZLColorGreen;
        }else if(betNumber<0){
            _resultType=ZLColorBlack;
        }else{
            _resultType=ZLColorRed;
        }
        if (_betChipCount<=0) {
            [self refreshGameStatus];
            return;
        }
        if (_betColorType==_resultType) {
            //猜中
            int doubleNumber=(_resultType==ZLColorGreen)?36:1;
            [(ZLAppDelegate *)([UIApplication sharedApplication].delegate) playAudio:ZLAudioTypeWin];
          //  int goldCount=(_betChipCount*[self getChipValue]);
            //[ZLHistoryManager addNewScore:doubleNumber*goldCount];
            if (doubleNumber>1) {
                ZLAlertView *alertView=[[ZLAlertView alloc] initWithMessage:[NSString stringWithFormat:NSLocalizedString(@"You win %d X %d X %d gold",nil),doubleNumber,_betChipCount,[self getChipValue]] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) confirmButtonTitles:nil];
                alertView.tag=WIN_ALERTVIEW_TAG;
                [alertView show];
            }else{
                ZLAlertView *alertView=[[ZLAlertView alloc] initWithMessage:[NSString stringWithFormat:NSLocalizedString(@"You win %d X %d gold",nil),_betChipCount,[self getChipValue]] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) confirmButtonTitles:nil];
                alertView.tag=WIN_ALERTVIEW_TAG;
                [alertView show];
            }
        }else{
            //猜输了
            if ([ZLHistoryManager getLastMissCount]&&[ZLHistoryManager isAutoMiss]) {
                [ZLHistoryManager reduceMissCount];
                [self refreshGameStatus];
                [(ZLAppDelegate *)([UIApplication sharedApplication].delegate) playAudio:ZLAudioTypeMiss];
                ZLAlertView *alertView=[[ZLAlertView alloc] initWithMessage:[NSString stringWithFormat:NSLocalizedString(@"Miss, save %d X %d gold for you.",nil),_betChipCount,[self getChipValue]] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) confirmButtonTitles:nil];
                alertView.tag=AUTOMISS_ALERTVIEW_TAG;
                [alertView show];
            }else{
                [(ZLAppDelegate *)([UIApplication sharedApplication].delegate) playAudio:ZLAudioTypeLose];
                //            int goldCount=(_betChipCount*[self getChipValue]);
                //            [ZLHistoryManager reduceScore:goldCount];
                ZLAlertView *alertView=[[ZLAlertView alloc] initWithMessage:[NSString stringWithFormat:NSLocalizedString(@"You lose %d X %d gold",nil),_betChipCount,[self getChipValue]] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) confirmButtonTitles:NSLocalizedString(@"Miss",nil)];
                alertView.tag=LOSE_ALERTVIEW_TAG;
                [alertView show];
            }
        }
    }
}

@end

#endif
