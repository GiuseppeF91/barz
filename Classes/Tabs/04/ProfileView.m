//
// Copyright (c) 2014 Related Code - http://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Parse/Parse.h>


#import "AppConstant.h"
#import "camera.h"
#import "pushnotification.h"
#import "utilities.h"

#import "ProfileView.h"
#import "HiredJobListViewController.h"
#import "PostedJobListViewController.h"
#import "ProfileEditViewController.h"
#import "ProfileTableViewCell.h"
#import "WelcomeView.h"
//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface ProfileView()
@property (strong, nonatomic) IBOutlet UIView *viewFooter;

@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (strong, nonatomic) IBOutlet PFImageView *imageUser;
@property (strong, nonatomic) IBOutlet UILabel *lblUsername;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblHistoryPosted;

@property (strong, nonatomic) IBOutlet UILabel *lblHistoryPerformed;



@end
//-------------------------------------------------------------------------------------------------------------------------------------------------

@implementation ProfileView

@synthesize viewHeader, imageUser,viewFooter;


//-------------------------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		[self.tabBarItem setImage:[UIImage imageNamed:@"tab_profile"]];
        self.tabBarItem.title = @"";
        self.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        self.title = nil;

	}
	return self;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidLoad];
	self.title = @"";
    
    UINib *nib = [UINib nibWithNibName:@"ProfileTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"profilecell"];

    
	//---------------------------------------------------------------------------------------------------------------------------------------------
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Log out" style:UIBarButtonItemStylePlain target:self
																			action:@selector(actionLogout)];
	//---------------------------------------------------------------------------------------------------------------------------------------------

    self.stringPosted = @"Microtasks Posted";
    
    self.stringPerformed = @"Microtasks Performed";
    
	//---------------------------------------------------------------------------------------------------------------------------------------------
	self.tableView.tableHeaderView = viewHeader;
    self.tableView.tableFooterView = viewFooter;
    
	self.tableView.separatorInset = UIEdgeInsetsZero;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	imageUser.layer.cornerRadius = imageUser.frame.size.width / 2;
	imageUser.layer.masksToBounds = YES;
    
    self.imageUser.clipsToBounds = YES;
    self.imageUser.layer.borderColor=[[UIColor whiteColor] CGColor];
    self.imageUser.layer.borderWidth=3.0;
    
    
}
-(void) viewWillAppear:(BOOL)animated
{
    
    if ([PFUser currentUser] == nil) {
        
        
        
        WelcomeView * welcomeViewController = [[WelcomeView alloc ] initWithNibName:@"WelcomeView" bundle:nil];
        
        NavigationController* navController = [[NavigationController alloc] initWithRootViewController:welcomeViewController];
        
        
        [self presentModalViewController:navController animated:YES];
        return;
    }
    
    PFQuery *query = [PFQuery queryWithClassName:PF_CHATROOMS_CLASS_NAME];
    [query orderByDescending:@"createdAt"];
    //    [query whereKey:PF_CHATROOMS_EXPIREDATE greaterThan:[NSDate date]];
    
    [query whereKey:PF_CHATROOMS_POSTER equalTo:[PFUser currentUser]];
    
    checkfirst = false;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error == nil)
         {
             int nPosted = objects.count;
            
             totalbadgecount = 0;
             for (PFObject* o in objects) {
                 totalbadgecount += [o[PF_CHATROOMS_BADGE] intValue];
                 
             }
             
             self.lblHistoryPosted.text = [NSString stringWithFormat:@"%d posted /", nPosted];
             self.stringPosted = [NSString stringWithFormat:@"%d Microtasks Posted", nPosted];
             [self.tableView reloadData];
             
             if (checkfirst == true) {
                 PFInstallation *installation = [PFInstallation currentInstallation];
                 
                 if (totalbadgecount + totalworkerbadgecount != installation.badge) {
                     
                     
                     [installation setBadge:totalbadgecount + totalworkerbadgecount];
                     
                     [installation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                         PFInstallation *installation = [PFInstallation currentInstallation];
                         if (installation.badge == 0) {
                             
                             [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                             [[UIApplication sharedApplication] cancelAllLocalNotifications];
                         }else
                             [[UIApplication sharedApplication] setApplicationIconBadgeNumber:installation.badge];
                         
                     }];

                 }
             }else
                 checkfirst = true;
         }
         else [SVProgressHUD showErrorWithStatus:@"Network error."];
     }];
    
    
    ////-------------
    query = [PFQuery queryWithClassName:PF_CHATROOMS_CLASS_NAME];
    [query orderByDescending:@"createdAt"];
    [query whereKey:PF_CHATROOMS_AWARDED equalTo:[NSNumber numberWithBool:true]];
    [query whereKey:PF_CHATROOMS_AWARDED_USER equalTo:[PFUser currentUser]];
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error == nil)
         {
             int nPerformed = objects.count;
             totalworkerbadgecount = 0;
             for (PFObject* o in objects) {
                 totalworkerbadgecount += [o[PF_CHATROOMS_BADGEWORKER] intValue];
                 
             }
             
             
             
             self.lblHistoryPerformed.text = [NSString stringWithFormat:@"%d performed", nPerformed];
             self.stringPerformed = [NSString stringWithFormat:@"%d Microtasks Performed", nPerformed];
             [self.tableView reloadData];
             
             if (checkfirst == true) {
                 PFInstallation *installation = [PFInstallation currentInstallation];
                 
                 if (totalbadgecount + totalworkerbadgecount != installation.badge) {
                     
                     
                     [installation setBadge:totalbadgecount + totalworkerbadgecount];
                     
                     [installation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                         PFInstallation *installation = [PFInstallation currentInstallation];
                         if (installation.badge == 0) {
                             
                             [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                             [[UIApplication sharedApplication] cancelAllLocalNotifications];
                         }else
                             [[UIApplication sharedApplication] setApplicationIconBadgeNumber:installation.badge];
                         
                     }];
                     
                 }
             }else
                 checkfirst = true;
             
             
         }
         else [SVProgressHUD showErrorWithStatus:@"Network error."];
     }];
    
    
    [self updateTabCounter];
    
}
//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidAppear:animated];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if ([PFUser currentUser] != nil)
	{
		[self profileLoad];
	}
	else LoginUser(self);
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)dismissKeyboard
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self.view endEditing:YES];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)profileLoad
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	PFUser *user = [PFUser currentUser];

	[imageUser setFile:user[PF_USER_PICTURE]];
	[imageUser loadInBackground];

	self.lblUsername.text = user[PF_USER_FULLNAME];
    self.lblEmail.text = user.email;
    
}

