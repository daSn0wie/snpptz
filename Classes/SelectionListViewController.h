//
//  SelectionListViewController.h
//  Snpptz
//
//  Created by David Wang on 6/15/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectionListViewControllerDelegate <NSObject>
@required
- (void)finishedSelections;
@end

@interface SelectionListViewController : UITableViewController 
{
    NSArray         *list;
    NSMutableArray  *unselectedBlogIds;    
    id <SelectionListViewControllerDelegate>    delegate;
}

@property (nonatomic, retain) NSArray *list;
@property (nonatomic, retain) NSMutableArray *unselectedBlogIds;
@property (nonatomic, assign) id <SelectionListViewControllerDelegate> delegate;
@end
