
#import <UIKit/UIKit.h>
#import "GroupView.h"
#import "PrivateView.h"
#import "MessagesView.h"
#import "ProfileView.h"
#import "PostView.h"
#import "FAKFontAwesome.h"
#import "FAKFoundationIcons.h"
#import "FAKZocial.h"
#import "FAKIonIcons.h"

#import "NavigationController.h"

#import "JASidePanelController.h"
#import "RightMenuViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "SVProgressHUD.h"

#import "UserReview.h"



//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, CLLocationManagerDelegate>
{
    NavigationController *navCenter;
}
//-------------------------------------------------------------------------------------------------------------------------------------------------
@property (strong, nonatomic) NSArray* categoryArray;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) NSString* searchText;
@property (strong, nonatomic) GroupView *groupView;
@property (strong, nonatomic) PrivateView *privateView;
@property (strong, nonatomic) MessagesView *messagesView;
@property (strong, nonatomic) ProfileView *profileView;
@property (strong, nonatomic) PostView *postView;
@property (strong, nonatomic) JASidePanelController *sideviewController;


@property (nonatomic, retain) CLLocationManager *locationManager;

@property (nonatomic, retain) CLLocation *currentLocation;


@property (nonatomic, retain) NSMutableDictionary* categoryDic;

@property (nonatomic, retain) NSMutableDictionary* categoryDicForSearch;

-(UserReview*) getUserReview:(PFUser*) user client:(BOOL)client;

@end
