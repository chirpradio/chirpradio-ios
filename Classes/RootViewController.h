//
//  RootViewController.h
//  ChirpRadio
//
//  Created by John M. Carlin on 5/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChirpRadioViewController;
@class InfoViewController;

@interface RootViewController : UIViewController {
  ChirpRadioViewController *radioViewController;
  InfoViewController *infoViewController;
}

@property (nonatomic, retain) ChirpRadioViewController *radioViewController;
@property (nonatomic, retain) InfoViewController *infoViewController;

-(IBAction)switchViews:(id)sender;

@end
