#import "InfoViewController.h"
#import "WebViewController.h"


@implementation InfoViewController

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
  [super viewDidUnload];
}

- (void)dealloc {
  [super dealloc];
}

- (IBAction)showWebView:(id)sender {
  WebViewController *webController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
  webController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
  
  [self presentModalViewController:webController animated:YES];
  [webController release];
}

- (IBAction)dismissInfoView:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
}

@end
