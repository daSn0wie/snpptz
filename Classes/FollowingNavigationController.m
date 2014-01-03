//
//  PublishersViewController.m
//  Snpptz
//
//  Created by David Wang on 5/21/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import "FollowingNavigationController.h"
#import "BlogListViewController.h"
#import "LauncherViewController.h"
#import "SnipsTableViewController.h"

@implementation FollowingNavigationController


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	LauncherViewController *launcher = [[LauncherViewController alloc] init];
	
	[self pushViewController:launcher animated:YES];
	
	// cleanup
	[launcher release];
	
}

- (void) didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; 
	NSLog(@"FollowingNavigationController memory warning");
}


- (void)dealloc 
{
    [super dealloc];
}


@end
