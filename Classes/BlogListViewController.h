//
//  PublishersListViewController.h
//  Snpptz
//
//  Created by David Wang on 5/21/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BlogListViewController : UITableViewController <UITableViewDelegate> 
{
	NSMutableArray *listOfBlogs;
}

@property (nonatomic, retain) NSMutableArray *listOfBlogs;

- (void) loadList;

@end
