
#import <Parse/Parse.h>

#import "AppConstant.h"
#import "messages.h"
#import "utilities.h"
#import "GroupView.h"
#import "ChatView.h"
#import "CSCell.h"
#import "CSStickyHeaderFlowLayout.h"
#import "DateTools.h"
#import "NSDate+DateTools.h"
#import "WelcomeView.h"

#import "BidViewController.h"

#define METERS_TO_FEET  3.2808399
#define METERS_TO_MILES 0.000621371192
#define METERS_CUTOFF   1000
#define FEET_CUTOFF     3281
#define FEET_IN_MILES   5280

@import MapKit;
@import CoreLocation;
@import CoreGraphics;

@interface GroupView() <MKMapViewDelegate, CLLocationManagerDelegate>
{
	NSMutableArray *chatrooms;
}

@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) UINib *headerNib;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *userLocation;
@property (nonatomic, assign) BOOL mapViewIsOpen;
@property (nonatomic, assign) CGRect mapViewFrame;
@property (nonatomic, assign) CGRect resultsTableViewFrame;
@property (nonatomic, weak) UIButton *searchHereButton;
@property (nonatomic, weak) UIButton *userLocationButton;
@property (nonatomic, weak) UIButton *refreshButton;
@property (nonatomic, weak) UIButton *filterButton;
@property (nonatomic, weak) UIView *filterView;
@property (nonatomic, weak) NSString *meString;
@property (nonatomic, weak) NSDate *myDate;
@property (nonatomic, weak) UILabel *dateLabel;

@end

@implementation GroupView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.sections = chatrooms;
        self.headerNib = [UINib nibWithNibName:@"CSParallaxHeader" bundle:nil];
        [self.tabBarItem setImage:[UIImage imageNamed:@"tab_home"]];
        self.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        self.title = nil;
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestAlwaysAuthorization];
    
    self.title = @"";
    chatrooms = [[NSMutableArray alloc] init];
    
    UIButton * leftbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 20)];
    [leftbutton setImage:[UIImage imageNamed:@"jobs.png"] forState:UIControlStateNormal];
    
    [leftbutton addTarget:self action:@selector(actionCategory) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * rightbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 20)];
    [rightbutton setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    
    [rightbutton addTarget:self action:@selector(actionSearch) forControlEvents:UIControlEventTouchUpInside];
    
    

    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    
    
    
    
    CSStickyHeaderFlowLayout *layout = (id)self.collectionViewLayout;
    if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
        layout.parallaxHeaderReferenceSize = CGSizeMake(self.view.frame.size.width, 200);
        layout.itemSize = CGSizeMake(self.view.frame.size.width, layout.itemSize.height);
    }
    [self.collectionView registerNib:self.headerNib
          forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader
                 withReuseIdentifier:@"header"];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"swipedownNotification"
                                               object:nil];
    
    self.collectionView.alwaysBounceVertical = YES;
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self action:@selector(refershControlAction) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    self.collectionView.alwaysBounceVertical = YES;
    
    
    [self refreshData];
    
    
    //set channel for special push notification
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setChannels:[NSArray arrayWithObjects:[PFUser currentUser].objectId, nil]];
    [currentInstallation saveInBackground];
}

