#import "ChirpRadioAppDelegate.h"
#import "RootViewController.h"

@implementation ChirpRadioAppDelegate

@synthesize window;
@synthesize rootViewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
  [window addSubview:rootViewController.view];
  [window makeKeyAndVisible];

  return YES;
}


- (void)dealloc {
  [rootViewController release];
  [window release];
  [super dealloc];
}
@end
