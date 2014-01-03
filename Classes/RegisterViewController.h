//
//  RegisterViewController.h
//  Snpptz
//
//  Created by David Wang on 6/5/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RegisterViewController : UIViewController <UITextFieldDelegate>
{
	NSString *myUsername;
	NSString *myPassword;
	NSString *myEmail;
	bool hasCancel;
	
	IBOutlet UITextField *usernameField;
	IBOutlet UITextField *passwordField;
	IBOutlet UITextField *emailField;
	
	IBOutlet UIButton *joinButton;
}

- (IBAction) displayCancel;
- (IBAction) setUserName:(id) sender;
- (IBAction) setPassword:(id) sender;
- (IBAction) setEmail:(id) sender;
- (IBAction) sendRegistration;
- (void) registerUser;
- (void) closeKeyboard;
- (BOOL) validateEmail: (NSString *) candidate;
- (BOOL) validateUsername: (NSString *) candidate;
@end
