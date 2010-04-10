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

@implementation ChirpRadioViewController


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
		NSLog(@"streamer is waiting");
	}
	else if ([streamer isPlaying])
	{
		NSLog(@"streamer is playing");
		//[self setButtonImage:[UIImage imageNamed:@"stopbutton.png"]];
	}
	else if ([streamer isPaused])
	{
		NSLog(@"streamer is paused");
		//[self setButtonImage:[UIImage imageNamed:@"stopbutton.png"]];
	}
	else if ([streamer isIdle])
	{
		NSLog(@"streamer is idle");
		//[self destroyStreamer];
		//[self setButtonImage:[UIImage imageNamed:@"playbutton.png"]];
	}
}


- (void)viewDidLoad {
    [super viewDidLoad];
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
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
