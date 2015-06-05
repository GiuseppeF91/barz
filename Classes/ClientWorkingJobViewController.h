//
//  ClientWorkingJobViewController.h
//  bazr
//
//  Created by Jiang on 3/27/15.
//  Copyright (c) 2015 KZ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Parse/Parse.h>
#import "AppConstant.h"
#import "SVProgressHUD.h"
#import "StarRatingView.h"
@interface ClientWorkingJobViewController : UIViewController
@property (nonatomic, retain) StarRatingView *    starRateView;
@property (nonatomic, retain) PFObject *    jobObject;
@property (nonatomic, retain) PFUser *      worker;
@property (nonatomic, retain) IBOutlet  UIButton* btnMarkAsComplete;
@property (nonatomic, retain) IBOutlet  UIButton* btnGiveRate;
@property (nonatomic, retain) IBOutlet  UIView* RateView;

@property (nonatomic, retain) IBOutlet  UIButton* btnDone;




@end
