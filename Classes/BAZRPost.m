//
//  BAZRPost.m
//  bazr
//
//  Created by Justin Lynch on 1/28/15.
//  Copyright (c) 2015 KZ. All rights reserved.
//

#import "BAZRPost.h"
#import "AppConstant.h"

@interface BAZRPost ()

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, strong) PFObject *object;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, assign) MKPinAnnotationColor pinColor;

@end

@implementation BAZRPost

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate
                          andTitle:(NSString *)title
                       andSubtitle:(NSString *)subtitle {
    self = [super init];
    if (self) {
        self.coordinate = coordinate;
        self.title = title;
        self.subtitle = subtitle;
    }
    return self;
}

- (instancetype)initWithPFObject:(PFObject *)object {
    [object fetchIfNeeded];
    
    PFGeoPoint *geoPoint = object[PF_POSTS_LOCATIONKEY];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
    NSString *title = object[PF_POSTS_TEXTKEY];
    NSString *subtitle = object[PF_POSTS_USERKEY][PF_POSTS_NAMEKEY] ?: object[PF_POSTS_USERKEY][PF_POSTS_USERNAMEKEY];
    
    self = [self initWithCoordinate:coordinate andTitle:title andSubtitle:subtitle];
    if (self) {
        self.object = object;
        self.user = object[PF_POSTS_USERKEY];
    }
    return self;
}

#pragma mark -
#pragma mark Equal

- (BOOL)isEqual:(id)other {
    if (![other isKindOfClass:[BAZRPost class]]) {
        return NO;
    }
    
    BAZRPost *post = (BAZRPost *)other;
    
    if (post.object && self.object) {
        // We have a PFObject inside the PAWPost, use that instead.
        return [post.object.objectId isEqualToString:self.object.objectId];
    }
    
    // Fallback to properties
    return ([post.title isEqualToString:self.title] &&
            [post.subtitle isEqualToString:self.subtitle] &&
            post.coordinate.latitude == self.coordinate.latitude &&
            post.coordinate.longitude == self.coordinate.longitude);
}

#pragma mark -
#pragma mark Accessors

- (void)setTitleAndSubtitleOutsideDistance:(BOOL)outside {
    if (outside) {
        self.title = PF_POSTS_CANTVIEWPOST;
        self.subtitle = nil;
        self.pinColor = MKPinAnnotationColorRed;
    } else {
        self.title = self.object[PF_POSTS_TEXTKEY];
        self.subtitle = self.object[PF_POSTS_USERKEY][PF_POSTS_NAMEKEY] ?:
        self.object[PF_POSTS_USERKEY][PF_POSTS_USERNAMEKEY];
        self.pinColor = MKPinAnnotationColorGreen;
    }
}

@end