#pragma mark - User actions

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionLogout
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
											   otherButtonTitles:@"Log out", nil];
	[action showFromTabBar:[[self tabBarController] tabBar]];
}

#pragma mark - UIActionSheetDelegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (buttonIndex != actionSheet.cancelButtonIndex)
	{
		[PFUser logOut];
		ParsePushUserResign();
		PostNotification(NOTIFICATION_USER_LOGGED_OUT);

		imageUser.image = [UIImage imageNamed:@"blank_profile"];
		
        
		LoginUser(self);
	}
}


#pragma mark - Table view data source

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return 1;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return 3;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    
    static NSString *CellIdentifier = @"profilecell";
    ProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    

    
    switch (indexPath.row) {
        case 0:
        {
            cell.labelTitle.text = @"Account Settings";
            cell.labelTitle.textColor = [UIColor lightGrayColor];
            [cell.labelBadge setHidden:YES];
            break;
        }
        case 1:
        {
            cell.labelTitle.text = self.stringPosted;
            cell.labelTitle.textColor = [UIColor lightGrayColor];
            if (totalbadgecount == 0) {
                [cell.labelBadge setHidden:YES];
            }else
            {
                cell.labelBadge.text = [NSString stringWithFormat:@"%d" , totalbadgecount];
                [cell.labelBadge setHidden:NO];
            }
            break;
        }
            
        case 2:
        {
            cell.labelTitle.text = self.stringPerformed;
            cell.labelTitle.textColor = [UIColor lightGrayColor];
            if (totalworkerbadgecount == 0) {
                [cell.labelBadge setHidden:YES];
            }else
            {
                cell.labelBadge.text = [NSString stringWithFormat:@"%d" , totalworkerbadgecount];
                [cell.labelBadge setHidden:NO];
            }
            
            break;
        }
            
        default:
            break;
            
            
    }
    
  
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    switch (indexPath.row) {
        case 0:
        {
            ProfileEditViewController* accountSettingVC = [[ProfileEditViewController alloc] initWithNibName:@"ProfileEditViewController" bundle:nil];
            accountSettingVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:accountSettingVC animated:YES];
            
            
            break;
        }
        case 1:
        {
            PostedJobListViewController* postedlistVC = [[PostedJobListViewController alloc] initWithNibName:@"PostedJobListViewController" bundle:nil];
            postedlistVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:postedlistVC animated:YES];

            
            break;
        }
        case 2:
        {
            HiredJobListViewController* hiredlistVC = [[HiredJobListViewController alloc] initWithNibName:@"HiredJobListViewController" bundle:nil];
            hiredlistVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:hiredlistVC animated:YES];

            break;
        }
        case 3:
        {
            break;
        }
        default:
            break;
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 50;
}
-(IBAction)clickInviteFriends:(id)sender
{
    
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
