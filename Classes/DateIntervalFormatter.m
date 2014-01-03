//
//  DateIntervalFormatter.m
//  Snpptz
//
//  Created by David Wang on 7/2/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import "DateIntervalFormatter.h"

@implementation DateIntervalFormatter

+ (NSString *) getIntervalString: (NSDate *)aDate
{
	NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:aDate];
	
	NSString *stringInterval;
	
	// minutes 
	if (interval < 60) 
	{
		stringInterval = @"< 60s ago";
	}
	else if	(interval < (60 * 60))
	{
		int minutes = ceil(interval/60);
		stringInterval = [NSString stringWithFormat:@"%dm ago", minutes];
	}
	// hours
	else if ((interval > 60 * 60) && (interval < 60 * 60 * 24))
	{
		int hours = ceil(interval/(60 * 60));
		stringInterval = [NSString stringWithFormat:@"%dh ago", hours];
	}
	// days
	else if ((interval > 60 * 60 * 24) && (interval < 60 * 60 * 24 * 30))							   
	{
		int days = ceil(interval/(60 * 60 * 24));
		stringInterval = [NSString stringWithFormat:@"%dd ago", days];
	}
	else {
		stringInterval = @"1+ m ago";
	}

	return stringInterval;
}

@end
