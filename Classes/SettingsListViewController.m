//
//  SettingsListViewController.m
//  Snpptz
//
//  Created by David Wang on 5/21/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import "SettingsListViewController.h"
#import "SettingsAboutTableViewController.h"
#import <MessageUI/MessageUI.h>
#import "WebBrowserViewController.h"
#import "SettingsFoursquareViewController.h"

@implementation SettingsListViewController


#pragma mark -
#pragma mark View Controller Methods

- (void) viewDidLoad 
{
    [super viewDidLoad];
	self.navigationItem.title = @"";
	sections = [NSArray arrayWithObjects:@"", @"", nil];
	connectionIndex = [NSArray arrayWithObjects:@"Link Snpptz to Foursquare", nil];
	accountIndex = [NSArray arrayWithObjects:@"Snpptz Website", @"About Snpptz", @"Feedback", nil];
	
	UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
	myTableView.backgroundView = backgroundImageView;
	
	UIImage *logoutImage = [UIImage imageNamed:@"logout-button.png"];
	UIButton *logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(8, 240, logoutImage.size.width, logoutImage.size.height)];
	[logoutButton setImage:logoutImage forState:UIControlStateNormal];
	[logoutButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
	[self.view insertSubview:logoutButton atIndex:4];
	
	//cleanup
	[backgroundImageView release];
	[logoutButton release];
}

- (void) didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"SettingsListViewController memory warning");
}


#pragma mark -
#pragma mark IBActions/Methods

- (void) logout
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
}

- (void) presentEmail
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self; // <- very important step if you want feedbacks on what the user did with your email sheet
	
	picker.navigationItem.title = @"";
	picker.navigationBar.barStyle = UIBarStyleDefault; 
	picker.navigationItem.leftBarButtonItem.customView = [[[UIView alloc] init] autorelease];
	
	
	// Fill out the email body text
	NSString *emailBody = [NSString stringWithFormat:@"test"];

	[picker setMessageBody:emailBody isHTML:YES]; // depends. Mostly YES, unless you want to send it as plain text (boring)
	[picker setSubject:@" "];	
	
	[self presentModalViewController:picker animated:YES];
	[picker release];
}

#pragma mark -
#pragma mark tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return [sections count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	// return an empty header so we can muck with the space
	return [[[UIView alloc] init] autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	float height = 0;

	return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	NSInteger count;

	switch (section)
	{
		default:
		case 0:
			count = 1;
			break;
		case 1:
			count = [accountIndex count];
			break;
	}
	return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{	
	static NSString *SelectionListCellIdentifier = @"SelectionListCellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SelectionListCellIdentifier];
	
	if (cell == nil) 
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:SelectionListCellIdentifier] autorelease];
	}
	
	switch ([indexPath section])
	{
		case 0:
			cell.textLabel.text = [connectionIndex objectAtIndex:[indexPath row]];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			[cell.imageView setImage:[UIImage imageNamed:@"settings-foursquare-icon.png"]];
			break;
		case 1:
			cell.textLabel.text = [accountIndex objectAtIndex:[indexPath row]];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			if (indexPath.row == 0)
			{
				[cell.imageView setImage:[UIImage imageNamed:@"settings-website-icon.png"]];
			}
			else if (indexPath.row == 1)
			{
				[cell.imageView setImage:[UIImage imageNamed:@"settings-about-icon.png"]];				
			}
			else if (indexPath.row == 2)
			{
				[cell.imageView setImage:[UIImage imageNamed:@"settings-feedback-icon.png"]];				
			}
			
			break;
	}
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if ([indexPath section] == 0 && [indexPath row] == 0)
	{
		SettingsFoursquareViewController *foursquareViewController = [[SettingsFoursquareViewController alloc] initWithNibName:@"SettingsFoursquareView" bundle:nil];
		[self.navigationController pushViewController:foursquareViewController animated:YES];
		
		// cleanup
		[foursquareViewController release];
	}
	else if ([indexPath section] == 1 && [indexPath row] == 0)
	{
		WebBrowserViewController *browserController = [[WebBrowserViewController alloc] initWithNibName:@"WebBrowserView" bundle:nil];
		browserController.urlAddress = @"http://www.snpptz.com";
		[self.navigationController pushViewController:browserController animated:YES];
		
		// cleanup
		[browserController release];
	}
	else if ([indexPath section] == 1 && [indexPath row] == 1)
	{
		SettingsAboutTableViewController *settingsAboutViewController = [[SettingsAboutTableViewController alloc] initWithNibName:@"SettingsAboutTableView" bundle:nil]; 
		
		[self.navigationController pushViewController:settingsAboutViewController animated:YES];
		
		// releases
		[settingsAboutViewController release];
		
	}
	else if ([indexPath section] == 1 && [indexPath row] == 2)
	{
		[self presentEmail];
		
	}
}

#pragma mark -
#pragma mark Email delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
			break;
		case MFMailComposeResultFailed:
			break;
			
		default:
		{ 
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Sending Failed - Unknown Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];
			[alert release];
		}
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc 
{
    [super dealloc];
	[sections release];
	[sectionTitles release];
	[connectionIndex release];
	[accountIndex release];
	[myTableView release];
}


@end
