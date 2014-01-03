//
//  TipsMapController.m
//  Snpptz
//
//  Created by David Wang on 5/21/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import "SnipsMapViewController.h"
#import "DataFetcher.h"
#import "SnpptzAPI.h"
#import "Snip.h"
#import "SnipMapAnnotation.h"
#import "SnipsDetailViewController.h"
#import "SettingsPopViewController.h"
#import "CustomMKAnnotationView.h"
#import "SnipsTableViewController.h"
#import "ImageManipulator.h"

@implementation SnipsMapViewController

@synthesize locationManager, accuracy, viewCoordinate, unselectedBlogIds, span, 
			snipsDateRange, mapListSegmentedControl, settingsActive, oldSnipsDateRange, snips;


#pragma mark -
#pragma mark static methods

+ (CGFloat)annotationPadding
{
    return 10.0f;
}

+ (CGFloat)calloutHeight
{
    return 40.0f;
}


#pragma mark -
#pragma mark View Controller Stuff

- (void)viewDidLoad 
{
	[super viewDidLoad];
	
	// set the settingsActive
	self.settingsActive = FALSE;
	
	// clear out title
	self.navigationItem.title = @"";
	
	// init location manager
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self; // send loc updates to myself
	self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
	
	// set the unselected blog ids
	self.unselectedBlogIds = [NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"unselectedBlogIds"]];
	
	// set the date range
	self.snipsDateRange = [[NSUserDefaults standardUserDefaults] objectForKey:@"snipsDateRange"];
	if (self.snipsDateRange == nil)
	{
		self.oldSnipsDateRange = @"WEEK";
		self.snipsDateRange = @"WEEK";
		[[NSUserDefaults standardUserDefaults] setValue:self.snipsDateRange forKey:@"snipsDateRange"];
	}
	
	// setup the default accuracy
	NSNumber *tempAccuracy = (NSNumber *) [[NSUserDefaults standardUserDefaults] objectForKey:@"accuracy"];
	self.accuracy = [tempAccuracy floatValue];
	if (self.accuracy == 0)
	{
		self.accuracy = .5;
		[[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithFloat:self.accuracy] forKey:@"accuracy"];
	}
	
	// setup the default span
	MKCoordinateSpan defaultSpan;
	defaultSpan.longitudeDelta = (self.accuracy/69);
	defaultSpan.latitudeDelta = (self.accuracy/69);
	self.span = defaultSpan;
	
	// alloc the annotations (this is released in the dealloc) - do not release here
	annotations = [[NSMutableArray alloc] init];
	
	// shoot off the update location
	[self updateLocation];
	
	self.mapListSegmentedControl.selectedSegmentIndex = (int) [[NSUserDefaults standardUserDefaults] valueForKey:@"mapListToggle"];
	
	if (self.mapListSegmentedControl.selectedSegmentIndex == 1) 
	{
		[self switchToList];
	}
}

- (void) didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; 
	NSLog(@"SnipsMapViewController memory warning");
}

#pragma mark -
#pragma mark controller methods

- (void) showSettings 
{
	if (!self.settingsActive)
	{
		settingsViewController = [[SettingsPopViewController alloc] initWithNibName:@"SettingsPopView" bundle:nil];
		settingsViewController.snipsDateRange = self.snipsDateRange;
		settingsViewController.proximity = self.accuracy;
		
		[settingsViewController viewWillAppear:YES];
		settingsViewController.delegate = self;
		[self.view addSubview:settingsViewController.view];
		[settingsViewController viewDidAppear:NO];
		self.settingsActive = TRUE;
	}
	else {
		[self hideSettings];
	}
}

- (IBAction) changeMapView:(id)sender
{
	UISegmentedControl *segmentSelector = (UISegmentedControl *)sender;
	if (segmentSelector.selectedSegmentIndex == 1)
	{
		[self switchToList];
	}
	else if (segmentSelector.selectedSegmentIndex == 0)
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown
							   forView:self.view
								 cache:YES];
		
		[[self.view viewWithTag:99999] removeFromSuperview];
		[UIView commitAnimations];

	}
}

- (void) switchToList
{
	snipsTableViewController = [[SnipsTableViewController alloc] init];
	snipsTableViewController.lostNavController = self.navigationController;
	snipsTableViewController.locationManager = self.locationManager;
	snipsTableViewController.view.tag = 99999;
	snipsTableViewController.view.frame = CGRectMake(0, 30, self.view.bounds.size.width, self.view.bounds.size.height - 30);
	snipsTableViewController.addHeaderPadding = TRUE;
	
	DataFetcher *fetcher = [DataFetcher sharedInstance];
	snipsTableViewController.snips = [NSMutableArray arrayWithArray:[fetcher fetchManagedObjectsForEntity:@"Snip" withPredicate:nil]];	
	[snipsTableViewController.snips sortUsingSelector:@selector(snipDistanceSort:)];
	snipsTableViewController.showEmptyMessage = YES;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp
                           forView:self.view
							 cache:YES];
	
	[self.view insertSubview:snipsTableViewController.view atIndex:3];
	[UIView commitAnimations];
	
}

