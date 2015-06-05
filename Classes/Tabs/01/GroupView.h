
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import "CSCell.h"

#import "SelectCategoryViewController.h"

#import "SearchViewController.h"
#import "MapViewController.h"
@import CoreLocation;


@interface GroupView : UICollectionViewController <UIAlertViewDelegate>
{
    NSTimer* timer;
    UIRefreshControl *refreshControl;
}
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, assign) BOOL includeUserLocation;

@end
