//
//  SnpptzAppDelegate.m
//  Snpptz
//
//  Created by David Wang on 5/20/10.
//  Copyright UDFI, LLC 2010. All rights reserved.
//

#import "SnpptzAppDelegate.h"
#import "DataFetcher.h"
#import "SnpptzAPI.h"
#import "Blog.h"
#import <QuartzCore/QuartzCore.h>


@implementation UINavigationBar (CustomImage)
- (void)drawRect:(CGRect)rect {
	UIImage *image = [UIImage imageNamed: @"navigation-bar.png"];
	[image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];

}
@end

@implementation SnpptzAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize accessController;

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	NSLog(@"awaken... should reload data");
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *) deviceToken
{	
	if (![[NSUserDefaults standardUserDefaults] boolForKey:@"deviceTokenSet"])
	{
		
		NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
		NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
		
		[SnpptzAPI addUserDeviceToken:deviceToken withUserName:username withPassword:password];
		
		[[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"deviceTokenSet"];
	}
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error
{
	NSLog(@"TODO:  Error in delegate didFailToRegisterForRemoteNotificationsWithError. Need to handle this still: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
	NSLog(@"TODO:  delegate didReceiveRemoteNotification. Need to handle this still");
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{   
	// listen for status change from children subviews
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeToMain) name:@"settingsSaved" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedLoading) name:@"finishedLoading" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeToLogin) name:@"loginFailed" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:@"logout" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayError:) name:@"displayError" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadPause) name:@"loadPause" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closePause) name:@"closePause" object:nil];
	
	[application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
	
	
	if (![[NSUserDefaults standardUserDefaults] boolForKey:@"ranSetup"])
	{
		// this should probably be under isFirstRun or something
		UIRemoteNotificationType types = UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;
		[application registerForRemoteNotificationTypes:types];
		
		// this should probably be under isFirstRun or something
		DataFetcher *dataFetcher = [DataFetcher sharedInstance];
		if (![dataFetcher databaseExists]) [dataFetcher managedObjectContext];
		
		[[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"ranSetup"];
	}
	
	// is logged in?
	if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasAuthenticationInfo"])
	{
		[self changeToLogin];
	}
	else {
		[self changeToMain];
	}
	
	[window makeKeyAndVisible];
	
	return YES;
}

#pragma mark -
#pragma mark Custom Functions 

- (void)displayError:(NSNotification *)notification
{
	NSDictionary *userInfo = [notification userInfo];
	NSString *title = [userInfo valueForKey:@"title"];
	NSString *message = [userInfo valueForKey:@"message"];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title 
													message:message 
												   delegate:self 
										  cancelButtonTitle:nil 
										  otherButtonTitles:@"Ok", nil ];
	[alert show];
	[alert release];
}

- (void)logout
{
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"hasAuthenticationInfo"];
	
	[window addSubview:accessController.view];
}

- (void)changeToLogin
{
	[window addSubview:accessController.view];
}

- (void) loadFollowing
{	
	// this is called from a different thread typically
	NSAutoreleasePool *wadingPool = [[NSAutoreleasePool alloc] init];
	
	// get username and password settings
	NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
	NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
	
	// get the blogs
	NSArray *blogs = [SnpptzAPI followingForUser:username withPassword:password];
	
	// fetch users from DB
	DataFetcher *fetcher = [DataFetcher sharedInstance];
	
	for(NSDictionary *blogInfo in blogs)
	{
		// does the snip exist?
		NSLog(@"userinfo id : %@", [blogInfo valueForKey:@"id"]);
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(blogID == %@)", [blogInfo valueForKey:@"id"]];		
		NSArray *blogArray =  [fetcher fetchManagedObjectsForEntity:@"Blog" withPredicate:predicate];
		
		if (blogArray.count == 0)
		{	
			[Blog createBlog:blogInfo isFollowing:YES];
		}
	}
	
	// cleanup
	[wadingPool release];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"finishedLoading" object:nil];
}

- (void)changeToMain

{	
	[accessController.view removeFromSuperview];
	loadingController = [[LoadingScreenViewController alloc] initWithNibName:@"LoadingScreenView" bundle:nil];
	
	[window addSubview:loadingController.view];
	
	CATransition *animation = [CATransition animation];
	[animation setDuration:0.5];
	[animation setType:kCATransitionPush];
	[animation setSubtype:kCATransitionFromLeft];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	
	[[window layer] addAnimation:animation forKey:@"SwitchToView1"];	

	[self loadFollowing];
}

- (void)finishedLoading
{
	[loadingController.view removeFromSuperview];
	
	CATransition *animation = [CATransition animation];
	[animation setDuration:0.5];
	[animation setType:kCATransitionPush];
	[animation setSubtype:kCATransitionFromRight];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	
	// set the delegate programatically since we can't access it via IB
	tabBarController.delegate = self.tabBarController;
	
	// Add the tab bar controller's current view as a subview of the window
	[window addSubview:tabBarController.view];
}
	
- (void) loadPause
{
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,320, 480)];
	view.backgroundColor = [UIColor blackColor];
	view.tag = 929393234;
	view.alpha = 0.7;
						
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(145,225,30,30)];
	spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
	[spinner startAnimating];
	
	[view addSubview:spinner];
	
	[window addSubview:view];
}

- (void) closePause
{
	[[window viewWithTag:929393234] removeFromSuperview];
}


- (void)dealloc {
    [tabBarController release];
	[accessController release];
    [window release];
    [super dealloc];
}

@end

