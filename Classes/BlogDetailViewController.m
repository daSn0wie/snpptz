//
//  UserDetailViewController.m
//  Snpptz
//
//  Created by David Wang on 6/15/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import "BlogDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SnipsViewController.h"
#import "SnpptzAPI.h"
#import "Snip.h";
#import "DataFetcher.h"

@implementation BlogDetailViewController

@synthesize blog, locationManager, currentNavigationController;

#pragma mark -
#pragma mark View Controller comments

- (void) viewDidLoad
{
	[super viewDidLoad];
	
	UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 63, 30)];
	[backButton setImage:[UIImage imageNamed:@"back-icon.png"] forState:UIControlStateNormal];
	[backButton	addTarget:self action:@selector(closeScreen) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
	
	self.navigationItem.leftBarButtonItem = leftBarButtonItem;
	
	aboutLabel.text = [NSString stringWithFormat:@"About %@", self.blog.name];
	usernameLabel.text = self.blog.name;
	
	CGSize size = [self.blog.blogDescription sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12.0f] 
							  constrainedToSize:CGSizeMake(225, 100) 
								  lineBreakMode:UILineBreakModeWordWrap];
	
	bioLabel.frame = CGRectMake(bioLabel.frame.origin.x, bioLabel.frame.origin.y, size.width, size.height);
	bioLabel.text = self.blog.blogDescription;
	
	int delta = 0;
	if (size.height > 65)
	{
		delta = size.height - 40;
	}
	
	bioImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user-detail-block-bottom.png"]];
	bioImageView.frame = CGRectMake(37,248,248,65+delta);
	
	[self.view insertSubview:bioImageView atIndex:1];

	if ([self.blog.isSmallIconImageAvailable boolValue])
	{
		[iconImageView setImage:[UIImage imageWithData:self.blog.smallIconImage]];
	}
	else {
		[iconImageView setImage:[UIImage imageNamed:@"default-small-icon.png"]];
	}

	iconImageView.layer.cornerRadius = 5.0;
	iconImageView.layer.masksToBounds = YES;
	iconImageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
	iconImageView.layer.borderWidth = 1.0;
	
	CLLocationManager *myLocationManager = [[CLLocationManager alloc] init];
	self.locationManager = myLocationManager;
	
	self.locationManager.delegate = self; // send loc updates to myself
	self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
	[self.locationManager startUpdatingLocation];
	
	if ([self.blog.isFollowing boolValue])
	{
		[submitButton setImage:[UIImage imageNamed:@"iphone_delete_icon.png"] forState:UIControlStateNormal];
	}
	else {
		[submitButton setImage:[UIImage imageNamed:@"iphone_add_icon.png"] forState:UIControlStateNormal];
	}

	
	// clean up
	[backButton release];
	[leftBarButtonItem release];
	[myLocationManager release];

}

- (void) didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	NSLog(@"TODO:  Blog Detail View Controller - memory warning");
}

#pragma mark -
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	[self.locationManager stopUpdatingLocation];
}

#pragma mark -
#pragma mark IBActions

- (void) showSnips: (id) sender
{
	
	snipsViewController = [[SnipsViewController alloc] initWithNibName:@"SnipsView" bundle:nil];
	snipsViewController.snipsTableViewController = [[SnipsTableViewController alloc] init];
	snipsViewController.snipsTableViewController.lostNavController = self.navigationController;
	snipsViewController.snipsTableViewController.view.frame = CGRectMake(0,0,320, 460);	
	snipsViewController.snipsTableViewController.view.tag = 99999;
	snipsViewController.snipsTableViewController.addHeaderPadding = FALSE; 
	
	[self.navigationController pushViewController:snipsViewController animated:YES];
	
	[NSThread detachNewThreadSelector:@selector(loadSnips:) toTarget:snipsViewController.snipsTableViewController withObject:self.blog];
	
}

- (void) toggleBlog: (id) sender
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"loadPause" object:nil];	
	NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
	NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
	
	if (![self.blog.isFollowing boolValue])
	{
		NSArray *blogInfo = [SnpptzAPI followBlog:self.blog.slug withUsername:username withPassword:password];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:@"closePause" object:nil];	
		
		if ([blogInfo valueForKey:@"id"])
		{
			NSString *title = @"Blog Added!";
			NSString *message = [NSString stringWithFormat:@"You are now following %@", [blogInfo valueForKey:@"name"]];
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title 
															message:message 
														   delegate:self 
												  cancelButtonTitle:nil 
												  otherButtonTitles:@"Ok", nil ];
			[alert show];
			[alert release];
			
			self.blog.isFollowing = [NSNumber numberWithBool:TRUE];
			
			[submitButton setImage:[UIImage imageNamed:@"iphone_delete_icon.png"] forState:UIControlStateNormal];
		}
	}
	else 
	{
		NSArray *blogInfo = [SnpptzAPI unfollowBlog:self.blog.slug withUsername:username withPassword:password];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:@"closePause" object:nil];	
		
		if ([blogInfo valueForKey:@"id"])
		{
			NSString *title = @"Blog Added!";
			NSString *message = [NSString stringWithFormat:@"You are no longer following this blog"];
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title 
															message:message 
														   delegate:self 
												  cancelButtonTitle:nil 
												  otherButtonTitles:@"Ok", nil ];
			[alert show];
			[alert release];
			
			self.blog.isFollowing = [NSNumber numberWithBool:FALSE];
			
			[submitButton setImage:[UIImage imageNamed:@"iphone_add_icon.png"] forState:UIControlStateNormal];
		}
	}

}

- (void) clearSnips
{
	NSAutoreleasePool *wadingPool = [[NSAutoreleasePool alloc] init];
	
	DataFetcher *fetcher = [DataFetcher sharedInstance];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(isMapped == NO)"];		
	NSArray *snipArray =  [fetcher fetchManagedObjectsForEntity:@"Snip" withPredicate:predicate];
	
	if (snipArray.count > 0)
	{	
		for (Snip *snip in snipArray)
		{
			NSManagedObjectContext *aContext = [fetcher managedObjectContext];
			[aContext deleteObject:snip];
		}
	}	
	
	[wadingPool release];

}

- (void) closeScreen
{
	[NSThread detachNewThreadSelector:@selector(clearSnips) toTarget:self withObject:nil];
	[self.navigationController popViewControllerAnimated:YES]; 
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc 
{	
	[aboutLabel release];
	[usernameLabel release];
	[snipCountLabel release];
	[bioLabel release];
	[iconImageView release];
	[snipsViewController release];
	
    [super dealloc];
}


@end
