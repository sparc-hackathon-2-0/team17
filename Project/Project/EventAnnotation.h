
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface EventAnnotation : NSObject<MKAnnotation>

@property(nonatomic,readonly)CLLocationCoordinate2D coordinate;

-(id)initWithCoordinate:(CLLocationCoordinate2D)coord;

@end