- (void) updateLocation
{	
	[self.locationManager startUpdatingLocation];
}

- (void) getNewAnnotations:(NSArray *) unselectedIds
{
	NSLog(@"getting new annotations");
	
	NSAutoreleasePool *wadingPool = [[NSAutoreleasePool alloc] init];
	
	NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
	NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
	
	NSArray *snipsInfo = [NSMutableArray arrayWithArray:[SnpptzAPI snipsForUser:self.viewCoordinate withAccuracy:self.accuracy withUserName:username withPassword:password withUnselectedIds:unselectedIds withDateRange:self.snipsDateRange]];

	DataFetcher *fetcher = [DataFetcher sharedInstance];

	for(NSDictionary *snipInfo in snipsInfo)
	{
		// does the snip exist?
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(snipID == %@)", [snipInfo valueForKey:@"id"]];		
		NSArray *snipArray =  [fetcher fetchManagedObjectsForEntity:@"Snip" withPredicate:predicate];
		
		if (snipArray.count == 0)
		{	
			Snip *snip = [Snip createSnip:snipInfo withLocationInfo:self.locationManager withSave:NO withMapped:YES];	
			[snips addObject:snip.snipID];
			SnipMapAnnotation *annotation = [[SnipMapAnnotation alloc] initWithSnip:snip];
			[annotations addObject:annotation];
			[annotation release];
		}
	}	

	[wadingPool release];
	[self performSelectorOnMainThread:@selector(addAnnotations) withObject:nil waitUntilDone:TRUE]; 
}

- (void) addAnnotations
{
	for (SnipMapAnnotation *annotation in annotations)
	{
		[mapView addAnnotation:annotation];
	}
}

- (void) clearAnnotations
{
	DataFetcher *fetcher = [DataFetcher sharedInstance];
	NSManagedObjectContext	*context = [fetcher managedObjectContext];
	
	for(SnipMapAnnotation *annotation in annotations)
	{
		NSArray *snipsArray =  [fetcher fetchManagedObjectsForEntity:@"Snip" withPredicate:nil];
		Snip *snip;
		for (snip in snipsArray)
		{
			[context deleteObject:snip];	
		}
	}	
	
	[mapView removeAnnotations:annotations];
}

#pragma mark -
#pragma mark CLLocationManager Delegate Methods

