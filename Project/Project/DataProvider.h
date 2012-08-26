//
//  DataProvider.h
//  Project
//
//  Created by Brendan Lee on 8/25/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "AFNetworking.h"
#import "ItemMetadata.h"
#import <QuartzCore/QuartzCore.h>
#define API_URL_BASE @"http://184.73.178.89/"
//#define API_URL_BASE @"http://canary.52apps.com:88/scripts/"
#define ProjectNewLocationNotification @"ProjectNewLocationNotification"
#define ProjectNewDataAvailableNotification @"ProjectNewDataAvailableNotification"
#define ProjectNewDataFailedNotification @"ProjectNewDataFailedNotification"

@interface DataProvider : NSObject<CLLocationManagerDelegate>

@property(nonatomic,retain)NSMutableArray *availableItems;
@property(nonatomic,retain)CLLocationManager *locationManager;
@property(nonatomic,retain)CLLocation*currentLocation;
@property(nonatomic,retain)NSString *currentCity;
@property(nonatomic,retain)NSString *currentState;
@property(nonatomic,retain)NSArray *currentAreasOfInterest;
@property(nonatomic,retain)CLGeocoder*currentLocationGeocoder;
@property(nonatomic,retain)AFHTTPClient*APIClient;
@property(nonatomic,retain)NSString *currentCategory;


+(id)sharedProvider;

-(void)submitNewContentWithImage:(UIImage*)image withTitle:(NSString*)title withDescription:(NSString*)description;

@end
