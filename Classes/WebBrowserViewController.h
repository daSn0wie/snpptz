//
//  WebBrowserViewController.h
//  Snpptz
//
//  Created by David Wang on 6/15/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebBrowserViewController : UIViewController<UIWebViewDelegate> {
	IBOutlet UIWebView *webView;
	IBOutlet UITextField *addressBar;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	NSString *urlAddress;
}

@property(nonatomic, retain) NSString * urlAddress;
@property(nonatomic,retain) UIWebView *webView;
@property(nonatomic,retain) UITextField *addressBar;
@property(nonatomic,retain) UIActivityIndicatorView *activityIndicator;

-(IBAction) gotoAddress:(id)sender;
-(IBAction) goBack:(id)sender;
-(IBAction) goForward:(id)sender;

@end