-(void)refershControlAction
{
    [refreshControl endRefreshing];
    
    MapViewController* mapview = [[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
    mapview.hidesBottomBarWhenPushed = YES;

    mapview.chatrooms = chatrooms;
    
    [self.navigationController pushViewController:mapview animated:NO];
    
}



-(void)fireTimer{
    timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(timefunc:) userInfo:nil repeats:YES];
}


-(void)timefunc:(NSTimer*)timer{
    [self.collectionView reloadData];
}
-(void) stoptimer
{
    [timer invalidate];
    timer = nil;
}
//- (IBAction)reloadButtonDidPress:(id)sender {
//    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self.collectionView numberOfSections])];
//    //    NSIndexSet(indexesInRange: NSMakeRange(0, self.collectionView.numberOfSections()))
//    [self.collectionView reloadSections:indexSet];
//    
//}

//// From Old File
-(void)viewWillDisappear:(BOOL)animated
{
    [self stoptimer];
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
 
    [self fireTimer];
	if ([PFUser currentUser] != nil)
	{
//		[self refreshTable];
//        [self.collectionView reloadSections:indexSet];
        [self refreshData];
	}
	else LoginUser(self);
    
    
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [chatrooms count];

//    return [self.sections count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
//    return [chatrooms count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CSCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
     //    NSDictionary *obj = self.sections[indexPath.section];
    PFObject *chatroom = chatrooms[indexPath.section];
    cell.textLabel.text = chatroom[PF_CHATROOMS_DESCRIPTION];
    
    cell.entireButton.tag = indexPath.section;
    
    [cell.entireButton addTarget:self action:@selector(clickBidButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //message
    cell.messageButton.tag = indexPath.section;
    
    [cell.messageButton addTarget:self action:@selector(clickMessageButton:) forControlEvents:UIControlEventTouchUpInside];

    ///
    
    [cell.countofBidButton setTitle:[NSString stringWithFormat:@"Bid | %@", chatroom[PF_CHATROOMS_COUNT_BID]] forState:UIControlStateNormal];
    
    
    [cell.countofViewButton setTitle:[NSString stringWithFormat:@"View | %@", chatroom[PF_CHATROOMS_COUNT_VIEW]] forState:UIControlStateNormal];
    
    
    [cell.countofMessageButton setTitle:[NSString stringWithFormat:@"%@", chatroom[PF_CHATROOMS_COUNT_MSG]] forState:UIControlStateNormal];
    
    
    
    cell.selected = YES;
    [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//        NSDictionary *obj = self.sections[indexPath.section];
        CSCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:@"sectionHeader"
                                                                 forIndexPath:indexPath];
//        cell.textLabel.text = [[obj allKeys] firstObject];
        PFObject *chatroom = chatrooms[indexPath.section];
       

        
        
        cell.textLabel.text = chatroom[PF_CHATROOMS_NAME];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//
//        NSString *stringFromDate = [formatter stringFromDate:chatroom[PF_CHATROOMS_UPDATEDAT]];
//        
//        cell.dateLabel.text = stringFromDate;
        
        self.myDate = [chatroom updatedAt];
        self.meString = [self.myDate shortTimeAgoSinceNow];
        
        cell.dateLabel.text = [NSString stringWithString: self.meString];
        cell.selected = YES;
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        
        
        PFGeoPoint* postlocation = chatroom[PF_CHATROOMS_LOCATION];
        
        if (postlocation != nil && APP_DELEGATE.currentLocation != nil) {
            
            CLLocation *locA = [[CLLocation alloc] initWithLatitude:postlocation.latitude longitude:postlocation.longitude];
            
            CLLocation *locB = APP_DELEGATE.currentLocation;
            
            CLLocationDistance distance = [locA distanceFromLocation:locB]* 0.000621371192;
            
            cell.distanceLabel.text = [NSString stringWithFormat:@"%.1fmi",distance];
            
            
        }else
        {
            cell.distanceLabel.text = @"unknown";
        }
        
        NSString* price = chatroom[PF_CHATROOMS_BUDGET];
        float f_price = [price floatValue];
        
        if (f_price >= 1000) {
            float f_price = [price floatValue]/1000;
            price = [NSString stringWithFormat:@"$ %.2fK",f_price];
        }else
        {
            if (price == nil) {
                price = @"";
            }else
            {
                price = [NSString stringWithFormat:@"$ %@",price];
        
            }
        }
        cell.priceLabel.text = price;
        
        NSDate * postdate = [NSDate date];
        NSDate * expiredate = chatroom[PF_CHATROOMS_EXPIREDATE];
        
        if (expiredate == nil)
        {
            cell.countdownLabel.text = @"";
            cell.countdownLabel.backgroundColor = [UIColor colorWithRed:201.0f/255.0f green:134.0f/255.0f blue:126.0f/255.0f alpha:1];
        }else
        {
       
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
        
            NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit
                                                   fromDate:postdate
                                                     toDate:expiredate
                                                    options:0];
        
        
            if (components.minute < 0 || components.hour < 0) {
                cell.countdownLabel.text = @"Expired";
                cell.countdownLabel.backgroundColor = [UIColor colorWithRed:201.0f/255.0f green:134.0f/255.0f blue:126.0f/255.0f alpha:1];
            }else{
                
                if (components.day > 0) {
                    cell.countdownLabel.text = [NSString stringWithFormat:@"  %i Days", components.day];
                    cell.countdownLabel.backgroundColor = [UIColor blackColor];
                    
                }else{
                
                    cell.countdownLabel.text = [NSString stringWithFormat:@"  %i:%i", components.hour, components.minute];
                    
                    cell.countdownLabel.backgroundColor = [UIColor colorWithRed:201.0f/255.0f green:134.0f/255.0f blue:126.0f/255.0f alpha:1];
                    
                }
            }
        }
        
        
        NSArray* categoryarray = chatroom[PF_CHATROOMS_CATEGORY];
        if (categoryarray != nil) {
            
            if (categoryarray.count == 1) {
                
                cell.jobLabel.text = [categoryarray objectAtIndex:0];
            }else
            {
                
                cell.jobLabel.text = [NSString stringWithFormat:@"x %d", categoryarray.count];
            }
        }else
        {
            cell.jobLabel.text = @"";
        }
        
        return cell;
    } else if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
        UICollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                            withReuseIdentifier:@"header"
                                                                                   forIndexPath:indexPath];
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        return cell;
    }
    return nil;
}

//-(void)chatButtonPressed:(CSCell *)csCell {
//    NSLog(@"Button Pressed");
//}


#pragma mark - User actions
// From Old File
//- (void)actionNew
//{
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please enter a title for your post" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
//	alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//	[alert show];
//}
//
- (void)actionPost
{
    UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"New Post" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert2.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [[alert2 textFieldAtIndex:1] setSecureTextEntry:NO];
    [[alert2 textFieldAtIndex:0] setPlaceholder:@"Title"];
    [[alert2 textFieldAtIndex:1] setPlaceholder:@"Description"];
    [alert2 show];
}


