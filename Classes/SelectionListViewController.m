//
//  SelectionListViewController.m
//  Snpptz
//
//  Created by David Wang on 6/15/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import "SelectionListViewController.h"
#import "Blog.h"

@implementation SelectionListViewController

@synthesize list, unselectedBlogIds, delegate;

#pragma mark -
#pragma mark View Controller Stuff

- (void) viewDidLoad 
{
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
								   initWithTitle:NSLocalizedString(@"Done", @"Done - for button to save changes")
								   style:UIBarButtonItemStyleDone
								   target:self
								   action:@selector(done)];
	
	self.navigationItem.rightBarButtonItem = saveButton;
	[saveButton release];
	[super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated 
{
	[self.tableView reloadData];
	[super viewWillAppear:animated];
}

- (void) didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	NSLog(@"TODO:  SelectionListViewController - memory warning");
}


#pragma mark -
#pragma mark Delegate Responses

- (void) done 
{
	[[NSUserDefaults standardUserDefaults] setObject:self.unselectedBlogIds forKey:@"unselectedBlogIds"];
	[self.delegate finishedSelections];
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Tableview methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *SelectionListCellIdentifier = @"SelectionListCellIdentifier";
	
	NSUInteger row = [indexPath row];
	Blog *blog = [list objectAtIndex:row];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SelectionListCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:SelectionListCellIdentifier] autorelease];
		if ([self.unselectedBlogIds containsObject:blog.name])
		{
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
		else {
			cell.accessoryType =  UITableViewCellAccessoryCheckmark ;
		}
	}

	cell.textLabel.text = blog.name;

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	NSUInteger row = [indexPath row];
	Blog *blog = [list objectAtIndex:row];
	
	if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
	{
		cell.accessoryType = UITableViewCellAccessoryNone;
		[self.unselectedBlogIds addObject:blog.name];
	}
	else {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		[self.unselectedBlogIds removeObjectAtIndex:[self.unselectedBlogIds indexOfObject:blog.name]];
	}

	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc 
{
	[list release];
	[unselectedBlogIds release];
	[super dealloc];
}

@end