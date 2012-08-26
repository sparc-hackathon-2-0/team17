//
//  MapCutRevealViewController.m
//  Project
//
//  Created by Brendan Lee on 8/25/12.
//
//

#import "MapCutRevealViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MapCutRevealViewController ()

@end

@implementation MapCutRevealViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CGRect rect  = CGRectMake(-341, 44, 341, 960);
    NSArray *nibs = nil;
    
    nibs = [[NSBundle mainBundle] loadNibNamed:@"HomescreenColumnPresentation" owner:self options:nil];
    
    
    if([nibs count]>0)
    {
        self.mainPresenter = [nibs objectAtIndex:0];
    }
    else
    {
        //Should never hit this
        self.mainPresenter = [[[HomescreenColumnPresentation alloc] initWithFrame:rect] autorelease];
    }

    self.mainPresenter.frame = rect;
    [_mainPresenter setMetaData:_selectedItemMetadata];
    [_mainPresenter setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"homeBackground.png"]]];
    
    [self.view addSubview:_mainPresenter];

    
    self.mapView = [[[MKMapView alloc] initWithFrame:CGRectMake(0, 44, 1024, 748-44)] autorelease];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    _mainPresenter.frame = CGRectMake(0, _mainPresenter.frame.origin.y, _mainPresenter.frame.size.width, _mainPresenter.frame.size.height);
    _mapView.frame = CGRectMake(341, _mapView.frame.origin.y, _mapView.frame.size.width-341, _mapView.frame.size.height);

    _titleBarText.text = _selectedItemMetadata.title;
    
    MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    
    region.center.latitude = _selectedItemMetadata.coordinate.latitude; 
    region.center.longitude = _selectedItemMetadata.coordinate.longitude; 
    
    region.span.longitudeDelta = 0.01f;
    region.span.latitudeDelta = 0.01f;
    
    [_mapView setRegion:region animated:YES];
    [_mapView regionThatFits:region];
    
    EventAnnotation *location = [[[EventAnnotation alloc] initWithCoordinate:_selectedItemMetadata.coordinate] autorelease];
    
    [_mapView addAnnotation:location];
    
    [self.view bringSubviewToFront:_shadow];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKPinAnnotationView *pav = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    
    pav.pinColor = MKPinAnnotationColorGreen;
    return pav;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

-(IBAction)close
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)dealloc
{
    self.selectedItemMetadata = nil;
    self.mainPresenter = nil;
    self.mapView.delegate = nil;
    self.mapView=nil;
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
