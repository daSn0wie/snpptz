//
//  SnpptzAPI.m
//  Snpptz
//
//  Created by David Wang on 6/27/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import "SnpptzAPI.h"
#import "JSON.h"
#import <CommonCrypto/CommonDigest.h>

@implementation SnpptzAPI

#pragma mark Snpptz API Access

+ (NSArray *) searchForUsers:(NSString *) searchTerm withUsername:(NSString *) username withPassword:(NSString *) password
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	// test slow network
	#if TEST_HIGH_NETWORK_LATENCY
		sleep(1);
	#endif
	
	// url encode the search term
	NSString * encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)searchTerm,NULL,(CFStringRef)@"!*’();:@&=+$,/?%#[]",kCFStringEncodingUTF8 );
	
	// Construct the request.
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/v1/blogs/search.json?search=%@", API_SERVER, encodedString]];

	// setup the mutable urlrequest object
	NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
	[urlRequest setHTTPShouldHandleCookies:NO];
	[urlRequest addValue:[SnpptzAPI encodeBase64Username:username andPassword:password] forHTTPHeaderField:@"Authorization"];
	
	// Get the contents of the URL as a string, and parse the JSON into Foundation objects.
	NSURLResponse *connectionResponse;
	NSError *error;
	NSMutableData *responseData = [[NSMutableData alloc] initWithData:[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&connectionResponse error:&error]];
	
	if (!connectionResponse) {
		NSLog(@"Failed to submit request for following. error: %@", error);
	} 
	
	// create the json value
	NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
	
	// debug
	NSLog(@"search  data: %@", jsonString);
	
	// get the results 
	NSDictionary *results = [jsonString JSONValue];
	
	// dealloc 
	[encodedString release];
	[urlRequest release];
	[responseData release];
	[jsonString release];

	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	// Now we need to dig through the resulting objects.
	// Read the documentation and make liberal use of the debugger or logs.
	
	return [[results objectForKey:@"searchresults"] objectForKey:@"blog"];
}

+ (NSArray *)followingForUser:(NSString *) username withPassword:(NSString *) password
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	// test slow network
	#if TEST_HIGH_NETWORK_LATENCY
		sleep(1);
	#endif
	
	// Construct a Flickr API request.
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/v1/following.json", API_SERVER]];
	NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
	[urlRequest setHTTPShouldHandleCookies:NO];
	[urlRequest addValue:[SnpptzAPI encodeBase64Username:username andPassword:password] forHTTPHeaderField:@"Authorization"];
	
	// Get the contents of the URL as a string, and parse the JSON into Foundation objects.
	NSURLResponse *connectionResponse;
	NSError *error;
	NSMutableData *responseData = [[NSMutableData alloc] initWithData:[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&connectionResponse error:&error]];
	
	if (!connectionResponse) {
		NSLog(@"Failed to submit request for following. error: %@", error);
	} 
	
	// create json string
	NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
	
	// debug
	NSLog(@"following data: %@", jsonString);
	
	// create results
	NSDictionary *results = [jsonString JSONValue];
	
	[responseData release];
	[urlRequest release];
	[jsonString release];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	// Now we need to dig through the resulting objects.
	// Read the documentation and make liberal use of the debugger or logs.
	return [[results objectForKey:@"following"] objectForKey:@"blog"];
}

+ (NSArray *)unfollowBlog:(NSString *) blogSlug withUsername: (NSString *) username withPassword:(NSString *) password
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	// test slow network
#if TEST_HIGH_NETWORK_LATENCY
	sleep(1);
