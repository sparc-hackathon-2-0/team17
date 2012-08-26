//
//  DataProvider.m
//  Project
//
//  Created by Brendan Lee on 8/25/12.
//
//

#import "DataProvider.h"

@interface NSString (URLEncoding)
-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;
@end

@implementation NSString (URLEncoding)
-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
	return (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                               (CFStringRef)self,
                                                               NULL,
                                                               (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                               CFStringConvertNSStringEncodingToEncoding(encoding));
}
@end

@implementation DataProvider

static DataProvider *sharedProvider;



+(id)sharedProvider
{
    if(sharedProvider == nil)
    {
        sharedProvider = [[self alloc] init];
    }
    
    return sharedProvider;
}

-(id)init
{
    self = [super init];
    
    if(self)
    {
        self.availableItems = [NSMutableArray array];
        
        self.currentLocationGeocoder  = [[[CLGeocoder alloc] init] autorelease];
        
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        _locationManager.delegate = self;
        _locationManager.purpose = @"This app uses your location to provide information about photos and places near you.";
        _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        _locationManager.distanceFilter = 100.0;
        
        [_locationManager startUpdatingLocation];
        
        self.APIClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:API_URL_BASE]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationResumed:) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBackgrounded:) name:UIApplicationWillEnterForegroundNotification object:nil];
        
        self.currentCategory = @"All";
    }
    
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.currentLocation = newLocation;
    
    [_currentLocationGeocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if(!error && [placemarks count]>0)
        {
            //Lets do some updating
            CLPlacemark *currentPlace = [placemarks objectAtIndex:0];
            self.currentCity = [currentPlace locality];
            self.currentState = [currentPlace administrativeArea];
            
            if([[currentPlace areasOfInterest] count]>0)
            {
                self.currentAreasOfInterest = [NSArray arrayWithArray:[currentPlace areasOfInterest]];
            }
            else {
                self.currentAreasOfInterest = nil;
            }
            
            //NSLog(@"New location available: %@, %@",self.currentCity, self.currentState);
        }
        else {
            self.currentCity = nil;
            self.currentState = nil;
            
            self.currentAreasOfInterest = nil;
        }
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ProjectNewLocationNotification object:nil];
    
    if([_availableItems count] ==0)
        [self reloadData];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if(error.code == kCLErrorDenied) {
        [manager stopUpdatingLocation];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GPS Denied" message:@"You must allow this app access to location services. Please change this in the settings menu." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    } else if(error.code == kCLErrorLocationUnknown) {
        // retry
    } else {
        //NSLog(@"Unknown error checking for location...will wait for system to try again.");
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if(status != kCLAuthorizationStatusDenied)
    {
        [manager startUpdatingLocation];
    }
    else {
        [manager stopUpdatingLocation];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GPS Denied" message:@"You must allow this app access to location services. Please change this in the settings menu." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
}

-(BOOL)isLocationAvailable
{
    if(_currentLocation)
    {
        return YES;
    }
    else {
        return NO;
    }
}

-(void)applicationResumed:(NSNotification*)note
{
    //Application resumed, hi accuracyt FTW!
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    _locationManager.distanceFilter = 5.0;
    [_locationManager startUpdatingLocation];
    
    [self reloadData];
}

-(void)applicationBackgrounded:(NSNotification*)note
{
    //Application backgrounded, don't waste battery
    _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    _locationManager.distanceFilter = 100.0;
}

-(void)reloadData
{
    //First lets update OUR server data.
    
    if(_currentLocation)
    {

    NSMutableURLRequest *request = [self.APIClient requestWithMethod:@"POST" path:@"getdata.php" parameters:@{@"lat" : [NSString stringWithFormat:@"%f",_currentLocation.coordinate.latitude], @"long" : [NSString stringWithFormat:@"%f",_currentLocation.coordinate.longitude], @"category" : _currentCategory}];
    
     [self.APIClient enqueueHTTPRequestOperation:[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
         
         NSMutableArray *newData = [NSMutableArray array];
         NSDictionary *result = (NSDictionary*)JSON;
                  
         //In case parsing fails...
         @try {
             
             if([[[result objectForKey:@"status"] lowercaseString] isEqualToString:@"success"])
             {
                 //Yay, lets turn it into objects!
                 
                 NSMutableArray *items = [NSMutableArray array];
                 
                 if([[result objectForKey:@"items"] isKindOfClass:[NSDictionary class]])
                     [items addObject:[result objectForKey:@"items"]];
                 else
                 {
                     if([[result objectForKey:@"items"] isKindOfClass:[NSArray class]])
                     {
                         [items addObjectsFromArray:[result objectForKey:@"items"]];
                     }
                 }
                 
                 for (int i=0; i<items.count; i++) {
                     ItemMetadata * newItem = [[[ItemMetadata alloc] init] autorelease];
                     
                     newItem.date = [[[items objectAtIndex:i] objectForKey:@"date"] intValue];
                     newItem.description = [[items objectAtIndex:i] objectForKey:@"description"];
                     newItem.identifier = [[[items objectAtIndex:i] objectForKey:@"id"] intValue];
                     newItem.coordinate = CLLocationCoordinate2DMake([[[items objectAtIndex:i] objectForKey:@"lat"] doubleValue], [[[items objectAtIndex:i] objectForKey:@"long"] doubleValue]);
                     
                     if([[[items objectAtIndex:i] objectForKey:@"pic_url"] isKindOfClass:[NSNull class]])
                     {
                         newItem.pic_url = nil;
                         NSLog(nil);

                     }
                     else{
                         newItem.pic_url = [NSURL URLWithString:[[items objectAtIndex:i] objectForKey:@"pic_url"]];
                         
                        // NSLog([[items objectAtIndex:i] objectForKey:@"pic_url"]);

                     }
                     
                     newItem.title = [[items objectAtIndex:i] objectForKey:@"title"];
                     
                     if([[[[items objectAtIndex:i] objectForKey:@"data_source"] lowercaseString] isEqualToString:@"wiki"])
                     {
                         newItem.type = ProjectItemTypeWikipedia;//Data_source or wiki (fix)
                     }
                     else
                     {
                         newItem.type = ProjectItemTypeService;
                     }
                     
                     [newData addObject:newItem];
                 }
                 
             }
             
             [_availableItems removeAllObjects];
             [_availableItems addObjectsFromArray:newData];
             
             NSLog(@"%d",_availableItems.count);
             
             [[NSNotificationCenter defaultCenter] postNotificationName:ProjectNewDataAvailableNotification object:nil];
         }
         @catch (NSException *exception) {
             //Bail!
             [[NSNotificationCenter defaultCenter] postNotificationName:ProjectNewDataFailedNotification object:nil];
         }
         @finally {

         }
         
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Failed: %@",[error description]);
        [[NSNotificationCenter defaultCenter] postNotificationName:ProjectNewDataFailedNotification object:nil];
    }]];
    }
}

