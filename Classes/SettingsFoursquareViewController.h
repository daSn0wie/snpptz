//
//  SettingsFoursquareViewController.h
//  Snpptz
//
//  Created by David Wang on 7/2/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsFoursquareViewController : UIViewController <UITextFieldDelegate> {
	NSString *myUsername;
	NSString *myPassword;
	IBOutlet UITextField *usernameField;
	IBOutlet UITextField *passwordField;
	IBOutlet UIView *movableView;
	IBOutlet UIButton *loginButton;
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up;
- (IBAction) setUserName:(id) sender;
- (IBAction) setPassword:(id) sender;
- (IBAction) attemptLogin:(id) sender;
- (void) goLogin;
- (void) closeKeyboard;

@end
