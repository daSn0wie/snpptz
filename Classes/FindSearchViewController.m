//
//  FindSearchViewController.m
//  Snpptz
//
//  Created by David Wang on 7/1/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import "FindSearchViewController.h"
#import "DataFetcher.h"
#import "SnpptzAPI.h"
#import "Blog.h"

@implementation FindSearchViewController

- (void) viewDidLoad
{
	self.navigationItem.title = @"";	
	blogTableViewController = [[BlogTableViewController alloc] init];
	blogTableViewController.view.frame = CGRectMake(0, 49, 320, 420);
	blogTableViewController.currentNavigationController = self.navigationController;
	[self.view addSubview:blogTableViewController.view];
}

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"FindSearchViewController memory warning");
}

#pragma mark -
#pragma mark IBAction/Methods

- (void)searchBarCancelButtonClicked:(UISearchBar *)localSearchBar
{
	[localSearchBar resignFirstResponder];
}

- (void) searchBarSearchButtonClicked: (UISearchBar *) mySearchBar
{
	searchTerm = mySearchBar.text;
	[NSThread detachNewThreadSelector:@selector(loadList) toTarget:self withObject:nil];
	blogTableViewController.showSpinner = TRUE;
	[blogTableViewController.tableView reloadData];
	
	[mySearchBar resignFirstResponder];
}

- (void) reloadTheTable:(NSNumber *) count
{
	if ([count isEqualToNumber:[NSNumber numberWithInt:0]])
	{
		blogTableViewController.showSpinner	= FALSE;
		blogTableViewController.showNoResults = TRUE;
	}
	
	[blogTableViewController.tableView reloadData];	
}

- (void) loadList
{
	NSAutoreleasePool *wadingPool = [[NSAutoreleasePool alloc] init];
	[blogTableViewController.listOfBlogs removeAllObjects];
	
	NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
	NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
	
	NSArray *blogs = [SnpptzAPI searchForUsers:searchTerm withUsername:username withPassword:password];

	// this can probably be threaded.  we just need the list of users
	for(NSDictionary *blogInfo in blogs)
	{
		Blog *blog = [Blog createBlog:blogInfo isFollowing:NO];
		[blogTableViewController.listOfBlogs addObject:blog];
	}	
	
	[self performSelectorOnMainThread:@selector(reloadTheTable:) withObject:[NSNumber numberWithInt:[blogs count]] waitUntilDone:YES];
	[wadingPool release];
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc 
{
	[searchBar release];
	[blogTableViewController release];
    [super dealloc];
}

@end
