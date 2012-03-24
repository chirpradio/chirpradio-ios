#import "WebViewController.h"


@implementation WebViewController

@synthesize _webView;
@synthesize backButton;
@synthesize forwardButton;

- (void)viewDidLoad {
  app = [UIApplication sharedApplication];
  _webView.delegate = self;
  _webView.scalesPageToFit = YES;
  [backButton setEnabled:NO];
  [forwardButton setEnabled:NO];
  [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://chirpradio.org/"]]];
    
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
  [super viewDidUnload];
}


- (void)dealloc {
  _webView.delegate = nil;
  [_webView release];
  [backButton release];
  [forwardButton release];
  [super dealloc];
}

- (IBAction)dismissWebView:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Web View Delegate Methods

- (void)webViewDidStartLoad:(UIWebView *)webView {
  app.networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  app.networkActivityIndicatorVisible = NO;
  [backButton setEnabled:[webView canGoBack]];
  [forwardButton setEnabled:[webView canGoForward]];
}

@end
