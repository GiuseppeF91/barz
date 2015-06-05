//
//  BidViewController.m
//  bazr
//
//  Created by Jiang on 3/23/15.
//  Copyright (c) 2015 KZ. All rights reserved.
//

#import "KTMapAnnotation.h"
#import "BidViewController.h"
#import "AppConstant.h"
#import "pushnotification.h"

@interface BidViewController ()

@end

@implementation BidViewController
@synthesize jobObject;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [ self.bidSlider setThumbImage:[UIImage imageNamed:@"clockpin.png"] forState:UIControlStateNormal ];
    
    self.bidSlider.thumbTintColor = [UIColor orangeColor];
    
    
    
    
    self.textLabel.text = jobObject[PF_CHATROOMS_NAME];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //
    //        NSString *stringFromDate = [formatter stringFromDate:chatroom[PF_CHATROOMS_UPDATEDAT]];
    //
    //        cell.dateLabel.text = stringFromDate;
    
    self.myDate = [jobObject updatedAt];
    self.meString = [self.myDate shortTimeAgoSinceNow];
    
    self.dateLabel.text = [NSString stringWithString: self.meString];
    
    
    
    PFGeoPoint* postlocation = jobObject[PF_CHATROOMS_LOCATION];
    
    if (postlocation != nil && APP_DELEGATE.currentLocation != nil) {
        
        CLLocation *locA = [[CLLocation alloc] initWithLatitude:postlocation.latitude longitude:postlocation.longitude];
        
        CLLocation *locB = APP_DELEGATE.currentLocation;
        
        CLLocationDistance distance = [locA distanceFromLocation:locB]* 0.000621371192;
        
        self.distanceLabel.text = [NSString stringWithFormat:@"%.1fmi",distance];
        
        
    }else
    {
        self.distanceLabel.text = @"unknown";
    }
    
    NSString* price = jobObject[PF_CHATROOMS_BUDGET];
    float f_price = [price floatValue];

    if (f_price >= 1000) {
        float f_price1 = [price floatValue]/1000;
        price = [NSString stringWithFormat:@"$ %.2fK",f_price1];
    }else
    {
        if (price == nil) {
            price = @"";
        }else
        {
            price = [NSString stringWithFormat:@"$ %@",price];
            
        }
    }
    self.priceLabel.text = price;
    
    // ----- set min and max price for slide -----
    float minprice = 1;
    float maxprice = 1;
    
    if (f_price >= 1000) {
        
        
        
        minprice = f_price- 50;
        maxprice = f_price + 50;
    }else
    {
        if (price == nil) {
            
            maxprice = 100;
        }else
        {
            
            if (f_price > 50) {
                minprice = f_price-50;
                maxprice = f_price + 50;
            }else
            {
                minprice = 1;
                maxprice = f_price + 50;
            }
        }
    }
    
    [self.bidSlider setMinimumValue:minprice];
    [self.bidSlider setMaximumValue:maxprice];
    [self.bidSlider setValue:minprice];
    self.bidpriceLabel.text = [NSString stringWithFormat:@"$%.0f", self.bidSlider.value];
    //----- end -----
    
    //
    
    
    NSDate * postdate = [NSDate date];
    NSDate * expiredate = jobObject[PF_CHATROOMS_EXPIREDATE];
    
    if (expiredate == nil)
    {
        self.countdownLabel.text = @"";
        self.countdownLabel.backgroundColor = [UIColor colorWithRed:201.0f/255.0f green:134.0f/255.0f blue:126.0f/255.0f alpha:1];
    }else
    {
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
        
        NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit
                                                   fromDate:postdate
                                                     toDate:expiredate
                                                    options:0];
        
        
        if (components.minute < 0 || components.hour < 0) {
            self.countdownLabel.text = @"Expired";
            self.countdownLabel.backgroundColor = [UIColor colorWithRed:201.0f/255.0f green:134.0f/255.0f blue:126.0f/255.0f alpha:1];
        }else{
            
            if (components.day > 0) {
                self.countdownLabel.text = [NSString stringWithFormat:@"  %i Days", components.day];
                self.countdownLabel.backgroundColor = [UIColor blackColor];
                
            }else{
                
                self.countdownLabel.text = [NSString stringWithFormat:@"  %i:%i", components.hour, components.minute];
                
                self.countdownLabel.backgroundColor = [UIColor colorWithRed:201.0f/255.0f green:134.0f/255.0f blue:126.0f/255.0f alpha:1];
                
            }
        }
    }
    
    
    NSArray* categoryarray = jobObject[PF_CHATROOMS_CATEGORY];
    
    if (categoryarray != nil) {
        
        if (categoryarray.count == 1) {
            
            self.jobLabel.text = [categoryarray objectAtIndex:0];
        }else
        {
            
            self.jobLabel.text = [NSString stringWithFormat:@"x %d", categoryarray.count];
        }
    }else
    {
        self.jobLabel.text = @"";
    }

    
    self.descriptionLabel.text = jobObject[PF_CHATROOMS_DESCRIPTION];
    [self.descriptionLabel sizeToFit];
    
    CGRect frameofUserInfo = self.UserInfoView.frame;
    frameofUserInfo.origin.y = self.descriptionLabel.frame.origin.y + self.descriptionLabel.frame.size.height+10;
    self.UserInfoView.frame = frameofUserInfo;
    
    self.scrollView.contentSize = CGSizeMake( frameofUserInfo.size.width, frameofUserInfo.origin.y + frameofUserInfo.size.height);
    
    
    PFUser *posterId = jobObject[PF_CHATROOMS_POSTER];
    
    if (posterId != nil) {
        
        
        PFQuery *query = [PFUser query];
        [query whereKey:PF_USER_OBJECTID equalTo:posterId.objectId];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
             
             if (error == nil)
             {
                 if ([objects count] != 0)
                 {
                     poster = [objects firstObject];
                     [self.profileImage setFile:poster[PF_USER_PICTURE]];
                     [self.profileImage loadInBackground];
                     
                     
                     PFQuery *query = [PFQuery queryWithClassName:PF_CHATROOMS_CLASS_NAME];
                     [query orderByDescending:@"createdAt"];
                     //    [query whereKey:PF_CHATROOMS_EXPIREDATE greaterThan:[NSDate date]];
                     
                     [query whereKey:PF_CHATROOMS_POSTER equalTo:poster];
                     
                     [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
                      {
                          if (error == nil)
                          {
                              self.postedLabel.text = [NSString stringWithFormat:@"%d posted / ", objects.count];
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
                              self.performedLabel.text = [NSString stringWithFormat:@"%d performed", countofaward];
                              if (countofrating != 0)
                              {
                                  averagerating = sumofrating / countofrating;
                              }
                              
                              CGRect frameofStar = self.starLabel.frame;
                              
                              self.starRateView = [[StarRatingView alloc]initWithFrame:CGRectMake(frameofStar.origin.x, frameofStar.origin.y, kStarViewWidth+kLeftPadding, kStarViewHeight) andRating:averagerating withLabel:NO animated:YES];
                              [self.UserInfoView addSubview:self.starRateView];

                              self.starRateView.editable = false;
                              
                              
                              

                          }
                      }];
                     
                      

                 }
             }
         }];
        
         
    }else
    {
        self.profileImage.image = [UIImage imageNamed:@"blank_profile"];
    }
   
    
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    self.profileImage.layer.masksToBounds = YES;
    
    

    
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    keyboardIsShown = NO;
    
    
    
    UITapGestureRecognizer *hideTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboardTap)];
    [self.bottomView addGestureRecognizer:hideTap];
    
    //
    //hide bottom view when job is posted current user. For see Origenal job
    if ([posterId.objectId isEqualToString:[PFUser currentUser].objectId]) {
        self.bottomView.hidden = YES;
        self.bidedbottomView.hidden = YES;
        [self.scrollView setFrame:[UIScreen mainScreen].bounds];
    }else{
        
        
        
        //check this job is already bid or not
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        
        [self.bottomView setHidden:YES];
        [self.bidedbottomView setHidden:YES];
        
        PFQuery *query = [PFQuery queryWithClassName:PF_BIDLIST_CLASS_NAME];
        [query orderByDescending:@"createdAt"];
        
        
        [query whereKey:PF_BIDLIST_JOBID equalTo:self.jobObject];
        
        [query whereKey:PF_BIDLIST_BIDDER equalTo:[PFUser currentUser]];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
             
             if (error == nil)
             {
                 if (objects.count > 0 ) {
                     
                     [self.bottomView setHidden:YES];
                     [self.bidedbottomView setHidden:NO];
                     
                     PFObject* yourbid = [objects objectAtIndex:0];
                     
                     self.yourpriceLabel.text = [NSString stringWithFormat:@"Your price is %@", yourbid[PF_BIDLIST_PRICE] ];
                     
                     
                 }else
                 {
                     [self.bottomView setHidden:NO];
                     [self.bidedbottomView setHidden:YES];
                 }
                 
                 
                 [SVProgressHUD dismiss];
                 
             }
             else [SVProgressHUD showErrorWithStatus:@"Network error."];
         }];

        
    
    }
    // Do any additional setup after loading the view from its nib.
    
    
    //map point
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(APP_DELEGATE.currentLocation.coordinate,100000, 100000) animated:YES];
    
    [self loadAllProduct];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)hideKeyboardTap
{
    [self.view endEditing:true];
}

