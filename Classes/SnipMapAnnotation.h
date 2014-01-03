//
//  PaparazziMapAnnotation.h
//  Paparrazi
//
//  Created by David Wang on 5/18/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Snip.h"

@interface SnipMapAnnotation : NSObject <MKAnnotation>  {

	double latitude;
	double longitude;
	NSString *title;
	NSString *subtitle;
	NSData *smallIcon;
	NSNumber *snipID;
}

@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *subtitle;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic, retain) NSData *smallIcon;
@property (nonatomic, retain) NSNumber *snipID;

- (id) initWithSnip: (Snip *)snip;

@end
