//
//  HomescreenColumnPresentation.h
//  Project
//
//  Created by Brendan Lee on 8/25/12.
//
//

#import <UIKit/UIKit.h>
#import "ItemMetadata.h"
#import <QuartzCore/QuartzCore.h>

@interface HomescreenColumnPresentation : UIView

@property(nonatomic,retain)ItemMetadata *currentMetadata;

@property(nonatomic,retain)IBOutlet UILabel *articleTitle;
@property(nonatomic,retain)IBOutlet UIImageView *categoryImage;
@property(nonatomic,retain)IBOutlet UIImageView *articleImage;
@property(nonatomic,retain)IBOutlet UILabel *dateLabel;
@property(nonatomic,retain)IBOutlet UILabel *itemTypeLabel;
@property(nonatomic,retain)IBOutlet UIWebView *descriptionView;
@property(nonatomic,retain)IBOutlet UIButton *selectedButton;
-(void)setMetaData:(ItemMetadata*)currentMetadata;
@end
