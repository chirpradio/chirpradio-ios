#import <UIKit/UIKit.h>

@class PlayerViewController;

@interface ChirpRadioAppDelegate : NSObject <UIApplicationDelegate> {
  UIWindow *window;
  PlayerViewController *playerViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet PlayerViewController *playerViewController;

@end

