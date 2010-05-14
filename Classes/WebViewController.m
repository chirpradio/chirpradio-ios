//
//  WebViewController.m
//  Views
//
//  Created by John M. Carlin on 5/14/10.
//  Copyright 2010 SD2 Interactive, Inc. All rights reserved.
//

#import "WebViewController.h"


@implementation WebViewController

@synthesize _webView;
@synthesize backButton;
@synthesize forwardButton;

- (void)viewDidLoad {
  _webView.delegate = self;
  _webView.scalesPageToFit = YES;
  [backButton setEnabled:NO];
  [forwardButton setEnabled:NO];
  [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://chirpradio.org/"]]];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
  _webView.delegate = nil;
  [_webView release];
  [super dealloc];
}

- (IBAction)dismissWebView:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Web View Delegate Methods


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
  [backButton setEnabled:[webView canGoBack]];
  [forwardButton setEnabled:[webView canGoForward]];
}

@end
