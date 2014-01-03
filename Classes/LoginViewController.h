//
//  LoginViewController.h
//  Snpptz
//
//  Created by David Wang on 6/5/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginViewController : UIViewController <UITextFieldDelegate> {
	NSString *myUsername;
	NSString *myPassword;
	IBOutlet UITextField *usernameField;
	IBOutlet UITextField *passwordField;
	IBOutlet UIButton *registerButton;
	IBOutlet UIButton *loginButton;
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up;
- (IBAction) setUserName:(id) sender;
- (IBAction) setPassword:(id) sender;
- (IBAction) attemptLogin:(id) sender;
- (IBAction) loadRegisterScreen;
- (void) goLogin;
- (void) closeKeyboard;

@end
