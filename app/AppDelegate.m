
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "AppConstant.h"
#import "utilities.h"
#import "AppDelegate.h"
#import "GroupView.h"

#import "PrivateView.h"
#import "MessagesView.h"
#import "ProfileView.h"
#import "PostView.h"
#import "FontAwesomeKit.h"
#import "WelcomeView.h"
#import "CenterView.h"
@implementation AppDelegate
@synthesize sideviewController;
//-------------------------------------------------------------------------------------------------------------------------------------------------
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    
    [Parse setApplicationId:@"xNdQFsbz5yM3CGrg17zZJBIfZAqzX60Jo46qAGb9" clientKey:@"5ilkTjGLHPbovOauelVw0SRuUvyx5Gumlw0grmFU"];

    //---------------------------------------------------------------------------------------------------------------------------------------------
    [PFFacebookUtils initializeFacebook];
    //----------------------------------------------------------------------------------------------------------
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager startUpdatingLocation];

    
    self.categoryDic = [NSMutableDictionary dictionary];
    self.categoryDicForSearch = [NSMutableDictionary dictionary];
    //init categorydicForsearch to "All"
    [self.categoryDicForSearch setObject:@"All" forKey:@"All"];
    [self loadCategory];
    
    
    
	if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
	{
		UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
		UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
		[application registerUserNotificationSettings:settings];
		[application registerForRemoteNotifications];
	}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[PFImageView class];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
 


    self.groupView = [[UIStoryboard storyboardWithName:@"GroupView" bundle:nil] instantiateViewControllerWithIdentifier:@"GroupView"];
    self.privateView = [[PrivateView alloc] init];
    self.messagesView = [[MessagesView alloc] init];
    self.profileView = [[ProfileView alloc] init];
    
    
    NavigationController *navController1 = [[NavigationController alloc] initWithRootViewController:self.groupView];
    NavigationController *navController2 = [[NavigationController alloc] initWithRootViewController:self.privateView];
    NavigationController *navController3 = [[NavigationController alloc] initWithRootViewController:self.messagesView];
    NavigationController *navController4 = [[NavigationController alloc] initWithRootViewController:self.profileView];
    navCenter = [[NavigationController alloc] initWithRootViewController:[[CenterView alloc]init]];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:navController1, navController2, navCenter, navController3, navController4, nil];
    
//	self.tabBarController.viewControllers = [NSArray arrayWithObjects:navController1, navController2, navController5, navController3, navController4, nil];
    self.tabBarController.tabBar.translucent = NO;
    self.tabBarController.selectedIndex = 4;
    self.tabBarController.delegate = self;
    

    
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"TabBarBG"]];

    
    // set the text color for selected state
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    // set the text color for unselected state
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    // set the selected icon color
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    
    // remove the shadow
    [[UITabBar appearance] setShadowImage:nil];
    
    // Set the dark color to selected tab (the dimmed background)
    
    CGFloat tabWidth = self.window.frame.size.width / self.tabBarController.viewControllers.count;
    [[UITabBar appearance] setSelectionIndicatorImage:[AppDelegate imageFromColor:[UIColor colorWithRed:19/255.0 green:19/255.0 blue:19/255.0 alpha:0.8] forSize:CGSizeMake(tabWidth, 49) withCornerRadius:0]];
    
    
   
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];

    return YES;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)applicationWillResignActive:(UIApplication *)application
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)applicationDidEnterBackground:(UIApplication *)application
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    
    
	
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)applicationWillEnterForeground:(UIApplication *)application
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)applicationDidBecomeActive:(UIApplication *)application
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)applicationWillTerminate:(UIApplication *)application
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	
}

#pragma mark - Facebook responses

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session]];
}

#pragma mark - Push notification methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	PFInstallation *currentInstallation = [PFInstallation currentInstallation];
	[currentInstallation setDeviceTokenFromData:deviceToken];
	[currentInstallation saveInBackground];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSLog(@"didFailToRegisterForRemoteNotificationsWithError %@", error);
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self performSelector:@selector(refreshMessagesView) withObject:nil afterDelay:4.0];
	
   
    
    
    if ( application.applicationState == UIApplicationStateActive )
    {
        self.tabBarController.selectedIndex = 4;
    }else
    {
        
    }
    
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)refreshMessagesView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self.messagesView loadMessages];
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (viewController == navCenter) {
        [self clickNewPost];
        return NO;
    }else
        return YES;
}




-(void)clickNewPost
{
    self.postView = [[PostView alloc] init];
    
    
    sideviewController = [[JASidePanelController alloc] init];
    sideviewController.shouldDelegateAutorotateToVisiblePanel = NO;
    
    RightMenuViewController* rightMenuController = [[RightMenuViewController alloc]initWithNibName:@"RightMenuViewController" bundle:nil];
    rightMenuController.categoryArray = [NSMutableArray arrayWithArray:self.categoryArray];
    rightMenuController.delegate = self.postView;
    
    sideviewController.rightPanel = rightMenuController;
    sideviewController.centerPanel  = self.postView;
    
    [self.tabBarController presentModalViewController:sideviewController animated:YES];
    
    
}


- (void)loadCategory
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    PFQuery *query = [PFQuery queryWithClassName:PF_CATEGORY_CLASS_NAME];
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    [query setLimit:1000];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         [SVProgressHUD dismiss];
         if (error == nil)
         {
             self.categoryArray = objects;
         }
         
     }];
}


// UIColor into Image
+ (UIImage *)imageFromColor:(UIColor *)color forSize:(CGSize)size withCornerRadius:(CGFloat)radius
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContext(size);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    // Draw your image
    [image drawInRect:rect];
    
    // Get the image, here setting the UIImageView image
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return image;
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    
    
    
    [manager stopUpdatingLocation];
    
    CLLocationCoordinate2D currentusercordinate = newLocation.coordinate;
    
    
    if (self.currentLocation == nil) {
        self.currentLocation =newLocation;
        
        
    }
    
    
    
    
    
    
}

-(UserReview*) getUserReview:(PFUser*) user client:(BOOL)client
{
    if (user == nil)
    {
        return nil;
    }
    
    UserReview* resultReview = [[UserReview alloc]init];
    
    PFQuery *query = [PFQuery queryWithClassName:PF_CHATROOMS_CLASS_NAME];
    [query orderByDescending:@"createdAt"];
    
    [query whereKey:PF_CHATROOMS_COMPLETE equalTo:[NSNumber numberWithBool:true]];
    [query whereKey:PF_CHATROOMS_RATING notEqualTo:nil];
    
    if (client) {
    
        [query whereKey:PF_CHATROOMS_POSTER equalTo:user];
        
    }else
    {
        [query whereKey:PF_CHATROOMS_AWARDED_USER equalTo:user];
        
    }
    
    NSArray *objects = [query findObjects];
    
    if (objects != nil) {
        
    }
    return resultReview;
}
@end
