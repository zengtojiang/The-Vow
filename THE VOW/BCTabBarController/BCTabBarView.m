#import "BCTabBarView.h"

@implementation BCTabBarView
@synthesize contentView,leftPageButton,rightPageButton;


-(void)setLeftPageButton:(UIButton *)aleftPageButton
{
    if (leftPageButton != aleftPageButton) {
        [leftPageButton removeFromSuperview];
        leftPageButton = aleftPageButton;
        [self addSubview:leftPageButton];
    }
}

-(void)setRightPageButton:(UIButton *)arightPageButton
{
    if (rightPageButton != arightPageButton) {
        [rightPageButton removeFromSuperview];
        rightPageButton = arightPageButton;
        [self addSubview:rightPageButton];
    }
}

- (void)setContentView:(UIView *)aContentView {
	//[contentView removeFromSuperview];
	contentView = aContentView;
    //contentView.frame = CGRectMake(0, self.headBar.frame.size.height+self.headBar.frame.origin.y, self.bounds.size.width, self.tabBar.frame.origin.y-(self.headBar.frame.size.height+self.headBar.frame.origin.y));
	//contentView.frame = CGRectMake(0, IOS7_STATUSBAR_DELTA, self.bounds.size.width, self.tabBar.frame.origin.y);
    //contentView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
	[self addSubview:contentView];
	[self sendSubviewToBack:contentView];
}

/*
- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect f = contentView.frame;
    //f.size.height = self.tabBar.frame.origin.y;
	//f.size.height = self.tabBar.frame.origin.y-(self.headBar.frame.size.height+self.headBar.frame.origin.y);
	contentView.frame = f;
	[contentView layoutSubviews];
}
*/
- (void)drawRect:(CGRect)rect {
	CGContextRef c = UIGraphicsGetCurrentContext();
   // [RGBCOLOR(0, 0, 0) set];
    [HEXCOLOR(0x000000) set];
	CGContextFillRect(c, self.bounds);
//	[RGBCOLOR(230, 230, 230) set];
//	CGContextFillRect(c, self.bounds);
}

@end
