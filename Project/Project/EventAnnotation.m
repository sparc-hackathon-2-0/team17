

#import "EventAnnotation.h"

@implementation EventAnnotation
- (id) initWithCoordinate:(CLLocationCoordinate2D)coord
{
    _coordinate = coord;
    return self;
}
@end
