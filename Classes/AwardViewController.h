//
//  AwardViewController.h
//  bazr
//
//  Created by Jiang on 3/23/15.
//  Copyright (c) 2015 KZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "AppConstant.h"
#import "SVProgressHUD.h"
#import "StarRatingView.h"

@interface AwardViewController : UIViewController

{
    PFUser* bider;
    int currentIndex;
}

@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblBidCount;

@property (weak, nonatomic) IBOutlet UILabel *lblReviews;

@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UIView *viewGesture;


@property (weak, nonatomic) IBOutlet UILabel *lbldescription;

@property (weak, nonatomic) IBOutlet UIButton *btnReject;

@property (weak, nonatomic) IBOutlet UIButton *btnAward;


@property (weak, nonatomic) IBOutlet PFImageView *imgProfile;

@property (nonatomic, retain) PFObject * jobObject;


@property (nonatomic, retain) NSMutableArray * biderArray;


@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;


@property (nonatomic, retain) StarRatingView *    starRateView;

@end
