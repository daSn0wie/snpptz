//
//  CustomMKPinAnnotationView.m
//  Snpptz
//
//  Created by David Wang on 6/28/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import "CustomMKAnnotationView.h"
#import "SnipMapAnnotation.h"
#import <QuartzCore/QuartzCore.h>

@implementation CustomMKAnnotationView

/*
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (!isOpen)
	{
		NSLog(@"touches began");
		CGRect bubbleRect;
		bubbleRect.size = CGSizeMake(0.0, 00.0);
		bubbleRect.origin = (CGPoint) {0.0f, 20.0f};
		
		UIView *backView = [[UIView alloc] initWithFrame:bubbleRect];
		backView.backgroundColor = [UIColor blackColor];
		backView.alpha = .5;
		backView.tag = [((SnipMapAnnotation *) self.annotation).snip.snipID integerValue];
		NSLog(@"snipID open: %@", ((SnipMapAnnotation *) self.annotation).snip.snipID);
		NSArray *touchArray = [touches allObjects];
		UITouch *touchOne = [touchArray objectAtIndex:0];
		pt1 = [touchOne locationInView:self];
		
		[UIView beginAnimations:@"MoveAndStrech" context:nil];
		[UIView setAnimationDuration:1];
		[UIView setAnimationBeginsFromCurrentState:YES];
		backView.frame = CGRectMake(pt1.x, pt1.y, 100, -100); 
		[UIView commitAnimations];

		[self addSubview:backView];
		isOpen = TRUE;
	}
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"touches ended");
}

- (void) closeWindow
{
	if (isOpen)
	{	
		UIView *backView = [self viewWithTag:[((SnipMapAnnotation *) self.annotation).snip.snipID integerValue]];
		NSLog(@"snipID close:  %@", ((SnipMapAnnotation *) self.annotation).snip.snipID);
		[UIView beginAnimations:@"Close" context:nil];
		[UIView setAnimationDuration:.25];
		//[UIView setAnimationBeginsFromCurrentState:YES];
		backView.frame = CGRectMake(pt1.x, pt1.y, 0, 0); 
		[UIView commitAnimations];
	
		[backView removeFromSuperview];
		
		isOpen = FALSE;
	}

}
*/

- (void) closeWindow
{
	
}

@end
