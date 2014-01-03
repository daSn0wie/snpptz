//
//  PublishersListViewController.m
//  Snpptz
//
//  Created by David Wang on 5/21/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import "BlogListViewController.h"
#import "Blog.h"
#import "DataFetcher.h"
#import "SnpptzAPI.h"
#import "BlogDetailViewController.h"

@implementation BlogListViewController

@synthesize listOfBlogs;

#pragma mark -
#pragma mark View Controller Stuff

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.navigationItem.title = @"";
	self.listOfBlogs = [[[NSMutableArray alloc] init] autorelease];
	
	[self loadList];
}

- (void) didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; 
	NSLog(@"Launcher View Controller memory warning");
}

#pragma mark -
#pragma mark IBActions/Methods


- (void) loadList
{
	[self.listOfBlogs removeAllObjects];
	
	NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
	NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
	
	NSArray *blogs = [SnpptzAPI followingForUser:username withPassword:password];
	
	DataFetcher *fetcher = [DataFetcher sharedInstance];

	// this can probably be threaded.  we just need the list of users
	for(NSDictionary *blogInfo in blogs)
	{
		// does the snip exist?
		NSLog(@"blogInfo id : %@", [blogInfo valueForKey:@"id"]);
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(blogID == %@)", [blogInfo valueForKey:@"id"]];		
		NSArray *blogArray =  [fetcher fetchManagedObjectsForEntity:@"Blog" withPredicate:predicate];
		
		if (blogArray.count == 0)
		{	
			[Blog createBlog:blogInfo isFollowing:YES];
		}
	}	

	[self.listOfBlogs addObjectsFromArray:[fetcher fetchManagedObjectsForEntity:@"Blog" withPredicate:nil]];
}

#pragma mark -
#pragma mark UITableViewDelegate Methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [self.listOfBlogs count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
	BlogDetailViewController *detailViewController = [[BlogDetailViewController alloc] initWithNibName:@"BlogDetailView" bundle:nil]; 
	
	Blog *blog = [self.listOfBlogs objectAtIndex:[indexPath row]];
	detailViewController.blog = blog;
	
	[self.navigationController pushViewController:detailViewController animated:YES];

	// releases
	[detailViewController release];
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{	
	static NSString *SelectionListCellIdentifier = @"SelectionListCellIdentifier";
	
	NSUInteger row = [indexPath row];
	Blog *blog = [self.listOfBlogs objectAtIndex:row];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SelectionListCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:SelectionListCellIdentifier] autorelease];
	}
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	cell.textLabel.text = [NSString stringWithFormat:@"%@", blog.name];
	
	return cell;
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc 
{
    [super dealloc];
	[listOfBlogs release];
}


@end
