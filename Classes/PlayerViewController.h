#import <UIKit/UIKit.h>

@class AudioStreamer;
@class Reachability;
@class InfoViewController;

@interface PlayerViewController : UIViewController {
  AudioStreamer *streamer;
  UIView *volumeSlider;
  UIButton *playbackButton;
  UIWebView *webView;
  NSTimer *timer;
  Reachability *hostReach;
}

@property (nonatomic, retain) IBOutlet UIView *volumeSlider;
@property (nonatomic, retain) IBOutlet UIButton *playbackButton;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundImageView;

- (IBAction)playbackButtonPressed:(id)sender;
- (void)destroyStreamer;
- (void)createStreamer;
- (void)alertNoConnection;
- (void)updateInterfaceWithReachability:curReach;
- (void)refresh;

- (IBAction)showInfoView:(id)sender;

@end

