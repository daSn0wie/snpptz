    //
//  FindViewController.m
//  Snpptz
//
//  Created by David Wang on 5/21/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import "FindNavigationController.h"
#import "FindSearchViewController.h"

@implementation FindNavigationController

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	//contacts
	findSearchView = [[FindSearchViewController alloc] initWithNibName:@"FindSearchView" bundle:nil];
	findSearchView.title = @"Find";	
	
	[self pushViewController:findSearchView animated:NO];

}

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"FindNavigationController memory warning");
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc 
{
    [super dealloc];
	[findSearchView release];
}


@end
