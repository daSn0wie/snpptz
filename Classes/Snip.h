//
//  Snips.h
//  Snpptz
//
//  Created by David Wang on 5/22/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>
#import "Blog.h"

@class Blog;

// this probably doesnt need to be a nsmanagedobject
@interface Snip : NSManagedObject {

}

@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;
@property (nonatomic, retain) NSString *permalink;
@property (nonatomic, retain) NSString *snipDescription;
@property (nonatomic, retain) NSNumber *snipID;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSDate *createdAt;
@property (nonatomic, retain) NSString *author;
@property (nonatomic, retain) NSNumber *distance;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSNumber *isMapped;

@property (nonatomic, retain) Blog *blog;

+ (Snip *) createSnip:(NSDictionary *)snipInfo 
			 withSave:(BOOL) save
		   withMapped:(BOOL) mapped;

+ (Snip *) createSnip:(NSDictionary *)snipInfo 
	 withLocationInfo:(CLLocationManager*) locationManager 
			 withSave:(BOOL) save
		   withMapped:(BOOL) mapped;

+ (NSNumber*) calculateDistance:(CLLocationManager*) locationManager 
				   withLatitude:(CLLocationDegrees) latitude 
				  withLongitude:(CLLocationDegrees) longitude;

- (NSComparisonResult) snipDistanceSort:(Snip *) snip;

@end
