//
//  ViewController.h
//  Project
//
//  Created by Brendan Lee on 8/25/12.
//
//

#import <UIKit/UIKit.h>
#import "EasyTableView.h"
#import "DataProvider.h"
#import "ItemMetadata.h"
#import "HomescreenColumnPresentation.h"
#import "CreateNewItemFromImageViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MapCutRevealViewController.h"

@interface ViewController : UIViewController<EasyTableViewDelegate, UIPopoverControllerDelegate, UIImagePickerControllerDelegate, PopoverOwner>

@property(nonatomic,retain)EasyTableView *horizontalScroller;
@property(nonatomic,retain)UIPopoverController*popover;
@property(nonatomic,retain)IBOutlet UIView *loadingWindow;
@property(nonatomic,retain)IBOutlet UIActivityIndicatorView *reloadingSpinny;
-(IBAction)openCamera:(id)sender;


@end
