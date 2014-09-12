#import "BCTabBarController.h"
#import "BCTabBarView.h"
#import "ZLAppDelegate.h"

@interface BCTabBarController ()

@property (nonatomic, readwrite) BOOL visible;

@end


@implementation BCTabBarController
@synthesize viewControllers, selectedViewController, tabBarView, visible;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarView = [[BCTabBarView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
   
	self.view = self.tabBarView;

	UIViewController *tmp = selectedViewController;
	selectedViewController = nil;
	[self setSelectedViewController:tmp];
    [self createPageButton];
    visible=YES;
}

-(void)createPageButton
{
    self.leftPageButton=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonImage=[UIImage imageNamed:@"left2.png"];
    [self.leftPageButton setImage:buttonImage forState:UIControlStateNormal];
    [self.leftPageButton addTarget:self action:@selector(onTapLeftPageButton) forControlEvents:UIControlEventTouchUpInside];
    //self.leftPageButton.frame=CGRectMake(0, (self.view.frame.size.height-buttonImage.size.height)/2, buttonImage.size.width, buttonImage.size.height);
    self.leftPageButton.frame=CGRectMake(0, (self.view.frame.size.height*ZL_SPINNING_YPOSITION-buttonImage.size.height/2), buttonImage.size.width, buttonImage.size.height);
    self.tabBarView.leftPageButton=self.leftPageButton;
    
    self.rightPageButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightPageButton setImage:[UIImage imageNamed:@"right2.png"] forState:UIControlStateNormal];
    [self.rightPageButton addTarget:self action:@selector(onTapRightPageButton) forControlEvents:UIControlEventTouchUpInside];
    self.rightPageButton.frame=CGRectMake((self.view.frame.size.width-buttonImage.size.width), (self.view.frame.size.height*ZL_SPINNING_YPOSITION-buttonImage.size.height/2), buttonImage.size.width, buttonImage.size.height);
    self.tabBarView.rightPageButton=self.rightPageButton;
}

-(void)onTapLeftPageButton
{
    PLAY_TAP_BUTTON_AUDIO;
    NSUInteger index=[self selectedIndex];
    [self setSelectedIndex:index-1];
    self.leftPageButton.enabled=NO;
    self.rightPageButton.enabled=NO;
    [self performSelector:@selector(onReEnablePageButtons) withObject:nil afterDelay:0.5f];
//    UIViewController *vc = [self.viewControllers objectAtIndex:index];
//	if (self.selectedViewController == vc) {
//		if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
//			[(UINavigationController *)self.selectedViewController popToRootViewControllerAnimated:YES];
//		}
//	} else {
//		self.selectedViewController = vc;
//	}
}

-(void)onReEnablePageButtons
{
    self.leftPageButton.enabled=YES;
    self.rightPageButton.enabled=YES;
}

-(void)onTapRightPageButton
{
    PLAY_TAP_BUTTON_AUDIO;
    NSUInteger index=[self selectedIndex];
    [self setSelectedIndex:index+1];
}

