//
//  MapViewController.h
//  Dealo
//
//  Created by admin on 8/14/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import <MessageUI/MessageUI.h>


@interface MapViewController : UIViewController<MKMapViewDelegate>
{
    
    
}

@property(readwrite)BOOL editing;

@property(readwrite)int mode;

@property (retain, nonatomic) PFQuery *productQuery;

@property (retain, nonatomic) IBOutlet MKMapView *myMapView;
@property (retain, nonatomic) NSMutableArray* chatrooms;
@end
