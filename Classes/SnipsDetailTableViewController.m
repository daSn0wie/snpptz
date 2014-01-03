//
//  SnipsDetailTableViewController.m
//  Snpptz
//
//  Created by David Wang on 6/29/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import "SnipsDetailTableViewController.h"

#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "WebBrowserViewController.h"


@implementation SnipsDetailTableViewController

@synthesize sections, snip, headerSize, descriptionSize, addressCell, currentLocationCoordinate, currentNavigationController, lookup;

#pragma mark -
#pragma mark View Controller Stuff

- (void) didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; 
	NSLog(@"SnipsDetailTableViewController memory warning");
}


#pragma mark -
#pragma mark UITable Data Source delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    // Return the number of sections.
    return [self.sections count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    // Return the number of rows in the section.
	int count = 2;
		
	return count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	if (indexPath.section == 0) 
	{
		if (indexPath.row == 0)
		{
			UILabel *textView = [[UILabel alloc] initWithFrame:CGRectMake(90.0,30.0,self.headerSize.width,self.headerSize.height)];
			textView.text = self.snip.title;
			textView.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];	
			textView.textAlignment = UITextAlignmentLeft;
			textView.textColor = [UIColor blackColor];
			textView.lineBreakMode = UILineBreakModeWordWrap;
			textView.autoresizesSubviews = YES;
			textView.numberOfLines = 0;
			[cell.contentView addSubview:textView];
			
			UILabel *dateView = [[UILabel alloc] initWithFrame:CGRectMake(90.0,(headerSize.height + 30), 200, 20)];
			
			NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
			[formatter setDateFormat:@"EEEE, MMMM dd, yyyy"];
			NSString *dateResult = [formatter stringForObjectValue:self.snip.createdAt];
			
			dateView.text = [NSString stringWithFormat:@"%@", dateResult];
							 
			dateView.font = [UIFont fontWithName:@"Helvetica" size:10];	
			dateView.textAlignment = UITextAlignmentLeft;
			dateView.textColor = [UIColor grayColor];
			dateView.autoresizesSubviews = YES;
			dateView.numberOfLines = 1;
			
			[cell.contentView addSubview:dateView];
			
			UIImage *iconImage;
			
			if ([self.snip.blog.isLargeIconImageAvailable boolValue])
			{
				iconImage = [UIImage imageWithData:self.snip.blog.largeIconImage];
			}
			else 
			{
				iconImage = [UIImage imageNamed:@"default-large-icon.png"];
			}
			
			UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 30, iconImage.size.width, iconImage.size.height)];
			imageView.image = iconImage;
			imageView.layer.cornerRadius = 9.0;
			imageView.layer.masksToBounds = YES;
			imageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
			imageView.layer.borderWidth = 1.0;
			CGRect frame = imageView.frame;
			frame.size.width = 60;
			frame.size.height = 60;
			imageView.frame = frame;
			
			
			[cell.contentView addSubview:imageView];
			
			//clean up
			[textView release];
			[dateView release];
			[imageView release];
			[formatter release];
		}
		else if (indexPath.row == 1)
		{
			UILabel *textView = [[UILabel alloc] initWithFrame:CGRectMake(90.0,15.0,self.descriptionSize.width,self.descriptionSize.height)];
			textView.text = self.snip.snipDescription;
			NSLog(@"%@", self.snip.snipDescription);
			textView.font = [UIFont fontWithName:@"Helvetica" size:11];	
			textView.textAlignment = UITextAlignmentLeft;
			textView.textColor = [UIColor blackColor];
			textView.lineBreakMode = UILineBreakModeWordWrap;
			textView.autoresizesSubviews = YES;
			textView.numberOfLines = 0;
			[cell.contentView addSubview:textView];
			
			UIImage *readMoreImage = [UIImage imageNamed:@"readmore-button.png"];
			
			UIButton *readMoreButton = [[UIButton alloc] initWithFrame:CGRectMake(90, 20 + self.descriptionSize.height + 5, readMoreImage.size.width, readMoreImage.size.height)];
			[readMoreButton addTarget:self action:@selector(loadURL) forControlEvents:UIControlEventTouchUpInside];
			[readMoreButton setBackgroundImage:readMoreImage forState:UIControlStateNormal];

			[cell.contentView addSubview:readMoreButton];
						
			//clean up
			[textView release];
			[readMoreButton release];
		}
	}
	else if (indexPath.section == 1)
	{
		if (indexPath.row == 0)
		{
			UILabel *textView = [[UILabel alloc] initWithFrame:CGRectMake(30,0.0,100,40)];
			textView.text = @"Address";
			textView.font = [UIFont fontWithName:@"Helvetica-Bold" size:10];	
			textView.textAlignment = UITextAlignmentLeft;
			textView.textColor = [UIColor blueColor];
			textView.lineBreakMode = UILineBreakModeWordWrap;
			textView.autoresizesSubviews = YES;
			textView.numberOfLines = 1;
			[cell.contentView addSubview:textView];
			
			
			UILabel *addressView = [[UILabel alloc] initWithFrame:CGRectMake(90, 15, 200, 25)];
			addressView.text = self.snip.address;
			addressView.font = [UIFont fontWithName:@"Helvetica-Bold" size:10];	
			addressView.textAlignment = UITextAlignmentLeft;
			addressView.textColor = [UIColor blackColor];
			addressView.lineBreakMode = UILineBreakModeWordWrap;
			addressView.autoresizesSubviews = YES;
			addressView.numberOfLines = 0;
			
			[cell.contentView addSubview:addressView];
			
			// clean up
			[textView release];
			[addressView release];
			
		}		
		else if (indexPath.row == 1)
		{
			UILabel *directionView = [[UILabel alloc] initWithFrame:CGRectMake(90, 15, 200, 25)];
			directionView.text = @"Directions to this location";
			directionView.font = [UIFont fontWithName:@"Helvetica-Bold" size:10];	
			directionView.textAlignment = UITextAlignmentLeft;
			directionView.textColor = [UIColor blackColor];
			directionView.lineBreakMode = UILineBreakModeWordWrap;
			directionView.autoresizesSubviews = YES;
			directionView.numberOfLines = 0;
			
			[cell.contentView addSubview:directionView];
			cell.selectionStyle = UITableViewCellSelectionStyleBlue;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			
			// cleanup
			[directionView release];
		}
	}

    return cell;
}

