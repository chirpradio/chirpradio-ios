//
//  ChirpRadioViewController.h
//  ChirpRadio
//
//  Created by John M. Carlin on 4/9/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AudioStreamer;
@class Reachability;

@interface ChirpRadioViewController : UIViewController {
  AudioStreamer *streamer;
  UIView *volumeSlider;
  UIButton *playbackButton;

  Reachability *hostReach;
}

@property (nonatomic, retain) IBOutlet UIView *volumeSlider;
@property (nonatomic, retain) IBOutlet UIButton *playbackButton;

- (IBAction)playbackButtonPressed:(id)sender;
- (void)destroyStreamer;
- (void)createStreamer;
- (void)alertNoConnection;
- (void)updateInterfaceWithReachability:curReach;

@end

