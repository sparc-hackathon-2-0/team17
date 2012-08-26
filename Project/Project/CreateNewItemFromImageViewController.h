//
//  CreateNewItemFromImageViewController.h
//  Project
//
//  Created by Brendan Lee on 8/25/12.
//
//

#import <UIKit/UIKit.h>

@protocol PopoverOwner <NSObject>

-(void)closeDismissPopover;

@end

@interface CreateNewItemFromImageViewController : UIViewController

@property(nonatomic,retain)UIImage *imageForTransport;
@property(nonatomic,retain)IBOutlet UIImageView * thumbnailContainer;
@property(nonatomic,retain)IBOutlet UITextField *titleField;
@property(nonatomic,retain)IBOutlet UITextView *descriptionField;

@property(nonatomic,retain)id<PopoverOwner> popoverOwner;

-(void)setImageTransport:(UIImage*)img;

@end
