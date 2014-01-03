//
//  LauncherViewController.m
//  Snpptz
//
//  Created by David Wang on 5/21/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import "LauncherViewController.h"
#import "Blog.h"
#import "DataFetcher.h"
#import "SnpptzLauncherItem.h"
#import "BlogDetailViewController.h"
#import "BlogTableViewController.h"
#import "Snip.h"
#import "SnpptzAPI.h"
#import "SnipsViewController.h"

@implementation LauncherViewController

@synthesize locationManager;

#pragma mark -
#pragma mark View Controller Stuff

- (id)init 
{
	if (self = [super init]) 
	{
		self.title = @"Following";
	}
	return self;
}

- (void) viewWillAppear: (BOOL) animated
{
	[super viewWillAppear:animated];
	
	
	listOfBlogs = [[NSMutableArray alloc] init];
	
	launcherView = [[TTLauncherView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height - 48)];
	launcherView.backgroundColor = [UIColor clearColor];
	launcherView.delegate = self;
	launcherView.columnCount = 4;
	
	DataFetcher *fetcher = [DataFetcher sharedInstance];	
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(isFollowing == YES)"];		
	NSArray *blogArray =  [fetcher fetchManagedObjectsForEntity:@"Blog" withPredicate:predicate withSortDescriptor:sortDescriptor];	
	
	//clean up
	[sortDescriptor release];
	
	Blog *blog;
	
	NSMutableArray *pages = [[[NSMutableArray alloc] init] autorelease];
	NSMutableArray *page = [[[NSMutableArray alloc] init] autorelease];
	int count = 0;
	
	for (blog in blogArray)
	{
		UIImage *blogImage;
		
		if ([blog.isLargeIconImageAvailable boolValue])
		{
			blogImage = [UIImage imageWithData: blog.largeIconImage];
		}
		else
		{
			blogImage = [UIImage imageNamed:@"default-large-icon.png"];
		}
		
		SnpptzLauncherItem *launcherItem = [[SnpptzLauncherItem alloc] initWithTitle:blog.name 
																		   withImage:blogImage
																				 URL:@"" 
																		   canDelete:YES];
		launcherItem.blog = blog;
		[listOfBlogs addObject:blog];
		[page addObject:launcherItem];
		[launcherItem release];
		
		//TTLauncherItem* item = [launcherView itemWithURL:@"fb://item3"];
		//item.badgeNumber = 4;
		
		if (count % 16 == 0 && count != 0)
		{
			// add page to pages
			[pages addObject:page];
			[page removeAllObjects];
		}
		
		count++;
	}
	
	// add last page in if something there;
	if ([page count] > 0)
	{
		[pages addObject:page];
	}
	
	launcherView.pages = pages;
	
	UIImageView *spikes = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigation-trailer-small.png"]] autorelease];
	UIImageView *backgroundImage = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]] autorelease];
	backgroundImage.tag = 12345;
	spikes.tag = 123456;
	launcherView.tag = 1234567;
	
	if ([self.view viewWithTag:12345])
	{
		[[self.view viewWithTag:12345] removeFromSuperview];
	}
	
	if ([self.view viewWithTag:123456] )
	{
		[[self.view viewWithTag:123456] removeFromSuperview];
	}
	
	if ([self.view viewWithTag:1234567])
	{
		[[self.view viewWithTag:1234567] removeFromSuperview];
	}
	
	[self.view addSubview:backgroundImage];
	[self.view addSubview:launcherView];
	[self.view addSubview:spikes];
	
	CLLocationManager *myLocationManager = [[CLLocationManager alloc] init];
	self.locationManager = myLocationManager;
	
	self.locationManager.delegate = self; // send loc updates to myself
	self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
	[self.locationManager startUpdatingLocation];
	
	[myLocationManager release];
	[self setSegmentedControl];
}

- (void) setSegmentedControl
{	
	self.navigationItem.title = @"";
	
	NSArray *items = [NSArray arrayWithObjects:@"Icons", @"List", nil]; 
	segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.frame = CGRectMake(0, 0, 90, 30);
	segmentedControl.tintColor = [UIColor lightGrayColor];
	segmentedControl.selectedSegmentIndex = 0;	
	UIBarButtonItem *leftBarButonItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
	self.navigationItem.leftBarButtonItem = leftBarButonItem;
	
	[segmentedControl addTarget:self action:@selector(switchToList) forControlEvents:UIControlEventValueChanged];
}

- (void) didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; 
	NSLog(@"Launcher View Controller memory warning");
}

#pragma mark -
#pragma mark IBActions/Methods

- (void) switchToList
{
	if (segmentedControl.selectedSegmentIndex == 0)
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown
							   forView:self.view
								 cache:YES];
				
		[[self.view viewWithTag:1231231231] removeFromSuperview];
		[UIView commitAnimations];
	}
	else 
	{
		blogTableViewController = [[BlogTableViewController alloc] init];
		blogTableViewController.view.frame = CGRectMake(0, 0, 320, 420);
		blogTableViewController.view.tag = 1231231231;
		blogTableViewController.currentNavigationController = self.navigationController;
		blogTableViewController.listOfBlogs = listOfBlogs;
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp
							   forView:self.view
								 cache:YES];
		
		[self.view insertSubview:blogTableViewController.view atIndex:2];
		
		[UIView commitAnimations];
	}

}

#pragma mark -
#pragma mark TTLauncherViewDelegate

- (void)launcherView:(TTLauncherView*)launcher didSelectItem:(SnpptzLauncherItem*)item 
{
	snipsViewController = [[SnipsViewController alloc] initWithNibName:@"SnipsView" bundle:nil];
	snipsViewController.snipsTableViewController = [[SnipsTableViewController alloc] init];
	snipsViewController.snipsTableViewController.lostNavController = self.navigationController;
	snipsViewController.snipsTableViewController.view.frame = CGRectMake(0,0,320, 460);	
	snipsViewController.snipsTableViewController.view.tag = 99999;
	snipsViewController.snipsTableViewController.addHeaderPadding = FALSE; 
	
	[self.navigationController pushViewController:snipsViewController animated:YES];
	
	[NSThread detachNewThreadSelector:@selector(loadSnips:) toTarget:snipsViewController.snipsTableViewController withObject:item.blog];

}

- (void)launcherViewDidBeginEditing:(TTLauncherView*)launcher 
{
	[self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																							  target:launcherView 
																							  action:@selector(endEditing)] autorelease] 
									  animated:YES];
}

- (void)launcherViewDidEndEditing:(TTLauncherView*)launcher
{
	[self.navigationItem setRightBarButtonItem:nil animated:YES];
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc 
{
	[super dealloc];
	[launcherView release];
	[segmentedControl release];
	[blogTableViewController release];
	[listOfBlogs release];
}


@end
