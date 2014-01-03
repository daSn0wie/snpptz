//
//  SnpptzAPI.h
//  Snpptz
//
//  Created by David Wang on 6/27/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Base64.h"
#import "Blog.h"

#define TEST_HIGH_NETWORK_LATENCY 0
#define API_SERVER @"api.snpptz.dev"
#define SECURITY_HASH @"&G&FH*had09fj3284adfj930@"

@interface SnpptzAPI : NSObject {

}

// return followers
+ (NSArray *) followersForUser:(NSString *) username 
				  withPassword:(NSString *) password;

// return following
+ (NSArray *) followingForUser:(NSString *) username 
				  withPassword:(NSString *) password;


// follow blog
+ (NSArray *) followBlog:(NSString *) blogSlug
			withUsername:(NSString *) username 
			withPassword:(NSString *) password;

// unfollow blog
+ (NSArray *)unfollowBlog:(NSString *) blogSlug 
			 withUsername: (NSString *) username 
			 withPassword:(NSString *) password;

// search for users
+ (NSArray *) searchForUsers:(NSString *) searchTerm 
				withUsername:(NSString *) username 
				withPassword:(NSString *) password;

// return snips
+ (NSArray *)snipsForUser:(CLLocationCoordinate2D) coordinate 
			 withAccuracy:(float) accuracy 
			 withUserName:(NSString *) username 
			 withPassword:(NSString *) password
		withUnselectedIds:(NSArray *) unselectedIds
			withDateRange:(NSString *) dateRange;

// return snips
+ (NSArray *)snipsForNonFollowedUser:(NSString *)nonFollowedUsername 
						withUserName:(NSString *) username 
						withPassword:(NSString *) password;

// add iphone device toke 
+ (NSArray *) addUserDeviceToken:(NSData *) deviceToken 
					withUserName:(NSString *)username 
					withPassword:(NSString *) password;


// register user
+ (NSDictionary *)registerUser:(NSString *) username 
				  withPassword:(NSString *) password 
					 withEmail:(NSString *) email;

// login user
+ (NSDictionary *)loginUser:(NSString *) username 
			   withPassword:(NSString *) password ;

// geoservice login
+ (Boolean)geoserviceLogin:(NSString *) username
					 withPassword:(NSString *) password 
			  withServiceUsername:(NSString *) serviceUsername
			  withServicePassword:(NSString *) servicePassword
				 withGeoserviceId:(NSNumber *) serviceId;


// base64 utility function
+ (NSString *) encodeBase64Username:encodingUsername 
						andPassword:encodingPassword;

// md5 utility function
+ (NSString *) md5: (NSString *) str ;

@end
