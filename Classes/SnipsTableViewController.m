//
//  SnipsTableViewController.m
//  Snpptz
//
//  Created by David Wang on 6/30/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import "SnipsTableViewController.h"
#import "DataFetcher.h"
#import "Snip.h"
#import "SnipsDetailViewController.h"
#import "DateIntervalFormatter.h";
#import "SnpptzAPI.h"

@implementation SnipsTableViewController

@synthesize snips, lostNavController, locationManager, addHeaderPadding, clearOnExit, showEmptyMessage;


#pragma mark -
#pragma mark View Controller Stuff

- (void) didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; 
	NSLog(@"SnipsTableViewController memory warning");
}

#pragma mark -
#pragma mark IBAction/Methods
- (void) redrawTable
{
	[self.tableView reloadData];
}

- (void) loadSnips: (Blog *) blog
{
	self.snips = [[NSMutableArray alloc] init];
	NSAutoreleasePool *wadingPool = [[NSAutoreleasePool alloc] init];
	NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
	NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
	Snip *snip;
	NSArray *snipsInfo = [SnpptzAPI snipsForNonFollowedUser:blog.slug withUserName:username withPassword:password];
	
	for (NSDictionary *snipInfo in snipsInfo)
	{
		snip = [Snip createSnip:snipInfo withSave:NO withMapped:NO];
		
		CLLocationDegrees latitude = [snip.latitude doubleValue];
		CLLocationDegrees longitude = [snip.longitude doubleValue];
		
		snip.distance = [Snip calculateDistance:locationManager withLatitude:latitude withLongitude:longitude];
		
		[self.snips addObject:snip];
	}
	
	[self performSelectorOnMainThread:@selector(redrawTable) withObject:nil waitUntilDone:NO];
	
	[wadingPool release];
}


#pragma mark -
#pragma mark Table view data source


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
	if (self.addHeaderPadding)
	{
		return [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 20)] autorelease];
	}
	else {
		return [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] autorelease];
	}

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    // Return the number of rows in the section.
	NSInteger rows;
	
	if ([self.snips count] == 0)
	{
		rows = 1;
	}
	else {
		rows = [self.snips count];
	}
	
	return rows;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SnipsViews";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	if ([self.snips count] == 0)
	{
		if (self.showEmptyMessage)
		{
			cell.textLabel.text = @"Sorry, no snips found. \nPlease, scroll around some more.";
			cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];	
			cell.textLabel.textColor = [UIColor lightGrayColor];
			cell.textLabel.numberOfLines = 2;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		else {
			UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
			spinner.frame = CGRectMake(150, 15, 20, 20);
			[spinner startAnimating];
			
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			
			[cell.contentView addSubview:spinner];
			
			[spinner release];
		}

	}
	else 
	{
		Snip *snip = [self.snips objectAtIndex:indexPath.row];
		
		for (UIView *view in cell.contentView.subviews) {
			[view removeFromSuperview];
		}
		
		UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 26)];
		titleView.text = snip.title;
		titleView.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];	
		titleView.textAlignment = UITextAlignmentLeft;
		titleView.textColor = [UIColor blackColor];
		titleView.lineBreakMode = UILineBreakModeTailTruncation;
		titleView.autoresizesSubviews = NO;
		titleView.numberOfLines = 1;
		[cell.contentView addSubview:titleView];
		
		UILabel *subTitleView = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 200, 18)];
		subTitleView.text = snip.title;
		subTitleView.font = [UIFont fontWithName:@"Helvetica" size:11];	
		subTitleView.textAlignment = UITextAlignmentLeft;
		subTitleView.textColor = [UIColor lightGrayColor];
		subTitleView.backgroundColor = [UIColor clearColor];
		subTitleView.lineBreakMode = UILineBreakModeTailTruncation;
		subTitleView.autoresizesSubviews = YES;
		subTitleView.numberOfLines = 1;
		[cell.contentView addSubview:subTitleView];
		
		UIImageView *milesView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"miles-bullet.png"]];
		milesView.frame = CGRectMake(10, 38, milesView.image.size.width, milesView.image.size.height);
		
		UILabel *milesAwayLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, milesView.image.size.width, milesView.image.size.height)];
		milesAwayLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:10];
		milesAwayLabel.textColor = [UIColor whiteColor];
		milesAwayLabel.text = [NSString stringWithFormat:@"%2.1f miles", [snip.distance floatValue]];
		NSLog(@"distance :%@", snip.distance);
		milesAwayLabel.backgroundColor = [UIColor clearColor];
		[milesView addSubview:milesAwayLabel];
							  
		[cell.contentView addSubview:milesView];
		
		UILabel *dateIntervalText = [[UILabel alloc] initWithFrame:CGRectMake(220, 20, 60, 18)];
		dateIntervalText.text = [DateIntervalFormatter getIntervalString:snip.createdAt ];
		dateIntervalText.font = [UIFont fontWithName:@"Helvetica" size:11];	
		dateIntervalText.textAlignment = UITextAlignmentRight;
		dateIntervalText.textColor = [UIColor lightGrayColor];
		dateIntervalText.backgroundColor = [UIColor clearColor];
		dateIntervalText.lineBreakMode = UILineBreakModeTailTruncation;
		dateIntervalText.autoresizesSubviews = YES;
		dateIntervalText.numberOfLines = 1;
		[cell.contentView addSubview:dateIntervalText];
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		// cleanup
		[titleView release];
		[subTitleView release];
		[milesView release];
		[milesAwayLabel release];
		[dateIntervalText release];
		
		//cell.textLabel.text = @"Test";
	}
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if ([self.snips count] > 0)
	{
		SnipsDetailViewController *detailViewController = [[SnipsDetailViewController alloc] initWithNibName:@"SnipsDetailView" bundle:nil]; 

		Snip *snip = [self.snips objectAtIndex:indexPath.row];
		
		detailViewController.snip = snip;
		
		[self.lostNavController pushViewController:detailViewController animated:YES];
		
		// releases
		[detailViewController release];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	float height = 60;
	
	return height;
}

#pragma mark -
#pragma mark dealloc


- (void)dealloc 
{
    [super dealloc]; 
	
	[snips release];
	[lostNavController release];
	[locationManager release];
}


@end

