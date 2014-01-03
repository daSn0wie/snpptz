//
//  LoginViewController.m
//  Snpptz
//
//  Created by David Wang on 6/5/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "SnpptzAccessNavigationController.h"
#import "SnpptzAPI.h"

@implementation LoginViewController

- (void) viewDidLoad
{
	[super viewDidLoad];
	self.navigationItem.title = @"";
	[loginButton setTitle: @"Sign In" forState: UIControlStateNormal];
	[loginButton setTitle: @"" forState: UIControlStateDisabled];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeKeyboard) name:@"displayError" object:nil];
}

- (void) didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"LoginViewController memory warning");
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
	registerButton.enabled = NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
	registerButton.enabled = NO;
}

- (void) animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = 160; // tweak as needed
    const float movementDuration = 0.35f; // tweak as needed
	
    int movement = (up ? -movementDistance : movementDistance);
	
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
	
	UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 63, 30)];
	[cancelButton setImage:[UIImage imageNamed:@"cancel-icon.png"] forState:UIControlStateNormal];
	[cancelButton	addTarget:self action:@selector(closeKeyboard) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
	
	self.navigationController.navigationBar.hidden = FALSE;
	self.navigationItem.rightBarButtonItem = rightBarButtonItem;
	
	// cleanup
	[cancelButton release];
	[rightBarButtonItem release];
	
}

- (void) loadRegisterScreen
{
	RegisterViewController *registerViewController = [[RegisterViewController alloc] initWithNibName:@"RegisterView" bundle:nil];

	[self.navigationController pushViewController:registerViewController animated:YES];
	
	// cleanup
	[registerViewController release];
}

- (void) closeKeyboard
{
	[usernameField resignFirstResponder];
	[passwordField resignFirstResponder];
	self.navigationController.navigationBar.hidden = TRUE;
	registerButton.enabled = YES;
	
	[[loginButton viewWithTag:83838383] removeFromSuperview];
	loginButton.enabled = YES;
}

- (IBAction) setUserName:(id) sender
{
	[passwordField becomeFirstResponder];	
}

- (IBAction) setPassword:(id) sender
{
	[passwordField resignFirstResponder];
	[self goLogin];
}

- (IBAction) attemptLogin:(id) sender
{
	[passwordField resignFirstResponder];
	[self goLogin];
}

- (void) goLogin
{
	loginButton.enabled = NO;
	
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	spinner.frame = CGRectMake(120, 14, 15, 15);
	spinner.tag = 83838383;
	[spinner startAnimating];
	
	[loginButton addSubview:spinner];
	
	[spinner release];
	
	Boolean password = TRUE;
	Boolean username = TRUE;
	NSMutableArray *errorArray = [[NSMutableArray alloc] init];
	
	if (passwordField.text.length == 0)
	{
		password = FALSE;
		[errorArray addObject:@"Password is blank."];
	}
	
	if (usernameField.text.length == 0) 
	{
		username = FALSE;
		[errorArray addObject:@"Username is blank."];
	}
	

	
	if (password && username)
	{
		[NSThread detachNewThreadSelector:@selector(executeLogin) toTarget:self withObject:nil];
	}
	else 
	{

		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed" 
														message:[[NSArray arrayWithArray:errorArray] componentsJoinedByString:@"\n"]
													   delegate:self 
											  cancelButtonTitle:nil 
											  otherButtonTitles:@"Ok", nil ];
		[alert show];
		[alert release];
		
		[self closeKeyboard];
	}
	
	// cleanup
	[errorArray release];
}

- (void) executeLogin
{
	NSAutoreleasePool *wadingPool = [[NSAutoreleasePool alloc] init];
	
	NSDictionary *userInfo = [SnpptzAPI loginUser:usernameField.text withPassword:passwordField.text];
	NSLog(@"userinfo: %@", userInfo);
	
	if ([userInfo valueForKey:@"username"])
	{		
		[self performSelectorOnMainThread:@selector(successfulLogin) withObject:nil waitUntilDone:YES];		
	}
	
	[wadingPool release];
}

- (void)successfulLogin
{
	 myPassword = passwordField.text;
	 myUsername = usernameField.text;
	 
	 NSLog(@"attempting login with %@ : %@", myUsername, myPassword);
	 
	 [self.navigationController.view removeFromSuperview];
	 
	 NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	 [prefs setObject:myPassword forKey:@"password"];
	 [prefs setObject:myUsername forKey:@"username"];	
	 [prefs setBool:TRUE forKey:@"hasAuthenticationInfo"];
	 
	 // Notify interested parties that the settings have changed
	 [[NSNotificationCenter defaultCenter] postNotificationName:@"settingsSaved" object:nil];
	
}

- (void)dealloc 
{
    [super dealloc];
	
	[usernameField release];
	[passwordField release];
	
	[myUsername release];
	[myPassword release];

}


@end
