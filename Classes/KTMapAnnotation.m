


#import "KTMapAnnotation.h"
#import "AppConstant.h"
@implementation KTMapAnnotation

@synthesize coordinate=_coordinate;

// 17 - Determine the direction
@synthesize direction;

// 13 - Working with Multiple Points
@synthesize typeOfAnnotation;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    
    if (self != nil)
    {
        _coordinate = coordinate;
    }
    
    return self;
}

// 06 - Supporting Drag and Drop
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    _coordinate = newCoordinate;
}



// 08 - Add a Callout
- (NSString*) title
{
    
    
    return self.sttitle;
}

// 08 - Add a Callout
- (NSString*) subtitle
{
    NSString* price = self.jobObject[PF_CHATROOMS_BUDGET];
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
    
    NSString* tmp = [NSString stringWithFormat:@"%@: %@",price,self.jobObject[PF_CHATROOMS_DESCRIPTION]];
    
    return tmp;
}





@end
