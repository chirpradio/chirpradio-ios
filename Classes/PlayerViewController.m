#import "PlayerViewController.h"
#import "InfoViewController.h"
#import "AudioStreamer.h"
#import <CFNetwork/CFNetwork.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Reachability.h"
#import "JSONKit.h"

@implementation PlayerViewController
@synthesize djLabel;
@synthesize nowPlayingArtistLabel;
@synthesize nowPlayingTrackLabel;
@synthesize nowPlayingLabelLabel;

@synthesize volumeSlider;
@synthesize playbackButton;


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
//  [webView release];  
  [djLabel release];
  [nowPlayingArtistLabel release];
  [nowPlayingTrackLabel release];
  [nowPlayingLabelLabel release];
  [super dealloc];
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
  [self setNowPlayingLabelLabel:nil];
  [self setNowPlayingTrackLabel:nil];
  [self setNowPlayingArtistLabel:nil];
  [self setDjLabel:nil];
}

- (void)requestPlaylist {
    responseData = [[NSMutableData data] retain];
    NSString *apiEndpoint = @"http://chirpradio.appspot.com/api/current_playlist?src=src=chirpradio-iphone";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:apiEndpoint]
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                         timeoutInterval:30.0];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
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
  
  [self requestPlaylist];
    
  timer = [NSTimer scheduledTimerWithTimeInterval:30 
                                           target:self 
                                         selector:@selector(requestPlaylist) 
                                         userInfo:nil 
                                          repeats:YES];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  [responseData release];
  [connection release];
  NSString *errorMessage = [NSString stringWithFormat:@"Connection failed: %@", [error description]];
  NSLog(@"didFaileWithError: %@", errorMessage);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
  NSLog(@"connectionDidFinishingLoading");
  NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
  NSLog(@"responseString: %@", responseString);
  [responseData release];
  NSLog(@"-----------------------------------------------");
  NSDictionary *playlistData = [responseString objectFromJSONString];
  NSDictionary *nowPlaying = [playlistData objectForKey:@"now_playing"];
  NSArray *recentlyPlayed = [playlistData objectForKey:@"recently_played"];
  [djLabel setText:[nowPlaying objectForKey:@"dj"]];
  [nowPlayingArtistLabel setText:[nowPlaying objectForKey:@"artist"]];
  [nowPlayingArtistLabel sizeToFit];
  [nowPlayingTrackLabel setText:[nowPlaying objectForKey:@"track"]];
  [nowPlayingTrackLabel sizeToFit];
  [nowPlayingLabelLabel setText:[nowPlaying objectForKey:@"label"]];
  [nowPlayingLabelLabel sizeToFit];
  
  for (NSDictionary *played in recentlyPlayed) {
    NSLog(@"%@ - %@ (%@)", 
          [played objectForKey:@"artist"], 
          [played objectForKey:@"track"], 
          [played objectForKey:@"label"]);
  }
//  NSLog(@"%@", [playlistData description]);
  NSLog(@"-----------------------------------------------");
}


-(void)refresh{//Added by JWiggs to refresh playlist every xx secs
    
//	NSString *path = [[NSBundle mainBundle] pathForResource:@"Playlist" ofType:@"html"];
//    NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:path]; 
//    NSString *htmlString = [[NSString alloc] initWithData: [readHandle readDataToEndOfFile] encoding:NSUTF8StringEncoding];
//    
//    webView.opaque = NO; 
//    webView.backgroundColor = [UIColor clearColor];     
//    [self.webView loadHTMLString:htmlString baseURL:nil];
//    [htmlString release];
  
  

}

- (IBAction)showInfoView:(id)sender {
  InfoViewController *infoController = [[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil];
  infoController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
  [self presentModalViewController:infoController animated:YES];
  [infoController release];
}

@end
