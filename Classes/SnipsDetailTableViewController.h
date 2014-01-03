//
//  SnipsDetailTableViewController.h
//  Snpptz
//
//  Created by David Wang on 6/29/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Snip.h"

@interface SnipsDetailTableViewController : UITableViewController <UITableViewDelegate>
{
	NSArray *sections;
	Snip *snip;
	CGSize headerSize;
	CGSize descriptionSize;
	UITableViewCell *addressCell;
	CLLocationCoordinate2D currentLocationCoordinate;
	UINavigationController *currentNavigationController;
	MKReverseGeocoder *lookup;
}

@property (nonatomic, retain) NSArray *sections;
@property (nonatomic, retain) Snip *snip;
@property (nonatomic) CGSize headerSize;
@property (nonatomic) CGSize descriptionSize;
@property (nonatomic, retain) UITableViewCell *addressCell;
@property (nonatomic) CLLocationCoordinate2D currentLocationCoordinate;
@property (nonatomic, retain) UINavigationController *currentNavigationController;
@property (nonatomic, retain) MKReverseGeocoder *lookup;

@end
