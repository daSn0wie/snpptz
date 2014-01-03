//
//  SnpptzLauncherItem.h
//  Snpptz
//
//  Created by David Wang on 7/3/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>
#import "Blog.h"

@interface SnpptzLauncherItem : TTLauncherItem 
{
	Blog *blog;
}

@property (nonatomic, retain) Blog *blog;

@end
