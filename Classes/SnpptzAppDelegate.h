//
//  SnpptzAppDelegate.h
//  Snpptz
//
//  Created by David Wang on 5/20/10.
//  Copyright UDFI, LLC 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnpptzTabBarController.h"
#import "SnpptzAccessNavigationController.h"
#import "LoadingScreenViewController.h"

@interface SnpptzAppDelegate : NSObject <UIApplicationDelegate, UIAlertViewDelegate> {
    UIWindow *window;
    SnpptzTabBarController *tabBarController;
	SnpptzAccessNavigationController *accessController;
	NSUserDefaults *prefs;
	LoadingScreenViewController *loadingController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SnpptzTabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet SnpptzAccessNavigationController *accessController;

- (void)loadFollowing;
- (void)changeToLogin;
- (void)changeToMain;

@end
