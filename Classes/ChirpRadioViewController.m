//
//  ChirpRadioViewController.m
//  ChirpRadio
//
//  Created by John M. Carlin on 4/9/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "ChirpRadioViewController.h"
#import "AudioStreamer.h"
#import <CFNetwork/CFNetwork.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Reachability.h"

@implementation ChirpRadioViewController

@synthesize volumeSlider;
@synthesize playbackButton;
@synthesize stateLabel;

- (void)destroyStreamer
{
  if (streamer)
  {
    [streamer stop];
    [streamer release];
    streamer = nil;
  }
}

- (void)createStreamer
{
  if (streamer)
  {
    return;
  }
  [self destroyStreamer];
  
  NSURL *url = [NSURL URLWithString:@"http://www.live365.com/play/chirpradio"];
  streamer = [[AudioStreamer alloc] initWithURL:url];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(playbackStateChanged:)
                                               name:ASStatusChangedNotification
                                             object:streamer];  
}

- (IBAction)playbackButtonPressed:(id)sender
{
  if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable){
    [self alertNoConnection];
    return;
  }

  if ([streamer isPlaying])
  {
    [streamer pause];
  } else {
    [streamer start];
  }
}

- (void)playbackStateChanged:(NSNotification *)aNotification
{
  if ([streamer isWaiting])
  {
    [playbackButton setEnabled:NO];
    [playbackButton setAlpha:0.3];
    
    [stateLabel setText:@"loading awesomeness just for you"];
  }
  else if ([streamer isPlaying])
  {
    [stateLabel setText:@""];
    [playbackButton setEnabled:YES];
    [playbackButton setAlpha:1.0];
    
    [playbackButton setImage:[UIImage imageNamed:@"pauseButton.png"] forState:UIControlStateNormal];
  }
  else if ([streamer isPaused])
  {
    [stateLabel setText:@""];
    [playbackButton setEnabled:YES];
    [playbackButton setAlpha:1.0];
    [playbackButton setImage:[UIImage imageNamed:@"playButton.png"] forState:UIControlStateNormal];
  }
  else if ([streamer isIdle])
  {
    // streamer goes idle when Internet connectivity is lost
    [self destroyStreamer];
    [self createStreamer];
    [stateLabel setText:@""];
    [playbackButton setEnabled:YES];
    [playbackButton setAlpha:1.0];
    [playbackButton setImage:[UIImage imageNamed:@"playButton.png"] forState:UIControlStateNormal];
  }
}

- (void)alertNoConnection
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Streaming Error" message:@"No Internet Connection"
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];   
    [alert release];
}

- (void)reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	[self updateInterfaceWithReachability:curReach];
}

- (void)updateInterfaceWithReachability:curReach
{
  BOOL connectionRequired = [curReach connectionRequired];
  
  if (connectionRequired) {
    if ([curReach currentReachabilityStatus] == NotReachable) {
      [self alertNoConnection];
    }
  }
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)dealloc {
  [volumeSlider release];
  [stateLabel release];
  [playbackButton release];
  [hostReach release];
  [super dealloc];
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the
  // method "reachabilityChanged" will be called. 
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
	
	hostReach = [[Reachability reachabilityWithHostName: @"www.live365.com"] retain];
	[hostReach startNotifer];

  MPVolumeView *volumeView = [[[MPVolumeView alloc] initWithFrame:volumeSlider.bounds] autorelease];
  [volumeSlider addSubview:volumeView];
  [volumeView sizeToFit];
  
  [self createStreamer];
  [streamer start];
}

@end
