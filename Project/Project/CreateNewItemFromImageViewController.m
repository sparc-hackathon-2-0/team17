//
//  CreateNewItemFromImageViewController.m
//  Project
//
//  Created by Brendan Lee on 8/25/12.
//
//

#import "CreateNewItemFromImageViewController.h"

@interface CreateNewItemFromImageViewController ()

@end

@implementation CreateNewItemFromImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.contentSizeForViewInPopover = CGSizeMake(320, 480);

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_thumbnailContainer setImage:self.imageForTransport];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)setImageTransport:(UIImage*)img
{
    self.imageForTransport = img;
    [_thumbnailContainer setImage:self.imageForTransport];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

-(IBAction)submitThisThing:(id)sender
{
    [[DataProvider sharedProvider] submitNewContentWithImage:_imageForTransport withTitle:_titleField.text withDescription:_descriptionField.text];
    
    [_popoverOwner closeDismissPopover];
}

-(void)dealloc
{
    self.imageForTransport = nil;
    self.popoverOwner = nil;
    
    [super dealloc];
}

@end
