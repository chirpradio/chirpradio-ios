//
//  ChirpRadioViewController.h
//  ChirpRadio
//
//  Created by John M. Carlin on 4/9/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AudioStreamer;

@interface ChirpRadioViewController : UIViewController {
  AudioStreamer *streamer;
  UIView *volumeSlider;
  UIButton *playbackButton;
  UILabel *stateLabel;
}

@property (nonatomic, retain) IBOutlet UIView *volumeSlider;
@property (nonatomic, retain) IBOutlet UIButton *playbackButton;
@property (nonatomic, retain) IBOutlet UILabel *stateLabel;

- (IBAction)playbackButtonPressed:(id)sender;
@end

