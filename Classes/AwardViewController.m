//
//  AwardViewController.m
//  bazr
//
//  Created by Jiang on 3/23/15.
//  Copyright (c) 2015 KZ. All rights reserved.
//

#import "AwardViewController.h"
#import "ClientWorkingJobViewController.h"
#import "messages.h"
#import "pushnotification.h"
@interface AwardViewController ()

@end

@implementation AwardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.viewGesture addGestureRecognizer:self.leftSwipeGestureRecognizer];
    [self.viewGesture addGestureRecognizer:self.rightSwipeGestureRecognizer];
    
    
    self.biderArray = [[NSMutableArray alloc]init];
    currentIndex = 0;
    
    [self reloadData];
}
-(void) reloadData
{
    
    [self.viewGesture setHidden:YES];
    
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    PFQuery *query = [PFQuery queryWithClassName:PF_BIDLIST_CLASS_NAME];
    [query orderByDescending:@"createdAt"];
    //    [query whereKey:PF_CHATROOMS_EXPIREDATE greaterThan:[NSDate date]];
    
    [query whereKey:PF_BIDLIST_JOBID equalTo:self.jobObject];
    [query whereKey:PF_BIDLIST_REJECTED notEqualTo:[NSNumber numberWithBool:NO]];
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         
         [SVProgressHUD dismiss];
         
         if (error == nil)
         {
             
             if (objects.count == 0) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     
                     [self.viewGesture setHidden:YES];
                     [self.btnAward setHidden:YES];
                     [self.btnReject setHidden:YES];
                     self.lblBidCount.text = @"";
                     UIAlertView* alertview = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"There is no bidder on your job"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [alertview show];
                     
                 });
                 
             }else
             {
                 [self.biderArray removeAllObjects];
                 self.biderArray = nil;
                 self.biderArray = [NSMutableArray arrayWithArray:objects];
                 
                 [self.viewGesture setHidden:NO];
                 [self.btnAward setHidden:NO];
                 [self.btnReject setHidden:NO];
                 
                 [self displayBidderInfo];
                 
                 
             }
             
         }
         
         
     }];
    
    
    

    
}
-(void)handleSwipes:(UISwipeGestureRecognizer *)recognizer {
    
    if([recognizer direction] == UISwipeGestureRecognizerDirectionLeft){
        //Swipe from right to left
        //Do your functions here
        
        if (currentIndex < self.biderArray.count-1) {
            currentIndex++;
        }else
            return;
        
        
        [self displayBidderInfo];
    }else if([recognizer direction] == UISwipeGestureRecognizerDirectionRight){
        //Swipe from left to right
        //Do your functions here
        
        if (currentIndex > 0) {
            currentIndex--;
        }else
            return;
        
        [self displayBidderInfo];
        
    }
}

-(void)displayBidderInfo
{
    
    self.lblBidCount.text = [NSString stringWithFormat:@"%d of %d" , currentIndex+1, self.biderArray.count];
    
    
    
    
    PFObject* currentBidder = [self.biderArray objectAtIndex:currentIndex];
    
    
    self.lblPrice.text = [NSString stringWithFormat:@"$%.2f", [currentBidder[PF_BIDLIST_PRICE] floatValue] ];
    self.lbldescription.text = currentBidder[PF_BIDLIST_DESCRIPTION];
    [self.lbldescription sizeToFit];
    
    PFUser *posterId = currentBidder[PF_BIDLIST_BIDDER];
    
    if (posterId != nil) {
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        
        PFQuery *query = [PFUser query];
        [query whereKey:PF_USER_OBJECTID equalTo:posterId.objectId];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
             
             
             [SVProgressHUD dismiss];
             
             if (error == nil)
             {
                 if ([objects count] != 0)
                 {
                     bider = [objects firstObject];
                     self.lblUsername.text = bider[PF_USER_FULLNAME];
                     
                     [self.imgProfile setFile:bider[PF_USER_PICTURE]];
                     [self.imgProfile loadInBackground];
                     
                     PFQuery *query = [PFQuery queryWithClassName:PF_CHATROOMS_CLASS_NAME];
                     [query orderByDescending:@"createdAt"];
                     //    [query whereKey:PF_CHATROOMS_EXPIREDATE greaterThan:[NSDate date]];
                     
                     [query whereKey:PF_CHATROOMS_AWARDED_USER equalTo:bider];
                     
                     [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
                      {
                          if (error == nil)
                          {
                              int sumofrating = 0;
                              int countofrating = 0;
                              int averagerating = 0;
                              int countofaward = 0;
                              for (PFObject *o in objects) {
                                  if (o[PF_CHATROOMS_RATING] != nil) {
                                      int tmpRating = [o[PF_CHATROOMS_RATING] intValue];
                                      sumofrating += tmpRating;
                                      countofrating++;
                                      
                                  }
                                  
                                  if ([o[PF_CHATROOMS_AWARDED] boolValue] == true) {
                                      countofaward++;
                                  }
                              }
                              self.lblReviews.text = [NSString stringWithFormat:@"(%d)", countofrating];
                              if (countofrating != 0)
                              {
                                  averagerating = sumofrating / countofrating;
                              }
                              
                              CGRect frameofStar = self.lblReviews.frame;
                              
                              self.starRateView = [[StarRatingView alloc]initWithFrame:CGRectMake(frameofStar.origin.x-kStarViewWidth-kLeftPadding, frameofStar.origin.y, kStarViewWidth+kLeftPadding, kStarViewHeight) andRating:averagerating withLabel:NO animated:YES];
                              [self.viewGesture addSubview:self.starRateView];
                              
                              self.starRateView.editable = false;
                              
                              
                              
                          }
                      }];
                     

                     
                     
                 }
             }
         }];
        
        
    }

    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)clickReject:(id)sender
{
    PFObject* currentBidder = [self.biderArray objectAtIndex:currentIndex];
    
    currentBidder[PF_BIDLIST_REJECTED] = [NSNumber numberWithBool:YES];
    
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [currentBidder saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (error == nil)
         {
             [self reloadData];
         }
     }];
    
}

-(IBAction)clickAward:(id)sender
{
    
    PFObject* currentBidder = [self.biderArray objectAtIndex:currentIndex];
    
    
    
    self.jobObject[PF_CHATROOMS_AWARDED_USER] = currentBidder[PF_BIDLIST_BIDDER];
    self.jobObject[PF_CHATROOMS_AWARDED] = [NSNumber numberWithBool:YES];
    [self.jobObject incrementKey:PF_CHATROOMS_BADGEWORKER byAmount:@1];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self.jobObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         [SVProgressHUD dismiss];
         
         if (error == nil)
         {
             [self.navigationController popViewControllerAnimated:YES];
             
             ClientWorkingJobViewController* clientWorkingVC = [[ClientWorkingJobViewController alloc] initWithNibName:@"ClientWorkingJobViewController" bundle:nil];
             clientWorkingVC.hidesBottomBarWhenPushed = YES;
             clientWorkingVC.jobObject = self.jobObject;
            
             
             [self.navigationController pushViewController:clientWorkingVC animated:YES];

             
         }
     }];
    
    //send push notification to worker
    PFUser *posterId = currentBidder[PF_BIDLIST_BIDDER];
    
    SendPushNotificationBadge([NSString stringWithFormat:@"You awarded new job"], posterId.objectId);
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
