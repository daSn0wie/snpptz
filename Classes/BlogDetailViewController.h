//
//  UserDetailViewController.h
//  Snpptz
//
//  Created by David Wang on 6/15/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Blog.h"
#import "SnipsViewController.h";


@interface BlogDetailViewController : UIViewController <CLLocationManagerDelegate>
{
	Blog *blog;
	IBOutlet UILabel *usernameLabel;
	IBOutlet UILabel *snipCountLabel;
	IBOutlet UILabel *bioLabel;
	IBOutlet UILabel *aboutLabel;
	IBOutlet UIImageView *iconImageView;
	UIImageView *bioImageView;
	CLLocationManager *locationManager;
	UINavigationController *currentNavigationController;
	SnipsViewController *snipsViewController;
	IBOutlet UIButton *submitButton;
}


@property (nonatomic, retain) Blog *blog;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) UINavigationController *currentNavigationController;

- (IBAction) showSnips: (id) sender;
- (IBAction) toggleBlog: (id) sender;

@end