#endif
	
	// Construct a Flickr API request.
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/v1/blogs/%@/unfollow.json", API_SERVER, blogSlug]];
	NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
	[urlRequest setHTTPShouldHandleCookies:NO];
	[urlRequest addValue:[SnpptzAPI encodeBase64Username:username andPassword:password] forHTTPHeaderField:@"Authorization"];
	
	// Get the contents of the URL as a string, and parse the JSON into Foundation objects.
	NSURLResponse *connectionResponse;
	NSError *error;
	NSMutableData *responseData = [[NSMutableData alloc] initWithData:[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&connectionResponse error:&error]];
	
	if (!connectionResponse) {
		NSLog(@"Failed to submit request for following. error: %@", error);
	} 
	
	// create json string
	NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
	
	// debug
	NSLog(@"following data: %@", jsonString);
	
	// create results
	NSDictionary *results = [jsonString JSONValue];
	
	[responseData release];
	[urlRequest release];
	[jsonString release];
	
	
	if (!results || [results objectForKey:@"error"]) {
		NSMutableDictionary *errorInfo = [[NSMutableDictionary alloc] init];
		[errorInfo setValue:@"Unfollow Failed" forKey:@"title"];
		[errorInfo setValue:@"Server Error.  Please try again later." forKey:@"message"];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"displayError" object:nil userInfo:errorInfo];
		[errorInfo release];
	} 
	
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	// Now we need to dig through the resulting objects.
	// Read the documentation and make liberal use of the debugger or logs.
	return [results objectForKey:@"blog"];
}

+ (NSArray *)followBlog:(NSString *) blogSlug withUsername: (NSString *) username withPassword:(NSString *) password
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	// test slow network
#if TEST_HIGH_NETWORK_LATENCY
	sleep(1);
#endif
	
	// Construct a Flickr API request.
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/v1/blogs/%@/follow.json", API_SERVER, blogSlug]];
	NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
	[urlRequest setHTTPShouldHandleCookies:NO];
	[urlRequest addValue:[SnpptzAPI encodeBase64Username:username andPassword:password] forHTTPHeaderField:@"Authorization"];
	
	// Get the contents of the URL as a string, and parse the JSON into Foundation objects.
	NSURLResponse *connectionResponse;
	NSError *error;
	NSMutableData *responseData = [[NSMutableData alloc] initWithData:[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&connectionResponse error:&error]];
	
	if (!connectionResponse) {
		NSLog(@"Failed to submit request for following. error: %@", error);
	} 
	
	// create json string
	NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
	
	// debug
	NSLog(@"following data: %@", jsonString);
	
	// create results
	NSDictionary *results = [jsonString JSONValue];
	
	[responseData release];
	[urlRequest release];
	[jsonString release];
	
	
	if (!results || [results objectForKey:@"error"]) {
		NSMutableDictionary *errorInfo = [[NSMutableDictionary alloc] init];
		[errorInfo setValue:@"Follow Failed" forKey:@"title"];
		[errorInfo setValue:@"Server Error.  Please try again later." forKey:@"message"];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"displayError" object:nil userInfo:errorInfo];
		[errorInfo release];
	} 
	
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	// Now we need to dig through the resulting objects.
	// Read the documentation and make liberal use of the debugger or logs.
	return [results objectForKey:@"blog"];
}

+ (NSArray *)followersForUser:(NSString *) username withPassword:(NSString *) password
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	#if TEST_HIGH_NETWORK_LATENCY
		sleep(1);
	#endif
	
	// Construct url request.
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/v1/followers.json", API_SERVER]];
	NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
	[urlRequest setHTTPShouldHandleCookies:NO];
	[urlRequest addValue:[SnpptzAPI encodeBase64Username:username andPassword:password] forHTTPHeaderField:@"Authorization"];
	
	// Get the contents of the URL as a string, and parse the JSON into Foundation objects.
	NSURLResponse *connectionResponse;
	NSError *error;
	NSMutableData *responseData = [[NSMutableData alloc] initWithData:[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&connectionResponse error:&error]];
	
	if (!connectionResponse) {
		NSLog(@"Failed to submit request for followers. error: %@", error);
	} 
	
	// debug
	NSLog(@"followers raw string: %@", responseData);
	
	// json string value
	NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
	
	// debug
	NSLog(@"followers String: %@", jsonString);
	
	// get results
	NSDictionary *results = [jsonString JSONValue];
	
	[urlRequest release];
	[responseData release];
	[jsonString release];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	// Now we need to dig through the resulting objects.
	// Read the documentation and make liberal use of the debugger or logs.
	return [[results objectForKey:@"following"] objectForKey:@"user"];
}

