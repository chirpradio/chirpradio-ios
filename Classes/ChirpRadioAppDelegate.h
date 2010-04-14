//
//  ChirpRadioAppDelegate.h
//  ChirpRadio
//
//  Created by John M. Carlin on 4/9/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChirpRadioViewController;

@interface ChirpRadioAppDelegate : NSObject <UIApplicationDelegate> {
  UIWindow *window;
  ChirpRadioViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ChirpRadioViewController *viewController;

@end

