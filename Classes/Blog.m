//
//  Feed.m
//  Snpptz
//
//  Created by David Wang on 5/22/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import "Blog.h"
#import "DataFetcher.h"
#import "SnpptzAPI.h"

@implementation Blog

@dynamic blogID, name, slug, website, isFollowing, blogDescription, smallIcon, largeIcon, smallIconImage, 
		 largeIconImage, isSmallIconImageAvailable, isLargeIconImageAvailable;

+ (Blog *) createBlog:(NSDictionary *) blogInfo isFollowing:(BOOL) following
{
	DataFetcher *fetcher = [DataFetcher sharedInstance];
	NSManagedObjectContext *context = [fetcher managedObjectContext];
	
	Blog *managedBlog = [NSEntityDescription insertNewObjectForEntityForName:@"Blog" inManagedObjectContext:context];
	managedBlog.blogID = [blogInfo valueForKey:@"id"];
	managedBlog.name = [blogInfo valueForKey:@"name"];
	managedBlog.slug = [blogInfo valueForKey:@"slug"];
	managedBlog.website = [[blogInfo valueForKey:@"website"] isKindOfClass:[NSString class]] ?[blogInfo valueForKey:@"website"] :  @"" ;
	managedBlog.blogDescription = [[blogInfo valueForKey:@"description"] isKindOfClass:[NSString class]] ?[blogInfo valueForKey:@"description"] :  @"I haven't filled out my description yet :(" ;
	managedBlog.isFollowing = [NSNumber numberWithBool:following];
	managedBlog.smallIcon =  [[blogInfo valueForKey:@"small_icon"] isKindOfClass:[NSString class]] ? [blogInfo valueForKey:@"small_icon"] : @"" ;
	managedBlog.largeIcon = [[blogInfo valueForKey:@"large_icon"] isKindOfClass:[NSString class]] ? [blogInfo valueForKey:@"large_icon"] : @"" ;
	managedBlog.isSmallIconImageAvailable = [NSNumber numberWithBool:FALSE];
	managedBlog.isLargeIconImageAvailable = [NSNumber numberWithBool:FALSE];
	
	if (![managedBlog.smallIcon isEqualToString:@""])
	{
		NSLog(@"starting thread for small icon: %@", managedBlog.smallIcon);	
		[NSThread detachNewThreadSelector:@selector(downloadSmallIcon:) toTarget:managedBlog withObject:managedBlog];
	}
	else 
	{
		NSLog(@"blog default small icon: %@", managedBlog.name);	
		
		UIImage *img = [UIImage imageNamed:@"default-small-icon.png"];
		NSData *dataObj = UIImagePNGRepresentation(img);
		
		managedBlog.smallIconImage = [NSMutableData dataWithData: dataObj];
		managedBlog.isSmallIconImageAvailable = [NSNumber numberWithBool:TRUE];
	}
	
	if (![managedBlog.largeIcon isEqualToString:@""])
	{
		NSLog(@"starting thread for large icon: %@", managedBlog.largeIcon);	
		[NSThread detachNewThreadSelector:@selector(downloadLargeIcon:) toTarget:managedBlog withObject:managedBlog];
	}
	else 
	{
		NSLog(@"blog default large icon: %@", managedBlog.name);	
		
		UIImage *img = [UIImage imageNamed:@"default-large-icon.png"];
		NSData *dataObj = UIImagePNGRepresentation(img);
		
		managedBlog.largeIconImage = [NSMutableData dataWithData: dataObj];
		managedBlog.isLargeIconImageAvailable = [NSNumber numberWithBool:TRUE];
	}
	
	return managedBlog;
}
	
- (void) downloadSmallIcon: (Blog *) blog
{
	NSAutoreleasePool *wadingPool = [[NSAutoreleasePool alloc] init];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	NSURL *url = [NSURL URLWithString:blog.smallIcon];
	NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
	[urlRequest setHTTPShouldHandleCookies:NO];
	
	// Get the contents of the URL as a string, and parse the JSON into Foundation objects.
	NSURLResponse *connectionResponse;
	NSError *error;
	NSMutableData *responseData = [[NSMutableData alloc] initWithData:[NSURLConnection sendSynchronousRequest:urlRequest 
																							returningResponse:&connectionResponse 
																										error:&error]];
	NSLog(@"downloading %@ small icon", blog.name);
	if (!connectionResponse) 
	{
		NSLog(@"bad small icon download... using default");
		blog.smallIconImage = [NSData dataWithContentsOfFile:@"default-small-icon.png"];
	}
	else 
	{
		NSLog(@"good small icon download... using %@", blog.smallIcon);
		blog.smallIconImage = [NSData dataWithData:responseData];
	}
	
	blog.isSmallIconImageAvailable = [NSNumber numberWithBool:TRUE];
	
	[urlRequest release];
	[responseData release];
	[wadingPool release];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void) downloadLargeIcon: (Blog *) blog
{
	NSAutoreleasePool *wadingPool = [[NSAutoreleasePool alloc] init];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	NSURL *url = [NSURL URLWithString:blog.largeIcon];
	NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
	[urlRequest setHTTPShouldHandleCookies:NO];
	
	// Get the contents of the URL as a string, and parse the JSON into Foundation objects.
	NSURLResponse *connectionResponse;
	NSError *error;
	NSMutableData *responseData = [[NSMutableData alloc] initWithData:[NSURLConnection sendSynchronousRequest:urlRequest 
																							returningResponse:&connectionResponse 
																										error:&error]];
	NSLog(@"downloading %@ large icon", blog.name);
	if (!connectionResponse) 
	{
		NSLog(@"bad large icon download... using default");
		blog.largeIconImage = [NSData dataWithContentsOfFile:@"default-large-icon.png"];
	}
	else 
	{
		NSLog(@"good large icon download... using %@", blog.largeIcon);
		blog.largeIconImage = [NSData dataWithData:responseData];
	}
	
	blog.isLargeIconImageAvailable = [NSNumber numberWithBool:TRUE];

	[urlRequest release];
	[responseData release];
	[wadingPool release];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (NSString *) description
{
	return self.name;
}

@end
