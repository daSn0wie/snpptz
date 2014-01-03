//
//  SettingsListViewController.h
//  Snpptz
//
//  Created by David Wang on 5/21/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface SettingsListViewController : UITableViewController <UITableViewDelegate, MFMailComposeViewControllerDelegate> {
	NSArray *sections;
	NSArray *sectionTitles;
	NSArray *connectionIndex;
	NSArray *accountIndex;
	IBOutlet UITableView *myTableView;
}

- (void) presentEmail;

@end
