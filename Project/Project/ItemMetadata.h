//
//  ItemMetadata.h
//  Project
//
//  Created by Brendan Lee on 8/25/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define ProjectItemTypeUndefined -1;
#define ProjectItemTypeService 0
#define ProjectItemTypeWikipedia 1

@interface ItemMetadata : NSObject

@property(nonatomic, assign)long date;
@property(nonatomic, retain)NSString *description;
@property(nonatomic, assign)int identifier;
@property(nonatomic, assign)CLLocationCoordinate2D coordinate;
@property(nonatomic, retain)NSURL *pic_url;
@property(nonatomic, retain)NSString *title;
@property(nonatomic, assign)int type;
@end
