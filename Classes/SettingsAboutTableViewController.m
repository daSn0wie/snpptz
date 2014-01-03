//
//  SettingsAboutTableViewController.m
//  Snpptz
//
//  Created by David Wang on 7/2/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import "SettingsAboutTableViewController.h"


@implementation SettingsAboutTableViewController


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad];

    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
	myTableView.backgroundView = backgroundImageView;
	
	UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 63, 30)];
	[backButton setImage:[UIImage imageNamed:@"back-icon.png"] forState:UIControlStateNormal];
	[backButton	addTarget:self action:@selector(closeWindow) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
	
	self.navigationItem.leftBarButtonItem = leftBarButtonItem;
	
	// cleanup
	[backgroundImageView release];
	[backButton release];
	[leftBarButtonItem release];
}

- (void) didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"SettingsAboutTableViewController memory warning");
}

#pragma mark -
#pragma mark IBActions/Methods

- (void) closeWindow
{
	[self.navigationController popViewControllerAnimated:YES]; 
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	if (indexPath.section == 0 && indexPath.row == 0)
	{
		[cell.imageView setImage:[UIImage imageNamed:@"settings-about-icon.png"]];					
		cell.textLabel.text = @"About Snpptz";
	}
	else if (indexPath.section == 0  && indexPath.row == 1)
	{
		NSString *about = @"Our mission is to help bloggers connect with readers through their mobile devices. Using a mobile devices geolocation functionality, Snpptz provides a way for bloggers and their readers to connect with each other at a neighborhood level.";
		
		CGSize size = [about sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12.0f] 
											constrainedToSize:CGSizeMake(250, 100) 
												lineBreakMode:UILineBreakModeWordWrap];
		
		UILabel *textView = [[UILabel alloc] initWithFrame:CGRectMake(45.0,15.0,size.width,size.height)];
		textView.text = about;
		textView.font = [UIFont fontWithName:@"Helvetica" size:12];	
		textView.textAlignment = UITextAlignmentLeft;
		textView.textColor = [UIColor lightGrayColor];
		textView.lineBreakMode = UILineBreakModeWordWrap;
		textView.autoresizesSubviews = YES;
		textView.numberOfLines = 0;
		[cell.contentView addSubview:textView];
		
		//cleanup
		[textView release];
	}
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	float height = 40;
    if (indexPath.section == 0 && indexPath.row == 1)
	{
		height = 140.0f;
		
	}
	
	return height;
}


- (void)dealloc 
{
    [super dealloc];
	[myTableView release];
}


@end

