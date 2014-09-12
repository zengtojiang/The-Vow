
@class BCTabBarView;

@interface BCTabBarController : UIViewController

@property (nonatomic, retain) NSArray *viewControllers;
@property (nonatomic, retain) UIViewController *selectedViewController;
@property (nonatomic, retain) BCTabBarView *tabBarView;
@property (nonatomic) NSUInteger selectedIndex;
@property (nonatomic, readonly) BOOL visible;
@property(nonatomic,retain)UIButton *leftPageButton;
@property(nonatomic,retain)UIButton *rightPageButton;

@property(nonatomic,assign)NSUInteger lastIndex;
@property(nonatomic,assign)NSUInteger currentIndex;

@end
