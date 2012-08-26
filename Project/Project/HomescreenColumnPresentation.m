//
//  HomescreenColumnPresentation.m
//  Project
//
//  Created by Brendan Lee on 8/25/12.
//
//

#import "HomescreenColumnPresentation.h"

@implementation HomescreenColumnPresentation

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInit];
        
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        [self commonInit];
    }
    
    return self;
}

-(id)init
{
    self = [super init];
    
    if(self)
    {
        [self commonInit];
    }
    
    return self;
    
}

-(void)commonInit
{
    //_articleTitle.font = [UIFont fontWithName:@"Bebas" size:33.0];
    _articleTitle.textColor = [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.2 alpha:1.0];
    self.backgroundColor = [UIColor clearColor];

    _descriptionView.scrollView.bounces = NO;
    
}

-(void)setMetaData:(ItemMetadata*)currentMetadata;
{
    self.currentMetadata = currentMetadata;
    
    //Setup the rest of the view when ready.
    _articleTitle.text = [_currentMetadata.title uppercaseString];
    
    if(_currentMetadata.pic_url != nil)
    {
        [_articleImage setImageWithURL:_currentMetadata.pic_url placeholderImage:[UIImage imageNamed:@"photoGeneric.png"]];
    }
    else
    {
        [_articleImage setImage:[UIImage imageNamed:@"photoGeneric.png"]];
    }
    
    NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
    [format setDateStyle:NSDateFormatterShortStyle];
    [format setTimeStyle:NSDateFormatterNoStyle];

    if(_currentMetadata.type==ProjectItemTypeService)
    {
        _dateLabel.text = [format stringFromDate:[NSDate dateWithTimeIntervalSince1970:_currentMetadata.date]];
        _itemTypeLabel.text = @"User Upload";
    }
    else
    {
        _dateLabel.text = @"";
        _itemTypeLabel.text = @"Wikipedia";
    }
    
    //Process description
    
    NSMutableString *desc = [NSMutableString string];
    
    [desc appendString:@"<html><body style=\"background-color:clear;\"><font face=\"helvetica neue\">"];
    [desc appendString:_currentMetadata.description];
    [desc appendString:@"</font></body></html>"];
    
    [_descriptionView loadHTMLString:desc baseURL:nil];
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
