//
//  LauncherViewController.h
//  Snpptz
//
//  Created by David Wang on 5/21/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//
#import <Three20/Three20.h>
#import <MapKit/MapKit.h>
#import "BlogTableViewController.h"
#import "SnipsViewController.h"

@interface LauncherViewController : TTViewController <TTLauncherViewDelegate, CLLocationManagerDelegate> 
{
	TTLauncherView* launcherView;
	UISegmentedControl *segmentedControl;
	BlogTableViewController *blogTableViewController ;
	NSMutableArray *listOfBlogs;
	CLLocationManager *locationManager;
	SnipsViewController *snipsViewController;
}

@property (nonatomic, retain) CLLocationManager *locationManager;

- (void) setSegmentedControl;

@end
