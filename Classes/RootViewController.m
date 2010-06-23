#import "RootViewController.h"
#import "PlayerViewController.h"

@implementation RootViewController

@synthesize radioViewController;

- (BOOL)canBecomeFirstResponder {
  return YES;
}

- (void)viewDidAppear:(BOOL)animated {
  [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
  [self becomeFirstResponder];
}


- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
  switch (event.subtype) {
    case UIEventSubtypeRemoteControlTogglePlayPause:
      NSLog(@"toggle play/pause");
      break;
    default:
      NSLog(@"some mystery button pressed");
      break;
  }
}

- (void)viewDidLoad {
  PlayerViewController *radioController = [[PlayerViewController alloc]
                                               initWithNibName:@"PlayerViewController" bundle:nil];
  self.radioViewController = radioController;
  [self.view insertSubview:radioController.view atIndex:0];
  [radioController release];
  [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
  [super viewDidUnload];
}

- (void)dealloc {
  [radioViewController release];
  [super dealloc];
}

@end
