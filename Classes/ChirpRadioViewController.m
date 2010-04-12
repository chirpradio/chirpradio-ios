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

@implementation ChirpRadioViewController

@synthesize volumeSlider;
@synthesize playbackButton;
@synthesize stateLabel;

/*
 // The designated initializer. Override to perform setup that is required before the view is loaded.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

- (IBAction)playbackButtonPressed:(id)sender
{
	if ([streamer isPlaying])
	{
		[streamer pause];
	} else {
		[streamer start];
	}
}

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
    [stateLabel setText:@""];
    [playbackButton setEnabled:YES];
    [playbackButton setAlpha:1.0];
    [playbackButton setImage:[UIImage imageNamed:@"playButton.png"] forState:UIControlStateNormal];
	}
}


- (void)viewDidLoad 
{
  [super viewDidLoad];
  
  MPVolumeView *volumeView = [[[MPVolumeView alloc] initWithFrame:volumeSlider.bounds] autorelease];
  [volumeSlider addSubview:volumeView];
  [volumeView sizeToFit];
  
  [self createStreamer];
  [streamer start];
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
}


- (void)dealloc {
  [volumeSlider release];
  [stateLabel release];
  [playbackButton release];
  [super dealloc];
}

@end
