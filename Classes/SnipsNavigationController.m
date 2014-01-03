//
//  FirstViewController.m
//  Snpptz
//
//  Created by David Wang on 5/20/10.
//  Copyright UDFI, LLC 2010. All rights reserved.
//

#import "SnipsNavigationController.h"

#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>
#import "DataFetcher.h"
#import "SnpptzAPI.h"
#import "Blog.h"

@implementation SnipsNavigationController

@synthesize snipsMap, snipsLoading;

#pragma mark -
#pragma mark View Controller Stuff

- (void)viewDidLoad 
{
	[super viewDidLoad];
	
	self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigation-bar.png"]] autorelease];
	
	[self presentMapViewController];	
}

- (void) didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; 
	NSLog(@"WebBrowserViewController memory warning");
}


#pragma mark -
#pragma mark IBActions

- (void) presentMapViewController
{
	// load xib + update title;
	self.snipsMap = [[[SnipsMapViewController alloc] initWithNibName:@"SnipsMapView" bundle:nil] autorelease];
	self.snipsMap.title = @"Snips";	
	
	// gear button
	UIButton *gearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
	[gearButton setImage:[UIImage imageNamed:@"gear.png"] forState:UIControlStateNormal];
	[gearButton	addTarget:self.snipsMap action:@selector(showSettings) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *gearButtonItem = [[UIBarButtonItem alloc] initWithCustomView:gearButton];
	
	// filter button
	UIButton *filterButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
	[filterButton setImage:[UIImage imageNamed:@"filter.png"] forState:UIControlStateNormal];
	[filterButton addTarget:self action:@selector(presentFilterSnips) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *filterButtonItem = [[UIBarButtonItem alloc] initWithCustomView:filterButton];
	
	// set left right nav items
	self.snipsMap.navigationItem.leftBarButtonItem = filterButtonItem;
	self.snipsMap.navigationItem.rightBarButtonItem = gearButtonItem;
				
	// push
	[self pushViewController:self.snipsMap animated:NO];
	
	// cleanup
	[gearButton release];
	[gearButtonItem release];
	[filterButton release];
	[filterButtonItem release];
	
}

- (void) presentLoadingScreen
{
	// load the xib + update title
	self.snipsLoading = [[[LoadingScreenViewController alloc] initWithNibName:@"LoadingScreenView" bundle:nil] autorelease];
	self.snipsLoading.title = @"Snips";	
	
	// push the xib
	[self pushViewController:self.snipsLoading animated:NO];
}

- (void) presentFilterSnips
{
	// init the controller
	SelectionListViewController *controller = [[SelectionListViewController alloc] init];
	controller.delegate = self;
	
	// get the data
	DataFetcher *fetcher = [DataFetcher sharedInstance];
	
	NSArray *blogArray =  [fetcher fetchManagedObjectsForEntity:@"Blog" withPredicate:nil];
	controller.list = blogArray;

	NSMutableArray *tempUnselectedBlogIds = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"unselectedBlogIds"]];
	controller.unselectedBlogIds = tempUnselectedBlogIds;
	
	// debug for the unselected ids
	NSLog(@"contents of unselectedBlogIds: %@", controller.unselectedBlogIds);
	
	// setup the modal view
	UINavigationController *snipsController = [[UINavigationController alloc] initWithRootViewController:controller];
	
	// push modal view
	[self presentModalViewController:snipsController animated:YES];
	
	// cleanup
	[tempUnselectedBlogIds release];
	[controller release];
	[snipsController release];
}

#pragma mark -
#pragma mark ModalTableViewDelegate methods

- (void) finishedSelections
{
	SnipsMapViewController *mapViewController = (SnipsMapViewController *)[self topViewController];
	
	[mapViewController clearAnnotations];
	
	[mapViewController updateLocation];
	
	mapViewController.unselectedBlogIds = [[NSUserDefaults standardUserDefaults] objectForKey:@"unselectedBlogIds"];
	
	[NSThread detachNewThreadSelector:@selector(getNewAnnotations:) toTarget:mapViewController withObject:mapViewController.unselectedBlogIds];
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc 
{
	[snipsMap release];
	[snipsLoading release];
    [super dealloc];
}

@end
