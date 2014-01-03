//
//  SettingsFoursquareViewController.m
//  Snpptz
//
//  Created by David Wang on 7/2/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import "SettingsFoursquareViewController.h"
#import "SnpptzAPI.h"

@implementation SettingsFoursquareViewController

#pragma mark -
#pragma mark View Controller LifeCycle

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeKeyboard) name:@"displayError" object:nil];
	
	UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 63, 30)];
	[backButton setImage:[UIImage imageNamed:@"back-icon.png"] forState:UIControlStateNormal];
	[backButton	addTarget:self action:@selector(closeWindow) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
	
	self.navigationItem.leftBarButtonItem = leftBarButtonItem;
	
	// clean up
	[backButton release];
	[leftBarButtonItem release];
	
}

- (void) didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"SettingsAboutTableViewController memory warning");
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

#pragma mark -
#pragma mark IBActions/Methods


- (void) closeWindow
{
	[self.navigationController popViewControllerAnimated:YES]; 
}

- (void) animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = 140; // tweak as needed
    const float movementDuration = 0.35f; // tweak as needed
	
    int movement = (up ? -movementDistance : movementDistance);
	
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    movableView.frame = CGRectOffset(movableView.frame, 0, movement);
    [UIView commitAnimations];
	
	UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 63, 30)];
	[cancelButton setImage:[UIImage imageNamed:@"cancel-icon.png"] forState:UIControlStateNormal];
	[cancelButton	addTarget:self action:@selector(closeKeyboard) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];

	self.navigationItem.rightBarButtonItem = rightBarButtonItem;
	
	// cleanup
	[cancelButton release];
	[rightBarButtonItem release];
	
}

- (void) closeKeyboard
{
	[usernameField resignFirstResponder];
	[passwordField resignFirstResponder];
	self.navigationItem.rightBarButtonItem = nil;
	
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
	spinner.frame = CGRectMake(145, 14, 15, 15);
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
	[errorArray release];
	
}

- (void) executeLogin
{
	NSAutoreleasePool *wadingPool = [[NSAutoreleasePool alloc] init];
	
	NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
	NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
	NSNumber *geoserviceId = [[NSNumber	alloc] initWithInt:1];
	
	
	Boolean statusInfo = [SnpptzAPI geoserviceLogin:username 
											 withPassword:password 
									  withServiceUsername:usernameField.text 
									  withServicePassword:passwordField.text
										 withGeoserviceId:geoserviceId];
	//NSLog(@"statusInfo: %@", statusInfo);
	
	if (statusInfo)
	{		
		[self performSelectorOnMainThread:@selector(successfulLogin) withObject:nil waitUntilDone:YES];		
	}
	[geoserviceId release];
	[wadingPool release];
}

- (void)successfulLogin
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Account Linked" 
													message:@"Your Foursquare account has been connected." 
												   delegate:self 
										  cancelButtonTitle:nil 
										  otherButtonTitles:@"Ok", nil ];
	[alert show];
	[alert release];
	[self closeKeyboard];
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc 
{
    [super dealloc];
	[myUsername release];
	[myPassword release];
	[usernameField release];
	[passwordField release];
	[movableView release];
}


@end
