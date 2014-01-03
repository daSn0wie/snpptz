//
//  ImageManipulator.h
//  Snpptz
//
//  Created by David Wang on 7/1/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageManipulator : NSObject {

}

+(UIImage *)makeRoundCornerImage:(UIImage*)img  withCornerWidth:(int)cornerWidth withCornerHeight:(int) cornerHeight;

@end