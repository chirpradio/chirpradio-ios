#import "ChirpRadioAppDelegate.h"
#import "PlayerViewController.h"

@implementation ChirpRadioAppDelegate

@synthesize window;
@synthesize playerViewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
  [window addSubview:playerViewController.view];
  [window makeKeyAndVisible];

  return YES;
}


- (void)dealloc {
  [playerViewController release];
  [window release];
  [super dealloc];
}
@end
