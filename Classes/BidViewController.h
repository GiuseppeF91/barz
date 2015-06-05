//
//  BidViewController.h
//  bazr
//
//  Created by Jiang on 3/23/15.
//  Copyright (c) 2015 KZ. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "StarRatingView.h"
#import <Parse/Parse.h>

#import "DateTools.h"
#import "NSDate+DateTools.h"

@interface BidViewController : UIViewController<MKMapViewDelegate>
{
    BOOL keyboardIsShown;
    PFUser* poster;
}
@property (nonatomic, retain) IBOutlet UISlider* bidSlider;

@property (weak, nonatomic) IBOutlet UILabel *bidpriceLabel;

@property (nonatomic, retain) IBOutlet PFImageView* profileImage;


@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet  MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UILabel *postedLabel;

@property (weak, nonatomic) IBOutlet UILabel *performedLabel;

@property (weak, nonatomic) IBOutlet UILabel *starLabel;

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) StarRatingView* starViewNoLabel;
@property (nonatomic, retain) IBOutlet UITextView* nottextView;

@property (weak, nonatomic) IBOutlet UILabel *yourpriceLabel;
@property (nonatomic, retain) IBOutlet UIView* bidedbottomView;



@property (nonatomic, retain) IBOutlet UIView* UserInfoView;
@property (nonatomic, retain) IBOutlet UIView* bottomView;

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;



@property (nonatomic, retain) PFObject* jobObject;

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, weak) NSString *meString;
@property (nonatomic, weak) NSDate *myDate;

@property (nonatomic, retain) StarRatingView *    starRateView;

@end