+ (NSArray *)snipsForUser:(CLLocationCoordinate2D) coordinate 
			 withAccuracy:(float) accuracy 
			 withUserName:(NSString *) username 
			 withPassword:(NSString *) password
		withUnselectedIds:(NSArray *) unselectedIds
			withDateRange:(NSString *) dateRange
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	#if TEST_HIGH_NETWORK_LATENCY
		sleep(1);
	#endif
	
	NSString *content = [[NSString alloc] initWithFormat:@"latitude=%f&longitude=%f&accuracy=%1.8f&unselectedIds=%@&dateRange=%@", coordinate.latitude, coordinate.longitude, accuracy, [unselectedIds componentsJoinedByString: @","], dateRange];
	
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/v1/snips.json", API_SERVER]];
	NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
	[urlRequest setHTTPShouldHandleCookies:NO];
	[urlRequest setHTTPMethod:@"POST"];
	[urlRequest setHTTPBody:[content dataUsingEncoding:NSASCIIStringEncoding]];
	[urlRequest addValue:[SnpptzAPI encodeBase64Username:username andPassword:password] forHTTPHeaderField:@"Authorization"];
	
	// debug
	NSLog(@"called using: %@, %@", username, password);
	
	NSURLResponse *connectionResponse;
	NSError *error;
	NSMutableData *responseData = [[NSMutableData alloc] initWithData:[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&connectionResponse error:&error]];
	if (!connectionResponse) {
		NSLog(@"Failed to submit request. error: %@", error);
	} 
	
	NSString *resultString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
	
	NSLog(@"result String: %@", resultString);
	
	NSDictionary *results = [resultString JSONValue];
	
	if (!results) {
		NSLog(@"Failed to create results dictionary");
	} 
	
	[content release];
	[urlRequest release];
	[responseData release];
	[resultString release];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	return [[results objectForKey:@"snips"] objectForKey:@"snip"];	
}

+ (NSArray *)snipsForNonFollowedUser:(NSString *)nonFollowedUsername withUserName:(NSString *) username 
						withPassword:(NSString *) password
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
#if TEST_HIGH_NETWORK_LATENCY
		sleep(1);
	#endif
	
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/v1/blogs/%@/snips.json", API_SERVER, nonFollowedUsername]];
	NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
	
	[urlRequest setHTTPShouldHandleCookies:NO];
	[urlRequest setHTTPMethod:@"POST"];
	[urlRequest addValue:[SnpptzAPI encodeBase64Username:username andPassword:password] forHTTPHeaderField:@"Authorization"];
	
	// debug
	NSLog(@"called using: %@, %@", username, password);
	
	NSURLResponse *connectionResponse;
	NSError *error;
	NSMutableData *responseData = [[NSMutableData alloc] initWithData:[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&connectionResponse error:&error]];
	if (!connectionResponse) {
		NSLog(@"Failed to submit request. error: %@", error);
	} 
	
	NSString *resultString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
	
	NSLog(@"result String: %@", resultString);
	
	NSDictionary *results = [resultString JSONValue];
	
	if (!results) {
		NSLog(@"Failed to create results dictionary");
	} 
	
	[urlRequest release];
	[responseData release];
	[resultString release];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	return [[results objectForKey:@"snips"] objectForKey:@"snip"];	
}

