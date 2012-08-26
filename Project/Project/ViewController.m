//
//  ViewController.m
//  Project
//
//  Created by Brendan Lee on 8/25/12.
//
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

//EasyTableview is used for Horizontal tableviews...Normal tableviews are typically preferred.

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.horizontalScroller = [[[EasyTableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44) numberOfColumns:0 ofWidth:341] autorelease];
    
    _horizontalScroller.delegate = self;
    _horizontalScroller.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _horizontalScroller.tableView.backgroundColor = [UIColor clearColor];
    _horizontalScroller.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_horizontalScroller];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataUpdated) name:ProjectNewDataAvailableNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataFailed) name:ProjectNewDataFailedNotification object:nil];
}

-(IBAction)updateData:(id)sender
{
    [[DataProvider sharedProvider] reloadData];
    [_reloadingSpinny startAnimating];
}

-(void)dataUpdated
{
    [_loadingWindow setHidden:YES];
    [_reloadingSpinny stopAnimating];
    [_horizontalScroller reloadData];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

-(void)dataFailed
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was a network error, please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [alert release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (UIView *)easyTableView:(EasyTableView *)easyTableView viewForRect:(CGRect)rect
{
    HomescreenColumnPresentation *cell = nil;
    NSArray *nibs = nil;
    
    nibs = [[NSBundle mainBundle] loadNibNamed:@"HomescreenColumnPresentation" owner:self options:nil];
    
    
    if([nibs count]>0)
    {
        cell = [nibs objectAtIndex:0];
    }
    else
    {
        //Should never hit this
        cell = [[[HomescreenColumnPresentation alloc] initWithFrame:rect] autorelease];
    }

    cell.frame = rect;
    
    [cell.selectedButton addTarget:self action:@selector(selectedItemWithButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)easyTableView:(EasyTableView *)easyTableView setDataForView:(UIView *)view forIndexPath:(NSIndexPath *)indexPath
{
    HomescreenColumnPresentation *cell = (HomescreenColumnPresentation*)view;
    
    [cell setMetaData:[[[DataProvider sharedProvider] availableItems] objectAtIndex:indexPath.row]];
    
    cell.selectedButton.tag = indexPath.row;
    
}

- (NSUInteger)numberOfSectionsInEasyTableView:(EasyTableView*)easyTableView
{
    return 1;
}

- (NSUInteger)numberOfCellsForEasyTableView:(EasyTableView *)view inSection:(NSInteger)section
{
    return [[[DataProvider sharedProvider] availableItems] count];
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.popover = nil;
}

CGImageRef UIGetScreenImage(void);

-(void)selectedItemWithButton:(UIButton*)button
{
    int itemSelect = button.tag;
    
    
    MapCutRevealViewController *reveal = [[[MapCutRevealViewController alloc] initWithNibName:@"MapCutRevealViewController" bundle:nil] autorelease];
    
    [reveal setSelectedItemMetadata:[[[DataProvider sharedProvider] availableItems] objectAtIndex:itemSelect]];
    
    [self presentModalViewController:reveal animated:YES];

}


-(IBAction)openCamera:(id)sender
{
    UIImagePickerController *picker = [[[UIImagePickerController alloc] init] autorelease];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.allowsEditing = YES;
    
    self.popover = [[UIPopoverController alloc] initWithContentViewController:picker];
    
    [_popover presentPopoverFromRect:[sender bounds] inView:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *edited = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if(edited != nil && self.popover != nil)
    {
        CreateNewItemFromImageViewController *controller = [[[CreateNewItemFromImageViewController alloc] initWithNibName:@"CreateNewItemFromImageViewController" bundle:nil] autorelease];
        
        [controller setImageTransport:edited];
        controller.popoverOwner = self;
        
        self.popover.contentViewController = controller;
        
        [self.popover setPopoverContentSize: CGSizeMake(320, 480) animated:YES];
    }
}

-(void)closeDismissPopover
{
    [self.popover dismissPopoverAnimated:YES];
    [self popoverControllerDidDismissPopover:self.popover];
}

@end
