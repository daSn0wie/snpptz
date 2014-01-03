//
//  RegisterViewController.m
//  Snpptz
//
//  Created by David Wang on 6/5/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import "RegisterViewController.h"
#import "SnpptzAPI.h"

@implementation RegisterViewController


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetForm) name:@"displayError" object:nil];
	
	self.navigationItem.title = @"";
	
	UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 63, 30)];
	[backButton setImage:[UIImage imageNamed:@"back-icon.png"] forState:UIControlStateNormal];
	[backButton	addTarget:self action:@selector(closeRegisterScreen) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
	
	self.navigationController.navigationBar.hidden = FALSE;
	self.navigationItem.leftBarButtonItem = leftBarButtonItem;
	
	hasCancel = FALSE;
	
	[joinButton setTitle: @"Join" forState: UIControlStateNormal];
	[joinButton setTitle: @"" forState: UIControlStateDisabled];
	
	// cleanup
	[backButton release];
	[leftBarButtonItem release];
}

- (void) didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"RegisterViewController memory warning");
}

- (void)resetForm
{
	[[joinButton viewWithTag:83838383] removeFromSuperview];
	joinButton.enabled = YES;
}

- (void)closeRegisterScreen
{
	self.navigationController.navigationBar.hidden = TRUE;
	[self.navigationController popViewControllerAnimated:YES]; 
}

- (IBAction)displayCancel
{
	if (!hasCancel)
	{
		UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 63, 30)];
		[cancelButton setImage:[UIImage imageNamed:@"cancel-icon.png"] forState:UIControlStateNormal];
		[cancelButton	addTarget:self action:@selector(closeKeyboard) forControlEvents:UIControlEventTouchUpInside];
		
		UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
		
		self.navigationItem.rightBarButtonItem = rightBarButtonItem;
		hasCancel = TRUE;
		
		//cleanup
		[cancelButton release];
		[rightBarButtonItem release];
	}
}

- (IBAction) setUserName:(id) sender
{
	[passwordField becomeFirstResponder];	
}

- (IBAction) setPassword:(id) sender
{
	[emailField becomeFirstResponder];
}

- (IBAction) setEmail:(id) sender
{
	[emailField resignFirstResponder];
	[self registerUser];
}

- (IBAction) registerUser
{
	[self sendRegistration];
}

- (void) sendRegistration
{
	[self closeKeyboard];
	
	joinButton.enabled = NO;

	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	spinner.frame = CGRectMake(144, 14, 15, 15);
	spinner.tag = 83838383;
	[spinner startAnimating];
	
	[joinButton addSubview:spinner];
	
	[spinner release];
	
	Boolean email = TRUE;
	Boolean password = TRUE;
	Boolean username = TRUE;
	NSMutableArray *errorArray = [[NSMutableArray alloc] init];
	
	if (![self validateEmail:emailField.text])
	{
		email = FALSE;
		[errorArray addObject:@"Please check your email address."];
	}
	
	if (emailField.text.length < 4)
	{
		email = FALSE;
		[errorArray addObject:@"Email must be 4+ chars"];
	}
	
	if (passwordField.text.length < 5)
	{
		password = FALSE;
		[errorArray addObject:@"Password must be 5+ chars."];
	}
	
	if (![self validateUsername:usernameField.text])
	{
		username = FALSE;
		[errorArray addObject:@"Invalid username (only a-z 0-9 - _)"];
	}
	
	if (usernameField.text.length < 4) 
	{
		username = FALSE;
		[errorArray addObject:@"Username must be 4+ chars."];
	}
	
	
	
	if (email && password && username)
	{
		[NSThread detachNewThreadSelector:@selector(attemptRegistration) toTarget:self withObject:nil];
	}
	else 
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Failed" 
														message:[[NSArray arrayWithArray:errorArray] componentsJoinedByString:@"\n"]
													   delegate:self 
											  cancelButtonTitle:nil 
											  otherButtonTitles:@"Ok", nil ];
		[alert show];
		[alert release];
		[self resetForm];
	}
	
	[errorArray release];
}

- (BOOL) validateEmail: (NSString *) candidate 
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
	
    return [emailTest evaluateWithObject:candidate];
}

- (BOOL) validateUsername: (NSString *) candidate
{
	NSString *emailRegex = @"[A-Z0-9a-z_-]+";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
	
    return [emailTest evaluateWithObject:candidate];
}

- (void) attemptRegistration
{
	NSAutoreleasePool *wadingPool = [[NSAutoreleasePool alloc] init];
	
	NSDictionary *userInfo = [SnpptzAPI registerUser:usernameField.text withPassword:passwordField.text withEmail:emailField.text];
	NSLog(@"userinfo: %@", userInfo);
	
	if ([userInfo valueForKey:@"username"])
	{		
		[self performSelectorOnMainThread:@selector(successfulRegistration) withObject:nil waitUntilDone:YES];		
	}
		
	[wadingPool release];
}
		 
- (void) successfulRegistration
{
	myPassword = passwordField.text;
	myUsername = usernameField.text;
	
	[self.navigationController.view removeFromSuperview];
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:myPassword forKey:@"password"];
	[prefs setObject:myUsername	forKey:@"username"];	
	[prefs setBool:TRUE forKey:@"hasAuthenticationInfo"];
	
	// Notify interested parties that the settings have changed
	[[NSNotificationCenter defaultCenter] postNotificationName:@"settingsSaved" object:nil];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome to Snpptz" 
													message:@"Start by searching for something your interested in."
												   delegate:self 
										  cancelButtonTitle:nil 
										  otherButtonTitles:@"Ok", nil ];
	[alert show];
	[alert release];
}

- (void) closeKeyboard
{
	[usernameField resignFirstResponder];
	[passwordField resignFirstResponder];
	[emailField resignFirstResponder];
	
	self.navigationItem.rightBarButtonItem = nil;
	hasCancel = FALSE;
}
	 
#pragma mark -

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	int length;
	
	switch (textField.tag)
	{
		//username
		case 1:
			length = 15;
			break;
		//password
		case 2:
			length = 42;
			break;
		//email
		case 3:
			length = 127;
			break;
		//default
		default:
			length = 20;
			break;
	}
	
    if (textField.text.length >= length && range.length == 0)
    {
        return NO; // return NO to not change text
    }
    else
    {
		return YES;
	}
}





- (void)dealloc 
{
    [super dealloc];
	[myUsername release];
	[myPassword release];
	[myEmail release];
	
	[usernameField release];
	[passwordField release];
	[emailField release];
}


@end
