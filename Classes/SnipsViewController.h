//
//  SnipsViewController.h
//  Snpptz
//
//  Created by David Wang on 7/16/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnipsTableViewController.h"

@interface SnipsViewController : UIViewController 
{
	IBOutlet SnipsTableViewController *snipsTableViewController;
}

@property (nonatomic, retain) SnipsTableViewController *snipsTableViewController;

@end
