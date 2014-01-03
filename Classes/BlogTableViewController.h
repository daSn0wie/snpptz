//
//  FindPublishersViewController.h
//  Snpptz
//
//  Created by David Wang on 5/21/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlogTableViewController : UITableViewController <UITableViewDelegate, UISearchBarDelegate> {
	
	NSString *searchTerm;
	NSMutableArray *listOfBlogs;
	UISearchBar *searchBar;
	UINavigationController *currentNavigationController;
	Boolean showSpinner;
	Boolean showNoResults;
}

@property (nonatomic, retain) NSMutableArray *listOfBlogs;
@property (nonatomic, retain) NSString *searchTerm;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) UINavigationController *currentNavigationController;
@property (nonatomic) Boolean showSpinner;
@property (nonatomic) Boolean showNoResults;

@end
