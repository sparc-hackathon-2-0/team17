//
//  ItemMetadata.m
//  Project
//
//  Created by Brendan Lee on 8/25/12.
//
//

#import "ItemMetadata.h"

@implementation ItemMetadata

-(id)init
{
    self=  [super init];
    
    if(self)
    {
        self.type = ProjectItemTypeUndefined;
    }
    
    return self;
}

-(void)dealloc
{
    self.description=nil;
    self.pic_url = nil;
    self.title = @"";
    
    [super dealloc];
}
@end
