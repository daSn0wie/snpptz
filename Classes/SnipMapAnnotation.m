//
//  PaparazziMapAnnotation.m
//  Paparrazi
//
//  Created by David Wang on 5/18/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import "SnipMapAnnotation.h"
#import <MapKit/MapKit.h>

@implementation SnipMapAnnotation

@synthesize title, subtitle, latitude, longitude, smallIcon, snipID;

- (id) initWithSnip: (Snip *)localSnip
{
	if (self != [self init]) return nil;
	
	self.title = localSnip.title;
	self.subtitle = localSnip.snipDescription;
	
	if ([localSnip.blog.isSmallIconImageAvailable boolValue])
	{
		self.smallIcon = localSnip.blog.smallIconImage;
	}
	else 
	{
		self.smallIcon = [NSData dataWithData:UIImagePNGRepresentation([UIImage imageNamed:@"default-small-icon.png"])];
	}
	
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
	
	self.longitude = [[formatter numberFromString:localSnip.longitude] doubleValue];
	self.latitude = [[formatter numberFromString:localSnip.latitude] doubleValue];
	
	self.snipID = localSnip.snipID;
						 
	[formatter release];
	
	return self;
}

- (CLLocationCoordinate2D) coordinate
{
    CLLocationCoordinate2D retVal;
	
    retVal.latitude = self.latitude;
    retVal.longitude = self.longitude;
	
    return retVal; 
}

- (void) dealloc
{
	[super dealloc];
	[title dealloc];
	[subtitle dealloc];
}
   
@end