- (void)keyboardWillHide:(NSNotification *)n
{
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    // resize the scrollview
    CGRect viewFrame = self.bottomView.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrame.origin.y += (keyboardSize.height - kTabBarHeight);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.bottomView setFrame:viewFrame];
    [UIView commitAnimations];
    
    
    
    keyboardIsShown = NO;
}


- (void)keyboardWillShow:(NSNotification *)n
{
    // This is an ivar I'm using to ensure that we do not do the frame size adjustment on the `UIScrollView` if the keyboard is already shown.  This can happen if the user, after fixing editing a `UITextField`, scrolls the resized `UIScrollView` to another `UITextField` and attempts to edit the next `UITextField`.  If we were to resize the `UIScrollView` again, it would be disastrous.  NOTE: The keyboard notification will fire even when the keyboard is already shown.
    if (keyboardIsShown) {
        return;
    }
    
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // resize the noteView
    CGRect viewFrame = self.bottomView.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrame.origin.y -= (keyboardSize.height - kTabBarHeight);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.bottomView setFrame:viewFrame];
    [UIView commitAnimations];
    
    
    
    keyboardIsShown = YES;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:true];
}

-(IBAction)clickBidNow:(id)sender
{
    if ([self.nottextView.text isEqualToString:@""]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please type your  Proposal" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        return;
    }
    
    PFObject* bidObject = [PFObject objectWithClassName:PF_BIDLIST_CLASS_NAME];
    
    bidObject[PF_BIDLIST_POSTER] = poster;
    bidObject[PF_BIDLIST_DESCRIPTION] = self.nottextView.text;
    bidObject[PF_BIDLIST_JOBID] = self.jobObject;
    bidObject[PF_BIDLIST_BIDDER] = [PFUser currentUser];
    bidObject[PF_BIDLIST_PRICE] = [NSNumber numberWithFloat:self.bidSlider.value];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [bidObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (error == nil)
         {
             [SVProgressHUD dismiss];
             UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"Success!" message:@"Your bid is submited successfully " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
             
             [alertView show];
             
             [self.navigationController popViewControllerAnimated:YES];
             
         }
         else [SVProgressHUD showErrorWithStatus:@"Network error."];
     }];
    //send push notification to client
    SendPushNotificationBadge([NSString stringWithFormat:@"%@ bid your project", [PFUser currentUser][PF_USER_FULLNAME]], poster.objectId);
    
    [self.view endEditing:true];
}

