//
//  TipsMapController.h
//  Snpptz
//
//  Created by David Wang on 5/21/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SettingsPopViewController.h"
#import "SnipsTableViewController.h"

@interface SnipsMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, SettingsPopViewControllerDelegate> 
{
			 NSMutableArray            *annotations;
			 CLLocationManager         *locationManager;
	IBOutlet MKMapView                 *mapView;
			 NSMutableArray            *snips;
			 SettingsPopViewController *settingsViewController;
			 NSArray                   *unselectedBlogIds;
			 NSString				   *snipsDateRange;
			 NSString				   *oldSnipsDateRange;
	IBOutlet UISegmentedControl		   *mapListSegmentedControl;
			 SnipsTableViewController  *snipsTableViewController;
	         CLLocationCoordinate2D    viewCoordinate;	
			 MKCoordinateSpan	       span;

			 bool					   settingsActive;
			 float                     accuracy;

}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) NSMutableArray *snips;
@property (nonatomic, retain) NSArray *unselectedBlogIds;
@property (nonatomic, retain) NSString *snipsDateRange;
@property (nonatomic, retain) NSString *oldSnipsDateRange;
@property (nonatomic, retain) UISegmentedControl *mapListSegmentedControl;
@property (nonatomic) CLLocationCoordinate2D viewCoordinate;
@property (nonatomic) MKCoordinateSpan span;
@property (nonatomic) bool settingsActive;
@property (nonatomic) float accuracy;

- (IBAction) changeMapView:(id)sender;
- (IBAction) updateLocation;

- (void) switchToList;
- (void) addAnnotations;
- (void) clearAnnotations;
- (void) getNewAnnotations:(NSArray *) unselectedIds;
- (void) showSettings;

+ (CGFloat)annotationPadding;
+ (CGFloat)calloutHeight;

@end