#pragma mark - UIAlertViewDelegate
// From Old File
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex != alertView.cancelButtonIndex)
	{
		UITextField *textField = [alertView textFieldAtIndex:0];
        UITextField *textField2 = [alertView textFieldAtIndex:1];
		if ([textField.text isEqualToString:@""] == NO)
		{
			PFObject *object = [PFObject objectWithClassName:PF_CHATROOMS_CLASS_NAME];
			object[PF_CHATROOMS_NAME] = textField.text;
            object[PF_CHATROOMS_DESCRIPTION] = textField2.text;
			[object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
			{
				if (error == nil)
				{
					[self refreshData];
				}
				else [SVProgressHUD showErrorWithStatus:@"Network error."];
			}];
		}
	}
}

// From Old File
- (void)refreshData
{
    
    if ([PFUser currentUser] == nil) {
        
        
        
        WelcomeView * welcomeViewController = [[WelcomeView alloc ] initWithNibName:@"WelcomeView" bundle:nil];
       
        NavigationController* navController = [[NavigationController alloc] initWithRootViewController:welcomeViewController];
        

        [self presentModalViewController:navController animated:YES];
        return;
    }
	[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
	PFQuery *query = [PFQuery queryWithClassName:PF_CHATROOMS_CLASS_NAME];
    [query orderByDescending:@"createdAt"];
    [query whereKey:PF_CHATROOMS_EXPIREDATE greaterThan:[NSDate date]];
    [query whereKey:PF_CHATROOMS_AWARDED equalTo:[NSNumber numberWithBool:false]];
    [query whereKey:PF_CHATROOMS_POSTER notEqualTo:[PFUser currentUser]];
    if (APP_DELEGATE.searchText != nil) {
        //
        [query whereKey:PF_CHATROOMS_NAME containsString:APP_DELEGATE.searchText];
       
    }
    PFGeoPoint* currentGeoPoint = [PFGeoPoint geoPointWithLocation:APP_DELEGATE.currentLocation];
    
    [query whereKey:PF_CHATROOMS_LOCATION nearGeoPoint:currentGeoPoint withinMiles:10];
    NSArray* selectedCategoryArray = [APP_DELEGATE.categoryDicForSearch allKeys];
    
    for (int i = 0 ; i < selectedCategoryArray.count; i++ ) {
        NSString* categorystring = [selectedCategoryArray objectAtIndex:i];
        if ([categorystring isEqualToString:@"All"]) {
            break;
        }else{
            [query whereKey:PF_CHATROOMS_CATEGORY containedIn:selectedCategoryArray];
            break;
        }
        
    }
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
	{
		if (error == nil)
		{
			[chatrooms removeAllObjects];
            chatrooms = nil;
            chatrooms = [NSMutableArray arrayWithArray:objects];
            
            
			[SVProgressHUD dismiss];
			[self.collectionView reloadData];
		}
		else [SVProgressHUD showErrorWithStatus:@"Network error."];
	}];
    [self updateTabCounter];
}



- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
//    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    
    
    
    
   
    
    
}

-(void)clickMessageButton:(id)sender
{
    
    
    UIButton* bidButton = sender;
    
    PFObject *chatroom = chatrooms[bidButton.tag];
    
//    NSLog(@"did SelectItem %d-%d",indexPath.section,indexPath.item);
    NSString *roomId = chatroom.objectId;
    CreateMessageItem([PFUser currentUser], roomId, chatroom[PF_CHATROOMS_NAME]);
    ChatView *chatView = [[ChatView alloc] initWith:roomId];
    chatView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatView animated:YES];

    
    
}
-(void)clickBidButton:(id)sender
{
    
    
    UIButton* bidButton = sender;
    
    
    
    
    PFObject *chatroom = chatrooms[bidButton.tag];
    
    [chatroom incrementKey:PF_CHATROOMS_COUNT_VIEW byAmount:@1];
    [chatroom saveInBackground];
    
    
    BidViewController *bidviewController = [[BidViewController alloc] initWithNibName:@"BidViewController" bundle:nil];
    bidviewController.hidesBottomBarWhenPushed = YES;
    bidviewController.jobObject = chatroom;
    
    [self.navigationController pushViewController:bidviewController animated:YES];

    
    
}
-(void)actionCategory
{
    SelectCategoryViewController* selectcategoryViewController = [[SelectCategoryViewController alloc]initWithNibName:@"SelectCategoryViewController" bundle:nil];
    selectcategoryViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:selectcategoryViewController animated:YES];
}

-(void)actionSearch
{
    SearchViewController* searchViewController = [[SearchViewController alloc]initWithNibName:@"SearchViewController" bundle:nil];
    searchViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchViewController animated:YES];
}

- (void)updateTabCounter
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    PFInstallation *installation = [PFInstallation currentInstallation];
    int badgenumber = installation.badge;
    
    
    UITabBarItem *item = self.tabBarController.tabBar.items[4];
    item.badgeValue = (badgenumber == 0) ? nil : [NSString stringWithFormat:@"%d", badgenumber];
}

@end
