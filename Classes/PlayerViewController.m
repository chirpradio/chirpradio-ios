#import "PlayerViewController.h"
#import "InfoViewController.h"
#import "AudioStreamer.h"
#import <CFNetwork/CFNetwork.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Reachability.h"

@implementation PlayerViewController

@synthesize volumeSlider;
@synthesize playbackButton;
@synthesize webView, backgroundImageView;

- (BOOL)canBecomeFirstResponder {
  return YES;
}

- (void)viewDidAppear:(BOOL)animated {
  UIDevice* device = [UIDevice currentDevice];
  BOOL hasMultitasking = NO;
  if ([device respondsToSelector:@selector(isMultitaskingSupported)]) {
    hasMultitasking = device.multitaskingSupported;
  }

  if (hasMultitasking) {
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
  }
}


- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
  switch (event.subtype) {
    case UIEventSubtypeRemoteControlTogglePlayPause:
      if ([streamer isPlaying])
      {
        [streamer pause];
      } else {
        [streamer start];
      }
      break;
    default:
      break;
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
  UIApplication *app = [UIApplication sharedApplication];
  if ([streamer isWaiting])
  {
    app.networkActivityIndicatorVisible = YES;
  }
  else if ([streamer isPlaying])
  {
    [playbackButton setImage:[UIImage imageNamed:@"pauseButton.png"] forState:UIControlStateNormal];
    app.networkActivityIndicatorVisible = NO;
  }
  else if ([streamer isPaused])
  {
    [playbackButton setImage:[UIImage imageNamed:@"playButton.png"] forState:UIControlStateNormal];
    app.networkActivityIndicatorVisible = NO;
  }
  else if ([streamer isIdle])
  {
    // streamer goes idle when Internet connectivity is lost
    [self destroyStreamer];
    [self createStreamer];
    [playbackButton setImage:[UIImage imageNamed:@"playButton.png"] forState:UIControlStateNormal];
    app.networkActivityIndicatorVisible = NO;
  }
}
- (void)loadUIWebView
{
    webView = [[UIWebView alloc] initWithFrame:self.view.bounds];  //Change self.view.bounds to a smaller CGRect if you don't want it to take up the whole screen
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"www.google.com"]]];
    [self.view addSubview:webView];
    [webView release];
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
  NetworkStatus netStatus = [curReach currentReachabilityStatus];
  if (netStatus == NotReachable) {
    [self alertNoConnection];
  }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
  [volumeSlider release];
  [playbackButton release];
  [hostReach release];
  [webView release];
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

  if ([[UIScreen mainScreen] bounds].size.height == 568) {
    UIImage *bg568Image = [UIImage imageNamed:@"bg-568"];
    [backgroundImageView setImage:bg568Image];
  }

  // Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the
  // method "reachabilityChanged" will be called.
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];

	hostReach = [[Reachability reachabilityWithHostName: @"www.live365.com"] retain];
	[hostReach startNotifer];

    /*Playlist code added by Jason Wiggs 3/13/2012 */

    NSString *path = [[NSBundle mainBundle] pathForResource:@"Playlist" ofType:@"html"];
    NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    NSString *htmlString = [[NSString alloc] initWithData: [readHandle readDataToEndOfFile] encoding:NSUTF8StringEncoding];

    webView.opaque = NO;
    webView.backgroundColor = [UIColor clearColor];

    [self.webView loadHTMLString:htmlString baseURL:nil];


  MPVolumeView *volumeView = [[[MPVolumeView alloc] initWithFrame:volumeSlider.bounds] autorelease];
  [volumeSlider addSubview:volumeView];
  [volumeView sizeToFit];

  [self createStreamer];
  [streamer start];

    timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(refresh) userInfo:nil repeats: YES];

    [htmlString release];

}
-(void)refresh{
    [webView stringByEvaluatingJavaScriptFromString:@"callChirpJSONP()"];

}
- (IBAction)showInfoView:(id)sender {
  InfoViewController *infoController = [[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil];
  infoController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
  [self presentModalViewController:infoController animated:YES];
  [infoController release];
}

@end
