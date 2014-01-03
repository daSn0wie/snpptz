//
//  LoadingScreenViewController.m
//  Snpptz
//
//  Created by David Wang on 5/24/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import "LoadingScreenViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation LoadingScreenViewController

- (void) didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	NSLog(@"TODO:  LoadingScreenViewController - memory warning");
}

- (void) dealloc
{
	[super dealloc];
	[indicator release];
}

@end
