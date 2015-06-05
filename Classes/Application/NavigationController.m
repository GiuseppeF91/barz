

#import "AppConstant.h"

#import "NavigationController.h"

@implementation NavigationController

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidLoad];

	self.navigationBar.barTintColor = HEXCOLOR(0x2C2C2C00);
	self.navigationBar.tintColor = [UIColor whiteColor];
	self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:HEXCOLOR(0xFFFFFF20)};
	self.navigationBar.translucent = NO;
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBar6Bazr"] forBarMetrics:UIBarMetricsDefault];
}

@end
