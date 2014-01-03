//
//  FindViewController.h
//  Snpptz
//
//  Created by David Wang on 5/21/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindSearchViewController.h"

@interface FindNavigationController : UINavigationController <UINavigationControllerDelegate> 
{
	FindSearchViewController *findSearchView;
}

@end
