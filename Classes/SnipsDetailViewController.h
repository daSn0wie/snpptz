//
//  SnipsDetailViewController.h
//  Snpptz
//
//  Created by David Wang on 6/29/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Snip.h"
#import "SnipsDetailTableViewController.h"

@interface SnipsDetailViewController : UIViewController
{
	Snip *snip;
	IBOutlet UILabel *usernameLabel;
	IBOutlet SnipsDetailTableViewController *tableViewController;
	CLLocationCoordinate2D currentLocationCoordinate;
}

@property (nonatomic, retain) Snip *snip;
@property (nonatomic, retain) UILabel *usernameLabel;
@property (nonatomic) CLLocationCoordinate2D currentLocationCoordinate;

@end
