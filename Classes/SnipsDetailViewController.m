//
//  SnipsDetailViewController.m
//  Snpptz
//
//  Created by David Wang on 6/29/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import "SnipsDetailViewController.h"

@implementation SnipsDetailViewController 

@synthesize snip, usernameLabel, currentLocationCoordinate;;

#pragma mark -
#pragma mark View Controller Stuff
- (void)viewDidLoad 
{    
	[super viewDidLoad];
	self.usernameLabel.text = self.snip.blog.name;
	self.navigationItem.title = @"";
	
	tableViewController = [[SnipsDetailTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	tableViewController.tableView.backgroundColor = [UIColor blackColor];
	tableViewController.sections = [NSArray arrayWithObjects:@"1", @"2", nil];
	tableViewController.snip = self.snip;
	tableViewController.currentLocationCoordinate = self.currentLocationCoordinate;
	tableViewController.currentNavigationController = self.navigationController;
	
	UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 63, 30)];
	[backButton setImage:[UIImage imageNamed:@"back-icon.png"] forState:UIControlStateNormal];
	[backButton	addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
	
	self.navigationController.navigationBar.hidden = FALSE;
	self.navigationItem.leftBarButtonItem = leftBarButtonItem;
	
	// table footer paddings
	((UITableView *) tableViewController.view).tableFooterView = [[[UIView alloc] initWithFrame:CGRectMake(0,0, 20, 20)] autorelease];
	
	[self.view insertSubview:tableViewController.view atIndex:0];
	
	// cleanup
	[backButton release];
	[leftBarButtonItem release];
}

- (void) didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; 
	NSLog(@"SnipsDetailViewController memory warning");
}

#pragma mark -
#pragma mark IBActions

- (void) closeView
{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc 
{
    [super dealloc];
	
	self.snip = nil;
	[usernameLabel release];
	[tableViewController release];
}



@end