-(void)submitNewContentWithImage:(UIImage*)image withTitle:(NSString*)title withDescription:(NSString*)description
{
    //Submit to server
    
    image = [UIImage imageWithCGImage:image.CGImage scale:0.5 orientation:UIImageOrientationUp];
    
   // RetinaAwareUIGraphicsBeginImageContext(CGSizeMake(253, 253));
//    UIImageView *imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
//    [imageView setFrame:CGRectMake(0, 0, 253, 253)];
//    imageView.clipsToBounds = YES;
//    imageView.contentMode = UIViewContentModeScaleAspectFill;
//    [imageView setNeedsDisplay];
//    [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
//    
//    image = UIGraphicsGetImageFromCurrentImageContext();
//    
//   UIGraphicsEndImageContext();
//
//
    
    NSString *response = [[[NSString alloc] initWithData:[self uploadPhoto:image] encoding:NSUTF8StringEncoding] autorelease];
    
    int indexBegin = [response rangeOfString:@"<original>"].location+10;
    
    int indexEnd = [response rangeOfString:@"</original>"].location;
    
    if(indexBegin != NSNotFound && indexEnd != NSNotFound)
    {
    NSString *portion = [response substringWithRange:NSMakeRange(indexBegin, indexEnd-indexBegin)];
    
    NSLog(portion);
    
        NSMutableURLRequest *request = [self.APIClient requestWithMethod:@"POST" path:@"getdata.php" parameters:@{@"lat" : [NSString stringWithFormat:@"%f",_currentLocation.coordinate.latitude], @"long" : [NSString stringWithFormat:@"%f",_currentLocation.coordinate.longitude], @"category" : _currentCategory, @"title" : title, @"description" : description, @"fileurl" : portion}];
    
    [self.APIClient enqueueHTTPRequestOperation:[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Success" message:[NSString stringWithFormat:@"Your photo has been submitted for review. Thanks!\n\nYou can also find your image at: %@",portion] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Failed: %@",[error description]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Error" message:@"Error uploading your picture to the server." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
    }]];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Error" message:@"Error uploading your picture to the server." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
    }
    
}

-(NSData *)uploadPhoto:(UIImage *) image {
    NSData   *imageData  = UIImagePNGRepresentation(image);
    NSString *imageB64   = [self base64forData:imageData];  //Custom implementations, no built in base64 or HTTP escaping for iPhone
    NSString *uploadCall = [NSString stringWithFormat:@"key=%@&image=%@",@"246e87bf3ef51db94081d53408011285",[imageB64 urlEncodeUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://api.imgur.com/2/upload"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%d",[uploadCall length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[uploadCall dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLResponse *response;
    NSError *error = nil;
    
    NSData *XMLResponse= [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    return XMLResponse;
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}



- (NSString*)base64forData:(NSData*)theData {
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
}

void RetinaAwareUIGraphicsBeginImageContext(CGSize size) {
    
    static CGFloat scale = -1.0;
    
    if (scale<0.0) {
        
        UIScreen *screen = [UIScreen mainScreen];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0) {
            
            scale = [screen scale];
            
        }
        
        else {
            
            scale = 0.0;    
            
        }
        
    }
    
    if (scale>0.0) {
        
        UIGraphicsBeginImageContextWithOptions(size, NO, scale);
        
    }
    
    else {
        
        UIGraphicsBeginImageContext(size);
        
    }
    
}
@end