/*
- (void)tabBar:(BCTabBar *)aTabBar didSelectTabAtIndex:(NSInteger)index {
	UIViewController *vc = [self.viewControllers objectAtIndex:index];
	if (self.selectedViewController == vc) {
		if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
			[(UINavigationController *)self.selectedViewController popToRootViewControllerAnimated:YES];
		}
	} else {
		self.selectedViewController = vc;
	}
	
}
*/
- (void)setSelectedViewController:(UIViewController *)vc {
	UIViewController *oldVC = selectedViewController;
	if (selectedViewController != vc) {
		selectedViewController = vc;
        if (!self.childViewControllers && visible) {
			[oldVC viewWillDisappear:NO];
			[selectedViewController viewWillAppear:NO];
		}
		//self.tabBarView.contentView = vc.view;
        if (oldVC!=nil) {
            if (self.currentIndex>self.lastIndex) {
                CGRect curFrame=vc.view.frame;
                curFrame.origin.x=self.view.frame.size.width;
                vc.view.frame=curFrame;
                self.tabBarView.contentView = vc.view;
                if (!self.childViewControllers && visible) {
                    [oldVC viewDidDisappear:NO];
                    [selectedViewController viewDidAppear:NO];
                }
                
                [UIView animateWithDuration:0.5 animations:^{
                    CGRect oldFrame=oldVC.view.frame;
                    oldFrame.origin.x=-self.view.frame.size.width;
                    oldVC.view.frame=oldFrame;
                    CGRect curFrame=vc.view.frame;
                    curFrame.origin.x=0;
                    vc.view.frame=curFrame;
                } completion:^(BOOL finished){
                    [oldVC.view removeFromSuperview];
                }];
            }
            else if (self.currentIndex<self.lastIndex) {
                CGRect curFrame=vc.view.frame;
                curFrame.origin.x=-self.view.frame.size.width;
                vc.view.frame=curFrame;
                
                self.tabBarView.contentView = vc.view;
                if (!self.childViewControllers && visible) {
                    [oldVC viewDidDisappear:NO];
                    [selectedViewController viewDidAppear:NO];
                }
                
                [UIView animateWithDuration:0.5 animations:^{
                    CGRect oldFrame=oldVC.view.frame;
                    oldFrame.origin.x=self.view.frame.size.width;
                    oldVC.view.frame=oldFrame;
                    CGRect curFrame=vc.view.frame;
                    curFrame.origin.x=0;
                    vc.view.frame=curFrame;
                } completion:^(BOOL finished){
                    [oldVC.view removeFromSuperview];
                }];
            }
            else{
                self.tabBarView.contentView = vc.view;
                [oldVC.view removeFromSuperview];
                if (!self.childViewControllers && visible) {
                    [oldVC viewDidDisappear:NO];
                    [selectedViewController viewDidAppear:NO];
                }
            }
        }else
        {
            self.tabBarView.contentView = vc.view;
            if (!self.childViewControllers && visible) {
//                [oldVC.view removeFromSuperview];
//                [oldVC viewDidDisappear:NO];
                [selectedViewController viewDidAppear:NO];
            }
        }
        self.lastIndex=self.currentIndex;
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    if (!self.childViewControllers)
        [self.selectedViewController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    
    if (!self.childViewControllers)
        [self.selectedViewController viewDidAppear:animated];
    
	visible = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    
    if (!self.childViewControllers)
        [self.selectedViewController viewWillDisappear:animated];	
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    
    if (![self respondsToSelector:@selector(addChildViewController:)])
        [self.selectedViewController viewDidDisappear:animated];
	visible = NO;
}



- (NSUInteger)selectedIndex {
	return [self.viewControllers indexOfObject:self.selectedViewController];
}

- (void)setSelectedIndex:(NSUInteger)aSelectedIndex {
	if (self.viewControllers.count > aSelectedIndex){
        [UIView beginAnimations:nil context:NULL];
        if (aSelectedIndex==0) {
            self.leftPageButton.hidden=YES;
            self.rightPageButton.hidden=NO;
        }else if(aSelectedIndex==([self.viewControllers count]-1)){
            self.rightPageButton.hidden=YES;
            self.leftPageButton.hidden=NO;
        }else{
            self.leftPageButton.hidden=NO;
            self.rightPageButton.hidden=NO;
        }
        [UIView commitAnimations];
        self.currentIndex=aSelectedIndex;
        self.selectedViewController = [self.viewControllers objectAtIndex:aSelectedIndex];
    }
}

- (void)setViewControllers:(NSArray *)array {
	if (array != viewControllers) {
		viewControllers = array;
	}
	self.lastIndex=1;
	self.selectedIndex = 1;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return [self.selectedViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateFirstHalfOfRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willAnimateFirstHalfOfRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
}

- (void)willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willAnimateSecondHalfOfRotationFromInterfaceOrientation:fromInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self.selectedViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

@end
