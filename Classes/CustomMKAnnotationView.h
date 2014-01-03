//
//  CustomMKPinAnnotationView.h
//  Snpptz
//
//  Created by David Wang on 6/28/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface CustomMKAnnotationView : MKAnnotationView {
	bool isOpen;
	CGPoint pt1;
}

- (void) closeWindow;

@end
