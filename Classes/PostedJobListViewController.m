//
//  PostedJobListViewController.m
//  bazr
//
//  Created by Jiang on 3/27/15.
//  Copyright (c) 2015 KZ. All rights reserved.
//

#import "PostedJobListViewController.h"
#import "AwardViewController.h"
#import "ClientWorkingJobViewController.h"

#import "JobItemTableViewCell.h"
@interface PostedJobListViewController ()

@end

@implementation PostedJobListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"JobItemTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"channelcell"];
    
    self.title = @"Microtasks Hired";
    chatrooms = [[NSMutableArray alloc] init];
    
    // Do any additional setup after loading the view from its nib.
    upComing = true;
    
}
-(void) viewWillAppear:(BOOL)animated
{
    [self loadHiredJob];
}
-(void) loadHiredJob
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    PFQuery *query = [PFQuery queryWithClassName:PF_CHATROOMS_CLASS_NAME];
    [query orderByDescending:@"createdAt"];
    //    [query whereKey:PF_CHATROOMS_EXPIREDATE greaterThan:[NSDate date]];
    
    [query whereKey:PF_CHATROOMS_POSTER equalTo:[PFUser currentUser]];
    
    
    
    if (upComing == false) {
        [query whereKey:PF_CHATROOMS_AWARDED equalTo:[NSNumber numberWithBool:true]];
        
    }else
    {
        [query whereKey:PF_CHATROOMS_AWARDED equalTo:[NSNumber numberWithBool:false]];
        
    }
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error == nil)
         {
             [chatrooms removeAllObjects];
             chatrooms = nil;
             chatrooms = [NSMutableArray arrayWithArray:objects];
             
             
             [SVProgressHUD dismiss];
             [self.tableView reloadData];
         }
         else [SVProgressHUD showErrorWithStatus:@"Network error."];
     }];
    
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return chatrooms.count;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    
    static NSString *CellIdentifier = @"channelcell";
    JobItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    PFObject * jobObject = [chatrooms objectAtIndex:indexPath.row];
    
    cell.labelTitle.text = jobObject[PF_CHATROOMS_NAME];
    
    NSDate * currentdate = [NSDate date];
    NSDate * expiredate = jobObject[PF_CHATROOMS_EXPIREDATE];
    NSDate * jobpostdate = jobObject[PF_CHATROOMS_POSTDATE];
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit
                                               fromDate:currentdate
                                                 toDate:expiredate
                                                options:0];
    
    
    if (components.minute < 0 || components.hour < 0) {
        cell.labelDescription.text = @"Expired";
        
    }else{
        
        if (components.day > 0) {
            cell.labelDescription.text = [NSString stringWithFormat:@"  %i Days", components.day];
            
            
        }else{
            
            cell.labelDescription.text = [NSString stringWithFormat:@"  %i:%i", components.hour, components.minute];
            
            
        }
    }
    
    int badgenumber = [jobObject[PF_CHATROOMS_BADGE] intValue];
    if (badgenumber == 0) {
        [cell.labelBadge setHidden:YES];
    }else
    {
        
        cell.labelBadge.text = [NSString stringWithFormat:@"%d",  badgenumber];
        [cell.labelBadge setHidden:NO];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //descrease badge of installation and poster badge
    
    PFObject* jobObject = [chatrooms objectAtIndex:indexPath.row];
    int badgenumber = [jobObject[PF_CHATROOMS_BADGE] intValue];
    
    jobObject[PF_CHATROOMS_BADGE] = [NSNumber numberWithInt:0];
    
    [jobObject saveInBackground];
    
    PFInstallation *installation = [PFInstallation currentInstallation];
    if (installation.badge > badgenumber){
        [installation setBadge:installation.badge - badgenumber];
        
    }else
        [installation setBadge:0];
    
    [installation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        PFInstallation *installation = [PFInstallation currentInstallation];
        if (installation.badge == 0) {
            
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
        }else
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:installation.badge];
        
    }];
    
    
    
    if (upComing == true) {
        AwardViewController* awardVC = [[AwardViewController alloc] initWithNibName:@"AwardViewController" bundle:nil];
        awardVC.hidesBottomBarWhenPushed = YES;
        awardVC.jobObject = jobObject;
        
        [self.navigationController pushViewController:awardVC animated:YES];

        
    }else
    {
        ClientWorkingJobViewController* clientWorkingVC = [[ClientWorkingJobViewController alloc] initWithNibName:@"ClientWorkingJobViewController" bundle:nil];
        clientWorkingVC.hidesBottomBarWhenPushed = YES;
        clientWorkingVC.jobObject = jobObject;
        
        [self.navigationController pushViewController:clientWorkingVC animated:YES];
    }
    
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 68;
}


#pragma segment control

- (IBAction)segmentSwitch:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0) {
        
        
        upComing = true;
        [self loadHiredJob];
    }
    else{
        
        upComing = false;
        [self loadHiredJob];
    }
}

@end
