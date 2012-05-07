#import <UIKit/UIKit.h>

@class AudioStreamer;
@class Reachability;
@class InfoViewController;

@interface PlayerViewController : UIViewController {
  AudioStreamer *streamer;
  UIView *volumeSlider;
  UIButton *playbackButton;
  NSMutableData *responseData;
  NSTimer *timer;
  Reachability *hostReach;
}

@property (nonatomic, retain) IBOutlet UIView *volumeSlider;
@property (nonatomic, retain) IBOutlet UIButton *playbackButton;
@property (retain, nonatomic) IBOutlet UILabel *djLabel;
@property (retain, nonatomic) IBOutlet UILabel *nowPlayingArtistLabel;
@property (retain, nonatomic) IBOutlet UILabel *nowPlayingTrackLabel;
@property (retain, nonatomic) IBOutlet UILabel *nowPlayingLabelLabel;

- (IBAction)playbackButtonPressed:(id)sender;
- (void)destroyStreamer;
- (void)createStreamer;
- (void)alertNoConnection;
- (void)updateInterfaceWithReachability:curReach;
- (void)refresh;

- (IBAction)showInfoView:(id)sender;

@end

