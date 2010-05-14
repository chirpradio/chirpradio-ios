#import <UIKit/UIKit.h>

@class PlayerViewController;

@interface RootViewController : UIViewController {
  PlayerViewController *radioViewController;
}

@property (nonatomic, retain) PlayerViewController *radioViewController;

@end