+ (NSArray *)addUserDeviceToken:(NSData *) deviceToken withUserName:(NSString *)username withPassword:(NSString *) password
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	// create content string
	NSString *content = [[NSString alloc] initWithFormat:@"iphone_device_token=%@", deviceToken];
	
	// create url
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/v1/users/update.json", API_SERVER]];
	NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
	[urlRequest setHTTPMethod:@"POST"];
	[urlRequest setHTTPBody:[content dataUsingEncoding:NSASCIIStringEncoding]];
	[urlRequest addValue:[SnpptzAPI encodeBase64Username:username andPassword:password] forHTTPHeaderField:@"Authorization"];
	
	NSURLResponse *connectionResponse;
	NSError *error;
	NSMutableData *responseData = [[NSMutableData alloc] initWithData:[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&connectionResponse error:&error]];
	if (!connectionResponse) {
		NSLog(@"Failed to submit request. error: %@", error);
	} 
	
	// result string
	NSString *resultString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
	
	// debug
	NSLog(@"result String: %@", resultString);
	
	
	// results
	NSDictionary *results = [resultString JSONValue];
	
	if (!results) {
		NSLog(@"Failed to create results dictionary");
	} 
	
	[content release];
	[urlRequest release];
	[responseData release];
	[resultString release];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	return [results objectForKey:@"user"] ;	
}

+ (NSString *) encodeBase64Username:encodingUsername andPassword:encodingPassword
{
	
	NSData *stringToEncode = [[NSString stringWithFormat:@"%@%@%@", encodingUsername, @":", encodingPassword] dataUsingEncoding:NSUTF8StringEncoding];
	
	return [Base64 encode:stringToEncode];
}

+ (NSDictionary *)registerUser:(NSString *)username withPassword:(NSString *) password withEmail:(NSString *) email
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	#if TEST_HIGH_NETWORK_LATENCY
		sleep(1);
	#endif
	// unixtimestamp
	NSString *timestamp = [NSString stringWithFormat:@"%d", (long)[[NSDate date] timeIntervalSince1970]];
	
	// hash
	NSString *hash = [SnpptzAPI md5:[NSString stringWithFormat:@"%@%@%@%@%@", username, password, email, timestamp, SECURITY_HASH]];
	
	// content
	NSString *content = [[NSString alloc] initWithFormat:@"username=%@&password=%@&email=%@&timestamp=%@&hash=%@", username, password, email, timestamp, hash];
	
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/v1/private/register.json", API_SERVER]];
	NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
	[urlRequest setHTTPShouldHandleCookies:NO];
	[urlRequest setHTTPMethod:@"POST"];
	[urlRequest setHTTPBody:[content dataUsingEncoding:NSASCIIStringEncoding]];
	
	// debug
	NSLog(@"called register, using content: %@", content);
	
	NSURLResponse *connectionResponse;
	NSError *error;
	NSMutableData *responseData = [[NSMutableData alloc] initWithData:[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&connectionResponse error:&error]];
	if (!connectionResponse) {
		NSLog(@"Failed to submit request. error: %@", error);
	} 
	
	NSString *resultString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
	
	NSLog(@"result String: %@", resultString);
	
	NSDictionary *results = [resultString JSONValue];
	
	if (!results) {
		NSMutableDictionary *errorInfo = [[NSMutableDictionary alloc] init];
		[errorInfo setValue:@"Registration Error" forKey:@"title"];
		[errorInfo setValue:@"Server Error.  Please try again later." forKey:@"message"];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"displayError" object:nil userInfo:errorInfo];
		[errorInfo release];
	} 
	
	[content release];
	[urlRequest release];
	[responseData release];
	[resultString release];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	if ([results objectForKey:@"error"])
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:@"displayError" object:nil userInfo:[results objectForKey:@"error"]];
	}

	return [results objectForKey:@"user"];	
}

+ (NSDictionary *)loginUser:(NSString *)username withPassword:(NSString *) password 
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
#if TEST_HIGH_NETWORK_LATENCY
	sleep(1);
