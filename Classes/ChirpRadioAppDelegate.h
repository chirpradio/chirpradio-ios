#import <UIKit/UIKit.h>

@class RootViewController;

@interface ChirpRadioAppDelegate : NSObject <UIApplicationDelegate> {
  UIWindow *window;
  RootViewController *rootViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;

@end

