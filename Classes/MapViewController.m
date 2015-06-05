//
//  MapViewController.m
//  Dealo
//
//  Created by admin on 8/14/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "MapViewController.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "KTMapAnnotation.h"
#import "BidViewController.h"

@interface MapViewController ()


@end

@implementation MapViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    
    
//    UIButton * rightbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 20)];
//    [rightbutton setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
//    
//    [rightbutton addTarget:self action:@selector(actionSearch) forControlEvents:UIControlEventTouchUpInside];
//    
//   
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    
    
    [self.myMapView setShowsUserLocation:YES];
    
    
    [self.myMapView setRegion:MKCoordinateRegionMakeWithDistance(APP_DELEGATE.currentLocation.coordinate,100000, 100000) animated:YES];
    
    [self loadAllProduct];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 03 - Become a MKMapViewDelegate
- (MKAnnotationView *) mapView:(MKMapView *) mapView viewForAnnotation: (id) annotation
{
    
    // 13 - Working with Multiple Points
    MKAnnotationView *customAnnotationView;
    if ([annotation isKindOfClass:[KTMapAnnotation class]] ){
        KTMapAnnotation *theAnnotation = (KTMapAnnotation*)annotation;
        
        customAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:theAnnotation reuseIdentifier:nil];
            
        
        
        // 08 - Add a Callout
        [customAnnotationView setCanShowCallout:YES];
        
        // 10 - Add an Image to the Callout
        UIView *leftIconView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        
        [customAnnotationView setLeftCalloutAccessoryView:leftIconView];
        
        // 11 - Add a Button to the Callout
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [customAnnotationView setRightCalloutAccessoryView:rightButton];
    
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
    
    KTMapAnnotation* lastAnnotation = [[self.myMapView selectedAnnotations]  objectAtIndex:0];
    
    BidViewController *selldetailViewController = [[BidViewController  alloc] initWithNibName:@"BidViewController" bundle:nil];
    
    selldetailViewController.jobObject = lastAnnotation.jobObject;
    
    [self.navigationController pushViewController:selldetailViewController animated:YES];
    
    
}



- (void) loadAllProduct
{
    [self.myMapView removeAnnotations:self.myMapView.annotations];
    
    for (PFObject *o in self.chatrooms) {
        
        PFGeoPoint* postlocation = o[PF_CHATROOMS_LOCATION];
        //
        
        double pointTwoLatitude = postlocation.latitude;
        double pointTwoLongitude = postlocation.longitude;
        
        
        CLLocationCoordinate2D pointTwoCoordinate =
        {pointTwoLatitude, pointTwoLongitude};
        KTMapAnnotation *jobAnnotation =
        [[KTMapAnnotation alloc] initWithCoordinate:pointTwoCoordinate];
        
        
        
        jobAnnotation.sttitle = [o valueForKey:PF_CHATROOMS_NAME];
        
        jobAnnotation.jobObject = o;
        [jobAnnotation setTypeOfAnnotation:PIN_RED];
        
        [self.myMapView addAnnotation:jobAnnotation];
        
        
    }
    
}




@end
