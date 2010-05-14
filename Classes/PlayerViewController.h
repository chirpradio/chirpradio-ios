#import <UIKit/UIKit.h>

@class AudioStreamer;
@class Reachability;
@class InfoViewController;

@interface PlayerViewController : UIViewController {
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

- (IBAction)showInfoView:(id)sender;

@end

