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
@synthesize recentlyPlayedTableView;
@synthesize recentlyPlayed;
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
  [djLabel release];
  [nowPlayingArtistLabel release];
  [nowPlayingTrackLabel release];
  [nowPlayingLabelLabel release];
  [recentlyPlayedTableView release];
  [recentlyPlayed release];
  [super dealloc];
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
  [self setRecentlyPlayedTableView:nil];
  [self setNowPlayingLabelLabel:nil];
  [self setNowPlayingTrackLabel:nil];
  [self setNowPlayingArtistLabel:nil];
  [self setDjLabel:nil];
  [self setRecentlyPlayed:nil];
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
  
  self.recentlyPlayed = nil;
  [self.recentlyPlayedTableView setSeparatorColor:[UIColor lightGrayColor]];
  
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
  NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
  [responseData release];
  NSDictionary *playlistData = [responseString objectFromJSONString];
  [responseString release];
  NSDictionary *nowPlaying = [playlistData objectForKey:@"now_playing"];
  
  self.recentlyPlayed = [NSMutableArray arrayWithArray:[playlistData objectForKey:@"recently_played"]];

  [djLabel setText:[nowPlaying objectForKey:@"dj"]];
  [nowPlayingArtistLabel setText:[nowPlaying objectForKey:@"artist"]];
  [nowPlayingTrackLabel setText:[nowPlaying objectForKey:@"track"]];
  [nowPlayingLabelLabel setText:[nowPlaying objectForKey:@"release"]];
  
  [recentlyPlayedTableView reloadData];
}

- (IBAction)showInfoView:(id)sender {
  InfoViewController *infoController = [[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil];
  infoController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
  [self presentModalViewController:infoController animated:YES];
  [infoController release];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 5;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
  if (recentlyPlayed != nil) {
    NSDictionary *dict = [recentlyPlayed objectAtIndex:indexPath.row];
    cell.textLabel.text = [dict objectForKey:@"track"];
    cell.detailTextLabel.text = [dict objectForKey:@"artist"];
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UIColor *darkGray = [UIColor colorWithRed:0.094 green:0.094 blue:0.094 alpha:1.0];
    [cell.contentView setBackgroundColor:darkGray];
    [cell.textLabel setBackgroundColor:darkGray];
    [cell.textLabel setTextColor:[UIColor lightGrayColor]];
  }
  
  [self configureCell:cell atIndexPath:indexPath];
  
  return cell;
}

@end