#pragma mark -
#pragma mark IBActions/Methods

- (void) loadURL
{
	WebBrowserViewController *browserController = [[WebBrowserViewController alloc] initWithNibName:@"WebBrowserView" bundle:nil];
	browserController.urlAddress = snip.permalink;
	[self.currentNavigationController pushViewController:browserController animated:YES];
	
	//cleanup
	[browserController release];
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if (indexPath.section == 1 && indexPath.row == 1)
	{
		NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",
						 currentLocationCoordinate.latitude, currentLocationCoordinate.longitude,
						 [snip.latitude floatValue], [snip.longitude floatValue]];
		[[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	float height = 60;
    if (indexPath.section == 0 && indexPath.row == 0)
	{
		CGSize size = [self.snip.title sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0f] 
								  constrainedToSize:CGSizeMake(200, 1000) 
									  lineBreakMode:UILineBreakModeWordWrap];
		NSLog(@"title : %@", self.snip.title);
		self.headerSize = size ;
		
		// height of copy + 60 padding
		height = size.height + 60;
		
		if (height < 100)
		{
			height = 100;
		}
		
	}
	else if (indexPath.section == 0 && indexPath.row == 1)
	{
		CGSize size = [self.snip.snipDescription sizeWithFont:[UIFont fontWithName:@"Helvetica" size:11.0f] 
								  constrainedToSize:CGSizeMake(200, 100) 
									  lineBreakMode:UILineBreakModeWordWrap];
		
		self.descriptionSize = size ;
		
		UIImage *readMoreImage = [UIImage imageNamed:@"readmore-button.png"];
		
		// height of copy + 30 padding + image height + 30 padding
		height = size.height + 30 + readMoreImage.size.height  + 10 ;
	}
	
	return height;
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc 
{
    [super dealloc];
	[sections release];
	[addressCell release];
	[currentNavigationController release];	
}

@end

