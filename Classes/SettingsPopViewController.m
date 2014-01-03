//
//  SettingsPopViewController.m
//  Snpptz
//
//  Created by David Wang on 6/25/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import "SettingsPopViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "SnipsMapViewController.h"

@implementation SettingsPopViewController

@synthesize delegate, proximitySlider, proximity, snipsDateRange;

#pragma mark -
#pragma mark View Controller Stuff

- (void)viewDidLoad 
{
    [super viewDidLoad];

	settingsViewContainer.layer.masksToBounds = YES;
	settingsViewContainer.layer.cornerRadius = 10;
	settingsViewContainer.layer.borderColor = [[UIColor lightGrayColor] CGColor];
	settingsViewContainer.layer.borderWidth = 1.5;	
	
	if (self.snipsDateRange != nil)
	{
		NSArray *segmentedValues = [NSArray arrayWithObjects:@"DAY", @"WEEK", @"MONTH", nil];
		postDateSegmentedControl.selectedSegmentIndex = [segmentedValues indexOfObject:self.snipsDateRange];
	}
	
	if (self.proximity != 0)
	{
		proximitySlider.value = self.proximity;
		proximityValueLabel.text = [NSString stringWithFormat:@"%1.2f mi.", self.proximity];
	}
	
}

- (void) didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; 
	NSLog(@"SettingsPopViewController memory warning");
}

#pragma mark -
#pragma mark IBActions

- (void) updatePostDate:(UISegmentedControl *)sender
{
	NSString *range;
	switch (sender.selectedSegmentIndex) 
	{
		case 0:
			range = @"DAY";
			break;
		default:	
		case 1:
			range = @"WEEK";
			break;
		case 2:
			range = @"MONTH";
			break;
	}
	
	[self.delegate setDateRange:range];
}

- (void) updateProximity:(UISlider *)sender
{
	proximityValueLabel.text = [NSString stringWithFormat:@"%.2f mi.", [sender value]];
	[self.delegate setProximity:[sender value]];
}

- (void) updateProximityLabel:(UISlider *) sender
{
	proximityValueLabel.text = [NSString stringWithFormat:@"%.2f mi.", [sender value]];
}

- (void) executeSearch:(id)sender
{
	[self.delegate hideSettings];	
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc 
{
    [super dealloc];
	[outerViewContainer release];
	[settingsViewContainer release];
	[proximityValueLabel release];
	[proximitySlider release];
	[postDateSegmentedControl release];
	[searchButton release];
	[snipsDateRange release];
}


@end