- (void) updateViewRegion: (CLLocationCoordinate2D) newCenterCoordinate withNewSpan:(MKCoordinateSpan) newSpan
{
	MKCoordinateRegion region;
	region.center = newCenterCoordinate;
	region.span = newSpan;
	
	[mapView setRegion:region animated:TRUE];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	mapView.showsUserLocation = NO;
	self.viewCoordinate = newLocation.coordinate;
	
	NSLog(@"Location: %@", [newLocation description]);
	
	[self.locationManager stopUpdatingLocation];
	[self updateViewRegion:newLocation.coordinate withNewSpan:self.span];	
	
	mapView.showsUserLocation = YES;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;
{
	NSLog(@"TODO: need to handle SnipsMapViewController didFailWithError: %@", [error description]);
}

#pragma mark -
#pragma mark MKMapViewDelegate methods

- (void)mapView:(MKMapView *)local_mapView regionDidChangeAnimated:(BOOL)animated
{
	self.viewCoordinate = local_mapView.centerCoordinate;
	NSLog(@"mapview region will change: firing getting new annotations");
	[NSThread detachNewThreadSelector:@selector(getNewAnnotations:) toTarget:self withObject:self.unselectedBlogIds];
}

- (void) mapView:(MKMapView *)localMapView didAddAnnotationViews:(NSArray *)views {
	CGRect visibleRect = [localMapView annotationVisibleRect]; 
	for (MKAnnotationView *view in views) {
		CGRect endFrame = view.frame;
		
		CGRect startFrame = endFrame; startFrame.origin.y = visibleRect.origin.y - startFrame.size.height;
		view.frame = startFrame;
		
		[UIView beginAnimations:@"drop" context:NULL]; 
		[UIView setAnimationDuration:.5];
		
		view.frame = endFrame;
		
		[UIView commitAnimations];
	}
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	SnipsDetailViewController *detailViewController = [[SnipsDetailViewController alloc] initWithNibName:@"SnipsDetailView" bundle:nil]; 
		
	SnipMapAnnotation *mapAnnotation = (SnipMapAnnotation *)view.annotation;
	
	DataFetcher *fetcher = [DataFetcher sharedInstance];

	// does the snip exist?
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(snipID == %@)", mapAnnotation.snipID];		
	NSArray *snipArray =  [fetcher fetchManagedObjectsForEntity:@"Snip" withPredicate:predicate];
	
	if (snipArray.count > 0)
	{	
		detailViewController.snip  = [snipArray objectAtIndex:0];
	}
	
	detailViewController.currentLocationCoordinate = self.locationManager.location.coordinate;
	
	[self.navigationController pushViewController:detailViewController animated:YES];

	// releases
	[detailViewController release];
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
	// handle snip map
    if ([annotation isKindOfClass:[SnipMapAnnotation class]]) 
	{
        static NSString* UserAnnotationIdentifier = @"CustomPinView";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:UserAnnotationIdentifier];
        
		if (!pinView)
        {

            MKAnnotationView *annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation
																						 reuseIdentifier:UserAnnotationIdentifier] autorelease];
            
			SnipMapAnnotation *snipAnnotation = (SnipMapAnnotation *) annotation;
			
			// get the images we're customizing
            UIImage *flagImage = [UIImage imageNamed:@"pin.png"];
			UIImage *iconShadowImage = [UIImage imageNamed:@"icon-shadowing.png"];
			UIImage *iconImage;
			
			iconImage = [UIImage imageWithData:snipAnnotation.smallIcon];
			
			
			//iconImage = [ImageManipulator makeRoundCornerImage:iconImage withCornerWidth:5 withCornerHeight:5];
			
			// add the iconimage to the pin
			CGRect backgroundRect, iconRect, iconShadowingRect;
			backgroundRect.size = flagImage.size;
			backgroundRect.origin = (CGPoint){0.0f, 0.0f};
			iconRect.size = iconImage.size;
			iconRect.origin = (CGPoint) {2.0f, 2.0f};
			iconShadowingRect.size = iconShadowImage.size;
			iconShadowingRect.origin = (CGPoint) {2.0f, 2.0f};
			
			UIGraphicsBeginImageContext(backgroundRect.size);
			[flagImage drawInRect:backgroundRect];
			[iconImage drawInRect:iconRect];
			[iconShadowImage drawInRect:iconShadowingRect];
			UIImage *combinedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
			
		
			// resize everything to fit screen
            CGRect resizeRect;
            resizeRect.size = combinedImage.size;
            CGSize maxSize = CGRectInset(self.view.bounds,
                                         [SnipsMapViewController annotationPadding],
                                         [SnipsMapViewController annotationPadding]).size;
            maxSize.height -= self.navigationController.navigationBar.frame.size.height + [SnipsMapViewController calloutHeight];
            if (resizeRect.size.width > maxSize.width)
                resizeRect.size = CGSizeMake(maxSize.width, resizeRect.size.height / resizeRect.size.width * maxSize.width);
            if (resizeRect.size.height > maxSize.height)
                resizeRect.size = CGSizeMake(resizeRect.size.width / resizeRect.size.height * maxSize.height, maxSize.height);
            
            resizeRect.origin = (CGPoint){0.0f, 0.0f};
            UIGraphicsBeginImageContext(resizeRect.size);
            [combinedImage drawInRect:resizeRect];
            UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
			
			// add the right callout button
			UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            /*[rightButton addTarget:self
                            action:@selector(showDetails:)
                  forControlEvents:UIControlEventTouchUpInside]; */
            annotationView.rightCalloutAccessoryView = rightButton;
			
			// set the annotation view info
			annotationView.canShowCallout = YES;
			annotationView.image = resizedImage;
            annotationView.opaque = NO;
			
            return annotationView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
	return nil;
}


#pragma mark -
#pragma mark SettingsPopViewControllerDelegate

- (void) hideSettings
{
	[settingsViewController viewWillDisappear:NO];
    [settingsViewController.view removeFromSuperview];
    [settingsViewController viewDidDisappear:NO];
	
	[self updateViewRegion:self.viewCoordinate withNewSpan:self.span];
	
	if ([self.oldSnipsDateRange compare:self.snipsDateRange] != NSOrderedSame)
	{
		[self clearAnnotations];
	}
	
	if (mapListSegmentedControl.selectedSegmentIndex == 1)
	{
		[[self.view viewWithTag:99999] removeFromSuperview];
		mapListSegmentedControl.selectedSegmentIndex == 0;
	}

	self.settingsActive = FALSE;
	
	[NSThread detachNewThreadSelector:@selector(getNewAnnotations:) toTarget:self withObject:self.unselectedBlogIds];
}

- (void) setProximity: (float) proximity
{
	//Set Zoom level using Span
	// 1 degree = 69 miles or 111 km
	MKCoordinateSpan updatedSpan;
	
	float delta = proximity/69;

	updatedSpan.latitudeDelta=delta;
	updatedSpan.longitudeDelta=delta;	
	
	self.span = updatedSpan;
	
	self.accuracy = proximity;
	[[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithFloat:proximity] forKey:@"accuracy"];
	
}

- (void)setDateRange: (NSString *) range
{
	self.oldSnipsDateRange = self.snipsDateRange;
	self.snipsDateRange = range;
	
	[[NSUserDefaults standardUserDefaults] setValue:range forKey:@"snipsDateRange"];
}

#pragma mark -
#pragma mark dealloc

- (void) dealloc 
{
	[locationManager release];
	[mapView release];
	[snips release];
	[annotations release];
	[unselectedBlogIds release];
	[settingsViewController release];
	[snipsDateRange release];
	[oldSnipsDateRange release];
	[mapListSegmentedControl release];
	[snipsTableViewController release];
	
	[super dealloc];
}



@end
