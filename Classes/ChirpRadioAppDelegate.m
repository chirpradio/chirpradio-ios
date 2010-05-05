//
//  ChirpRadioAppDelegate.m
//  ChirpRadio
//
//  Created by John M. Carlin on 4/9/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "ChirpRadioAppDelegate.h"
#import "RootViewController.h"

@implementation ChirpRadioAppDelegate

@synthesize window;
@synthesize rootViewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

  // Override point for customization after app launch
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
