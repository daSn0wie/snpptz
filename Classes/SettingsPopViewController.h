//
//  SettingsPopViewController.h
//  Snpptz
//
//  Created by David Wang on 6/25/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsPopViewControllerDelegate <NSObject>
@required
- (void)hideSettings;
- (void)setProximity: (float) proximity;
- (void)setDateRange: (NSString *) range;
@end

@interface SettingsPopViewController : UIViewController {
	IBOutlet UIView *outerViewContainer;
	IBOutlet UIView *settingsViewContainer;
	IBOutlet UILabel *proximityValueLabel;
	IBOutlet UISlider *proximitySlider;
	IBOutlet UISegmentedControl *postDateSegmentedControl;
	IBOutlet UIButton *searchButton;
	id <SettingsPopViewControllerDelegate>    delegate;
	float proximity;
	NSString *snipsDateRange;
}

@property (nonatomic, assign) IBOutlet UISlider *proximitySlider;
@property (nonatomic, assign) id <SettingsPopViewControllerDelegate> delegate;
@property (nonatomic, assign) NSString *snipsDateRange;
@property (nonatomic) float proximity;

- (IBAction) updateProximity: (id) sender;
- (IBAction) updateProximityLabel: (id) sender;
- (IBAction) updatePostDate: (id) sender;
- (IBAction) executeSearch: (id) sender;

@end