#endif
	// unixtimestamp
	NSString *timestamp = [NSString stringWithFormat:@"%d", (long)[[NSDate date] timeIntervalSince1970]];
	
	// hash
	NSString *hash = [SnpptzAPI md5:[NSString stringWithFormat:@"%@%@%@%@", username, password, timestamp, SECURITY_HASH]];
	
	// content
	NSString *content = [[NSString alloc] initWithFormat:@"username=%@&password=%@&timestamp=%@&hash=%@", username, password, timestamp, hash];
	
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/v1/private/login.json", API_SERVER]];
	NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
	[urlRequest setHTTPShouldHandleCookies:NO];
	[urlRequest setHTTPMethod:@"POST"];
	[urlRequest setHTTPBody:[content dataUsingEncoding:NSASCIIStringEncoding]];
	
	// debug
	NSLog(@"called login, using content: %@", content);
	
	NSURLResponse *connectionResponse;
	NSError *error;
	NSMutableData *responseData = [[NSMutableData alloc] initWithData:[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&connectionResponse error:&error]];
	if (!connectionResponse) {
		NSLog(@"Failed to submit request. error: %@", error);
	} 
	
	NSString *resultString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
	
	NSLog(@"result String: %@", resultString);
	
	NSDictionary *results = [resultString JSONValue];
	
	if (!results) {
		NSMutableDictionary *errorInfo = [[NSMutableDictionary alloc] init];
		[errorInfo setValue:@"Login Error" forKey:@"title"];
		[errorInfo setValue:@"Server Error.  Please try again later." forKey:@"message"];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"displayError" object:nil userInfo:errorInfo];
		[errorInfo release];
	} 
	
	[content release];
	[urlRequest release];
	[responseData release];
	[resultString release];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	if ([results objectForKey:@"error"])
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:@"displayError" object:nil userInfo:[results objectForKey:@"error"]];
	}
	
	return [results objectForKey:@"user"];	
}

+ (Boolean) geoserviceLogin:(NSString *) username
					 withPassword:(NSString *) password 
			  withServiceUsername:(NSString *) serviceUsername
			  withServicePassword:(NSString *) servicePassword
				 withGeoserviceId:(NSNumber *) serviceId
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	#if TEST_HIGH_NETWORK_LATENCY
		sleep(1);
	#endif
	
	// content
	NSString *content = [[NSString alloc] initWithFormat:@"username=%@&password=%@&geoservice_id=%@", serviceUsername, servicePassword, serviceId];
	
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/v1/private/geoservice.json", API_SERVER]];
	NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
	[urlRequest setHTTPShouldHandleCookies:NO];
	[urlRequest setHTTPMethod:@"POST"];
	[urlRequest setHTTPBody:[content dataUsingEncoding:NSASCIIStringEncoding]];
	[urlRequest addValue:[SnpptzAPI encodeBase64Username:username andPassword:password] forHTTPHeaderField:@"Authorization"];
	
	// debug
	NSLog(@"called login, using content: %@", content);
	
	NSURLResponse *connectionResponse;
	NSError *error;
	NSMutableData *responseData = [[NSMutableData alloc] initWithData:[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&connectionResponse error:&error]];
	if (!connectionResponse) {
		NSLog(@"Failed to submit request. error: %@", error);
	} 
	
	NSString *resultString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
	
	NSLog(@"result String: %@", resultString);
	
	NSDictionary *results = [resultString JSONValue];
	
	if (!results) {
		NSMutableDictionary *errorInfo = [[NSMutableDictionary alloc] init];
		[errorInfo setValue:@"Service Login Error" forKey:@"title"];
		[errorInfo setValue:@"Server Error.  Please try again later." forKey:@"message"];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"displayError" object:nil userInfo:errorInfo];
		[errorInfo release];
	} 
	
	[content release];
	[urlRequest release];
	[responseData release];
	[resultString release];

	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	
	if ([results objectForKey:@"error"])
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:@"displayError" object:nil userInfo:[results objectForKey:@"error"]];
		return FALSE;
	}
	else {
		return TRUE;
	}
}

+ (NSString *) md5: ( NSString *) str
{
	const char *cStr = [str UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5( cStr, strlen(cStr), result );
	return [NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
			];
} 


#pragma mark -

@end
