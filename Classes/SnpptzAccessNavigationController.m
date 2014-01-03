    //
//  SnpptzAccessNavigationController.m
//  Snpptz
//
//  Created by David Wang on 6/5/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import "SnpptzAccessNavigationController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"

@implementation SnpptzAccessNavigationController

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	self.navigationBar.hidden = YES;
	LoginViewController *loginController = [[LoginViewController alloc] initWithNibName:@"LoginView" bundle:nil];
	[self pushViewController:loginController animated:YES];
	
	[loginController release];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	NSLog(@"SnpptzAccessNavigationController");
	
}

- (void)dealloc {
    [super dealloc];
}

@end
