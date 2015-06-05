//
//  BAZRPost.h
//  bazr
//
//  Created by Justin Lynch on 1/28/15.
//  Copyright (c) 2015 KZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface BAZRPost : NSObject <MKAnnotation>

// Center latitude and longitude of the annotion view.
// The implementation of this property must be KVO compliant.
@property (nonatomic, assign, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *subtitle;

// Other properties:
@property (nonatomic, strong, readonly) PFObject *object;
@property (nonatomic, strong, readonly) PFUser *user;
@property (nonatomic, assign) BOOL animatesDrop;
@property (nonatomic, assign, readonly) MKPinAnnotationColor pinColor;

// Designated initializer.
- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate
                          andTitle:(NSString *)title
                       andSubtitle:(NSString *)subtitle;
- (instancetype)initWithPFObject:(PFObject *)object;


- (void)setTitleAndSubtitleOutsideDistance:(BOOL)outside;

@end
