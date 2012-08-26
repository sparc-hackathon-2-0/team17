

#import <UIKit/UIKit.h>
#import "HomescreenColumnPresentation.h"
#import <MapKit/MapKit.h>
#import "ItemMetadata.h"
#import "EventAnnotation.h"

@interface MapCutRevealViewController : UIViewController


@property(nonatomic,retain)HomescreenColumnPresentation *mainPresenter;

@property(nonatomic,assign)ItemMetadata *selectedItemMetadata;

@property(nonatomic,retain)MKMapView *mapView;
@property(nonatomic,retain)IBOutlet UIImageView *titleBar;
@property(nonatomic,retain)IBOutlet UILabel *titleBarText;
@property(nonatomic,retain)IBOutlet UIImageView *shadow;
@end
