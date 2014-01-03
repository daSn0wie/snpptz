//
//  Snips.m
//  Snpptz
//
//  Created by David Wang on 5/22/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import "Snip.h"
#import "DataFetcher.h"
#import <MapKit/MapKit.h>

@implementation Snip

@dynamic snipID, title, snipDescription, body,latitude, longitude, permalink, blog, createdAt, author, distance, address, isMapped;

+ (Snip *) createSnip:(NSDictionary *)snipInfo withLocationInfo:(CLLocationManager*) locationManager withSave:(BOOL) save withMapped:(BOOL) mapped
{
	DataFetcher *fetcher = [DataFetcher sharedInstance];
	NSManagedObjectContext *context = [fetcher managedObjectContext];
	
	Snip *managedSnip = [Snip createSnip:snipInfo withSave:save withMapped: mapped];
	managedSnip.distance = [Snip calculateDistance:locationManager 
									  withLatitude:[managedSnip.latitude floatValue] 
									 withLongitude:[managedSnip.longitude floatValue]];
	
	if (save)
	{
		NSError **error;
		[context save:error];
	}

	return managedSnip;
}

+ (Snip *) createSnip:(NSDictionary *)snipInfo withSave:(BOOL) save withMapped:(BOOL) mapped;
{
	DataFetcher *fetcher = [DataFetcher sharedInstance];
	NSManagedObjectContext *context = [fetcher managedObjectContext];
	
	Snip *managedSnip = [NSEntityDescription insertNewObjectForEntityForName:@"Snip" inManagedObjectContext:context];
	managedSnip.snipID = [snipInfo valueForKey:@"id"];
	managedSnip.title = [snipInfo valueForKey:@"title"];
	managedSnip.snipDescription = [snipInfo valueForKey:@"description"];
	managedSnip.body = [snipInfo valueForKey:@"body"];
	managedSnip.latitude = [snipInfo valueForKey:@"latitude"];
	managedSnip.longitude = [snipInfo valueForKey:@"longitude"];
	managedSnip.permalink = [snipInfo valueForKey:@"permalink"];
	managedSnip.author = [snipInfo valueForKey:@"author"];
	managedSnip.address = [snipInfo valueForKey:@"address"];
	managedSnip.isMapped = [NSNumber numberWithBool: mapped];
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];

	[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	managedSnip.createdAt = [dateFormat dateFromString:[snipInfo valueForKey:@"created_at"]];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(blogID == %@)", [snipInfo valueForKey:@"blog_id"]];		
	NSArray *blogArray =  [fetcher fetchManagedObjectsForEntity:@"Blog" withPredicate:predicate];
	
	if (blogArray.count > 0)
	{	
		managedSnip.blog = [blogArray objectAtIndex:0];
	}	
	
	if (save)
	{
		NSError **error;
		[context save:error];
	}
	
	// cleanup
	[dateFormat release];
	
	return managedSnip;
}

- (NSComparisonResult) snipDistanceSort:(Snip *) snip2
{	
	if ([self.distance floatValue]  < [snip2.distance floatValue])
		return NSOrderedAscending;
	else if ([self.distance floatValue] > [snip2.distance floatValue])
		return NSOrderedDescending;
	else
		return NSOrderedSame;
}

+ (NSNumber *) calculateDistance:(CLLocationManager*) locationManager withLatitude:(CLLocationDegrees) latitude withLongitude:(CLLocationDegrees) longitude
{
	CLLocation *myLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude] ;
	CLLocationDistance distance = [[locationManager location] distanceFromLocation:myLocation];
	[myLocation release];
	
	NSNumber *distanceNum = [NSNumber numberWithFloat:(float) distance/609.344];
	
	return distanceNum;
}

@end


