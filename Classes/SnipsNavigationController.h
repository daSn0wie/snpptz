//
//  FirstViewController.h
//  Snpptz
//
//  Created by David Wang on 5/20/10.
//  Copyright UDFI, LLC 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SnipsMapViewController.h"
#import "LoadingScreenViewController.h"
#import "SelectionListViewController.h"

@interface SnipsNavigationController : UINavigationController <UINavigationControllerDelegate, SelectionListViewControllerDelegate>	
{
	SnipsMapViewController *snipsMap;
	LoadingScreenViewController *snipsLoading;
}

@property (nonatomic, retain) SnipsMapViewController *snipsMap;
@property (nonatomic, retain) LoadingScreenViewController *snipsLoading;


- (void) presentLoadingScreen;
- (void) presentMapViewController;

@end
