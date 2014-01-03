//
//  FindPublishersViewController.m
//  Snpptz
//
//  Created by David Wang on 5/21/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import "BlogTableViewController.h"
#import "Blog.h"
#import "BlogDetailViewController.h"
#import "SnpptzAPI.h"
#import <QuartzCore/QuartzCore.h>

@implementation BlogTableViewController

@synthesize listOfBlogs, searchTerm, searchBar, currentNavigationController, showSpinner, showNoResults;

#pragma mark -
#pragma mark View Controller Calls

- (void) viewDidLoad
{
	[super viewDidLoad];
	self.navigationItem.title = @"";
	self.listOfBlogs = [[[NSMutableArray alloc] init] autorelease];
	self.showSpinner = FALSE;
}

- (void) didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	NSLog(@"TODO:  LoadingScreenViewController - memory warning");
}

#pragma mark -
#pragma mark UITableViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	NSInteger rows;
	
	if ([self.listOfBlogs count] == 0)
	{
		rows = 1;
	}
	else 
	{
		rows = [self.listOfBlogs count];
	}
	
	return rows;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{

	if ([self.listOfBlogs count] > 0)
	{
		BlogDetailViewController *detailViewController = [[BlogDetailViewController alloc] initWithNibName:@"BlogDetailView" bundle:nil]; 
		
		Blog *blog = [self.listOfBlogs objectAtIndex:indexPath.row];
		
		detailViewController.blog = blog;

		
		[self.currentNavigationController pushViewController:detailViewController animated:YES];
		
		// releases
		[detailViewController release];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
	static NSString *SelectionListCellIdentifier = @"SelectionListCellIdentifier";
	
	NSUInteger row = [indexPath row];

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SelectionListCellIdentifier];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:SelectionListCellIdentifier] autorelease];
	}
	
	if ([self.listOfBlogs count] != 0)
	{
		Blog *blog = [self.listOfBlogs objectAtIndex:row];
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.textLabel.text = blog.name;
		
		if ([blog.isLargeIconImageAvailable boolValue])
		{
			UIImage *img = [UIImage imageWithData:blog.largeIconImage];
			cell.imageView.layer.cornerRadius = 5.0;
			cell.imageView.layer.masksToBounds = YES;
			cell.imageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
			cell.imageView.layer.borderWidth = 1.0;		
			[cell.imageView setImage:img];
		}
		else 
		{
			UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]; 
			spinner.tag = (int) blog.name;
			[cell.imageView setImage:[UIImage imageNamed:@"whiteback.png"]];
			[spinner startAnimating];
			[cell.imageView addSubview:spinner]; 
			NSDictionary *threadDict = [[NSDictionary alloc] initWithObjectsAndKeys:cell, @"cell", blog, @"blog", nil];
			
			[NSThread detachNewThreadSelector:@selector(waitForImage:) toTarget:self withObject:threadDict];
			[spinner release];
			[threadDict release];
		}
	}
	else 
	{
		if (self.showSpinner)
		{
			UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
			spinner.frame = CGRectMake(150, 15, 20, 20);
			[spinner startAnimating];
			
			cell.selectionStyle = UITableViewCellSelectionStyleNone;

			[cell.contentView addSubview:spinner];
			
			[spinner release];
		}
		else if (self.showNoResults)
		{
			cell.textLabel.text = @"Sorry, no results.  Try another search.";
			cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];	
			cell.textLabel.textColor = [UIColor lightGrayColor];
			cell.textLabel.numberOfLines = 2;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
	}

	
	return cell;
}

#pragma mark -
#pragma mark Threaded Response

- (void) waitForImage:(NSDictionary *)threadDict
{
	NSAutoreleasePool *wadingPool = [[NSAutoreleasePool alloc] init];
	
	Blog *blog = [threadDict objectForKey:@"blog"];
	UITableViewCell *cell = [threadDict objectForKey:@"cell"];
	
	while (![blog.isLargeIconImageAvailable boolValue])
	{
		// do nothing;
	}

	UIImage *img = [UIImage imageWithData:blog.largeIconImage];
	[[cell.imageView viewWithTag:(int) blog.name] removeFromSuperview];
	cell.imageView.layer.cornerRadius = 5.0;
	cell.imageView.layer.masksToBounds = YES;
	cell.imageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
	cell.imageView.layer.borderWidth = 1.0;		
	[cell.imageView setImage:img];

	[wadingPool release];	
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc 
{
    [super dealloc];
	[searchTerm release];
	[listOfBlogs release];
	[searchBar release];
}


@end