/**
 *  Connecting the Slider value changed event for bid price.
 *
 *
 */

- (IBAction)sliderValueChanged:(id)sender
{
    // Set the label text to the value of the slider as it changes
    self.bidSlider.value = roundf(self.bidSlider.value);
    
    self.bidpriceLabel.text = [NSString stringWithFormat:@"$%.0f", self.bidSlider.value];
}


#pragma mapview delegate

// 03 - Become a MKMapViewDelegate
- (MKAnnotationView *) mapView:(MKMapView *) mapView viewForAnnotation: (id) annotation
{
    
    // 13 - Working with Multiple Points
    MKAnnotationView *customAnnotationView;
    if ([annotation isKindOfClass:[KTMapAnnotation class]] ){
        KTMapAnnotation *theAnnotation = (KTMapAnnotation*)annotation;
        
        customAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:theAnnotation reuseIdentifier:nil];
        
        
        
        
    }else{
        return nil;
    }
    
    return customAnnotationView;
}

// 07 - Do Something when Dropped
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding)
    {
        NSLog(@"Do something when annotation is dropped");
        
        
        
        
        
    }
}



// 09 - Auto Display Callout
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    
}

// 12a - Do Something when Tapped
- (void)mapView:(MKMapView *) mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
    KTMapAnnotation* lastAnnotation = [[self.mapView selectedAnnotations]  objectAtIndex:0];
    
  
    
}



- (void) loadAllProduct
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    
    //
        
        double pointTwoLatitude = APP_DELEGATE.currentLocation.coordinate.latitude;
        double pointTwoLongitude = APP_DELEGATE.currentLocation.coordinate.longitude;
        
        
        CLLocationCoordinate2D pointTwoCoordinate =
        {pointTwoLatitude, pointTwoLongitude};
        KTMapAnnotation *jobAnnotation =
        [[KTMapAnnotation alloc] initWithCoordinate:pointTwoCoordinate];
        
        
        
        jobAnnotation.sttitle = @"Current location";
    
        [jobAnnotation setTypeOfAnnotation:PIN_RED];
        
        [self.mapView addAnnotation:jobAnnotation];
        
    
    
    PFGeoPoint* postlocation = self.jobObject[PF_CHATROOMS_LOCATION];
    //
    
    pointTwoLatitude = postlocation.latitude;
    pointTwoLongitude = postlocation.longitude;
    
    
    CLLocationCoordinate2D pointTwoCoordinate1 =
    {pointTwoLatitude, pointTwoLongitude};
    jobAnnotation =
    [[KTMapAnnotation alloc] initWithCoordinate:pointTwoCoordinate1];
    
    
    
    jobAnnotation.sttitle = @"job location";
    
    [jobAnnotation setTypeOfAnnotation:PIN_RED];
    
    [self.mapView addAnnotation:jobAnnotation];
    
    
    
}



@end
