    //
//  SettingsViewController.m
//  Snpptz
//
//  Created by David Wang on 5/21/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import "SettingsNavigationController.h"


@implementation SettingsNavigationController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	settingsList = [[SettingsListViewController alloc] initWithNibName:@"SettingsListView" bundle:nil];
	settingsList.title = @"Settings";	
	
	[self pushViewController:settingsList animated:NO];
	[settingsList release];
}
										
- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	NSLog(@"SettingsNavigationController error");
}

- (void)dealloc 
{
    [super dealloc];
	[settingsList release];
}


@end
