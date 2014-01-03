//
//  iCodeBrowserViewController.m
//  iCodeBrowser
//
//  Created by Brandon Trebitowski on 12/19/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "WebBrowserViewController.h"

@implementation WebBrowserViewController

@synthesize webView, addressBar, activityIndicator, urlAddress;

#pragma mark -
#pragma mark View Controller Stuff

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	NSURL *url = [NSURL URLWithString:self.urlAddress];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	[webView loadRequest:requestObj];
	[addressBar setText:urlAddress];
	
	UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 63, 30)];
	[backButton setImage:[UIImage imageNamed:@"back-icon.png"] forState:UIControlStateNormal];
	[backButton	addTarget:self action:@selector(closeBrowser) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
	
	self.navigationItem.leftBarButtonItem = leftBarButtonItem;
	
	// cleanup
	[backButton release];
	[leftBarButtonItem release];
	
}

- (void) didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; 
	NSLog(@"WebBrowserViewController memory warning");
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL) webView:(UIWebView*) webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType 
{
	//CAPTURE USER LINK-CLICK.
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		NSURL *URL = [request URL];	
		if ([[URL scheme] isEqualToString:@"http"]) {
			[addressBar setText:[URL absoluteString]];
			[self gotoAddress:nil];
		}	 
		return NO;
	}	
	return YES;   
}

- (void) webViewDidStartLoad:(UIWebView *)webView 
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[activityIndicator startAnimating];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView 
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[activityIndicator stopAnimating];
}


#pragma mark -
#pragma mark IBActions

- (void) closeBrowser
{
	[self.navigationController popViewControllerAnimated:YES]; 
}

- (IBAction) goBack:(id)sender 
{
	[webView goBack];
}

- (IBAction) goForward:(id)sender 
{
	[webView goForward];
}

- (IBAction) gotoAddress:(id) sender {
	NSURL *url = [NSURL URLWithString:[addressBar text]];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	//Load the request in the UIWebView.
	[webView loadRequest:requestObj];
	[addressBar resignFirstResponder];
}

#pragma mark -
#pragma mark dealloc

- (void) dealloc 
{
    [super dealloc];
	[webView release];
	[addressBar release];
	[activityIndicator release];
	[urlAddress release];
}

@end
