//
//  FindSearchViewController.h
//  Snpptz
//
//  Created by David Wang on 7/1/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlogTableViewController.h"

@interface FindSearchViewController : UIViewController <UISearchBarDelegate> 
{
	IBOutlet UISearchBar *searchBar;
	BlogTableViewController *blogTableViewController;
	NSString *searchTerm;
}

- (void) loadList;
- (void) reloadTheTable:(NSNumber *) count;

@end
