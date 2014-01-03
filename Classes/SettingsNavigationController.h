//
//  SettingsViewController.h
//  Snpptz
//
//  Created by David Wang on 5/21/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsListViewController.h"

@interface SettingsNavigationController : UINavigationController <UINavigationControllerDelegate> 
{
	SettingsListViewController *settingsList;
}

@end
