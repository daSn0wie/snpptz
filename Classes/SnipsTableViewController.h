//
//  SnipsTableViewController.h
//  Snpptz
//
//  Created by David Wang on 6/30/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SnipsTableViewController : UITableViewController <UITableViewDelegate> 
{
	NSMutableArray *snips;
	UINavigationController *lostNavController;
	CLLocationManager *locationManager;
	Boolean addHeaderPadding;
	Boolean clearOnExit;
	Boolean showEmptyMessage;
}

@property (nonatomic, retain) NSMutableArray *snips;
@property (nonatomic, retain) UINavigationController *lostNavController;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic) Boolean addHeaderPadding;
@property (nonatomic) Boolean clearOnExit;
@property (nonatomic) Boolean showEmptyMessage;

@end
