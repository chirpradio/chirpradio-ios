//
//  RootViewController.h
//  ChirpRadio
//
//  Created by John M. Carlin on 5/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChirpRadioViewController;

@interface RootViewController : UIViewController {
  ChirpRadioViewController *radioViewController;
}

@property (nonatomic, retain) ChirpRadioViewController *radioViewController;

@end
