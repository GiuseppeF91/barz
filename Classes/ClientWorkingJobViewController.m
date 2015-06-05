//
//  ClientWorkingJobViewController.m
//  bazr
//
//  Created by Jiang on 3/27/15.
//  Copyright (c) 2015 KZ. All rights reserved.
//

#import "ClientWorkingJobViewController.h"
#import "ChatView.h"
#import "messages.h"
#import "utilities.h"
#import "GroupView.h"
#import "BidViewController.h"

@interface ClientWorkingJobViewController ()

@end

@implementation ClientWorkingJobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.btnDone setHidden:YES];
    
    PFUser *posterId = self.jobObject[PF_CHATROOMS_AWARDED_USER];
    if ([self.jobObject[PF_CHATROOMS_COMPLETE] boolValue]) {
        [self.btnMarkAsComplete setTitle:@"Completed" forState:UIControlStateNormal];
        [self.btnMarkAsComplete setUserInteractionEnabled:NO];
        
        
        
    }else
    {
        [self.RateView setHidden:YES];
        
        
    }
    
    if (self.jobObject[PF_CHATROOMS_RATING] == nil) {
        
        [self.btnGiveRate setHidden:NO];
        
        
    }else
    {
        [self.btnGiveRate setHidden:YES];
        CGRect frameofStar = self.btnGiveRate.frame;
        
        int rateMark = [self.jobObject[PF_CHATROOMS_RATING] intValue];
        
        self.starRateView = [[StarRatingView alloc]initWithFrame:CGRectMake(frameofStar.origin.x, frameofStar.origin.y, kStarViewWidth+kLeftPadding, kStarViewHeight) andRating:rateMark withLabel:NO animated:YES];
        [self.RateView addSubview:self.starRateView];
        self.starRateView.editable = NO;
        
        
    }
    
    
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
                     self.worker = [objects firstObject];
                 }
             }
         }];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)clickOriginalpost:(id)sender
{
    BidViewController *bidviewController = [[BidViewController alloc] initWithNibName:@"BidViewController" bundle:nil];
    bidviewController.jobObject = self.jobObject;
    
    [self.navigationController pushViewController:bidviewController animated:YES];

}

-(IBAction)clickCall:(id)sender
{
    if (self.worker == nil) {
        return;
    }
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.worker[PF_USER_PHONENUBER]]];
    
    if ([[UIApplication sharedApplication] canOpenURL:telURL]) {
        [[UIApplication sharedApplication] openURL:telURL];
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"Your device does not support a call!"
                                    message:nil
                                   delegate:nil
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:nil] show];
    }
}

-(IBAction)clickChat:(id)sender
{
    
    NSString *roomId = self.jobObject.objectId;
    CreateMessageItem([PFUser currentUser], roomId, self.jobObject[PF_CHATROOMS_NAME]);
    ChatView *chatView = [[ChatView alloc] initWith:roomId];
    
    [self.navigationController pushViewController:chatView animated:YES];
}

-(IBAction)clickMarkasComplete:(id)sender
{
    self.jobObject[PF_CHATROOMS_COMPLETE] = [NSNumber numberWithBool:YES];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self.jobObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         [SVProgressHUD dismiss];
         
         if (error == nil)
         {
             [self.btnMarkAsComplete setTitle:@"Completed" forState:UIControlStateNormal];
             [self.btnMarkAsComplete setUserInteractionEnabled:NO];
             [self.RateView setHidden:NO];
         }
     }];
    
}

-(IBAction)clickRating:(id)sender
{
    
    [self.btnGiveRate setHidden:YES];
    CGRect frameofStar = self.btnGiveRate.frame;
    
    
    
    self.starRateView = [[StarRatingView alloc]initWithFrame:CGRectMake(frameofStar.origin.x, frameofStar.origin.y, kStarViewWidth+kLeftPadding, kStarViewHeight) andRating:0 withLabel:NO animated:YES];
    [self.RateView addSubview:self.starRateView];
    
    [self.btnDone setHidden:NO];
    
}

-(IBAction)clickDone:(id)sender
{
    self.jobObject[PF_CHATROOMS_RATING] = [NSNumber numberWithInt:self.starRateView.rating];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self.jobObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         
         if (error == nil)
         {
             [self.btnDone setHidden:YES];
             self.starRateView.editable = false;
             [SVProgressHUD showSuccessWithStatus:@"Success!"];
             
         }else
             [SVProgressHUD showSuccessWithStatus:@"Network error!"];
     }];
}
@end
