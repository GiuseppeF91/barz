

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
// 13 - Working with Multiple Points
#define ARROW_ANNOTATION @"ARROW_ANNOTATION"
#define PIN_BLUE @"PIN_BLUE"
#define PIN_RED @"PIN_RED"

@interface KTMapAnnotation : NSObject <MKAnnotation> {
    
    CLLocationCoordinate2D _coordinate;
    
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

// 06 - Supporting Drag and Drop
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

// 08 - Add a Callout
- (NSString*) title;
- (NSString*) subtitle;
- (NSString*) description;

// 13 - Working with Multiple Points
@property(nonatomic, strong) NSString *typeOfAnnotation;

// 17 - Determine the direction
@property CLLocationDirection direction;
@property(nonatomic, strong)NSString* objectId;
@property(nonatomic, strong)NSString* sttitle;
@property(nonatomic, strong)NSString* stweburl;
@property(nonatomic, strong)NSString* stdescription;
@property(nonatomic, strong)PFObject* jobObject;
@end
