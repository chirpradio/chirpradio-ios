//
//  InfoViewController.m
//  ChirpRadio
//
//  Created by John M. Carlin on 5/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InfoViewController.h"
#import "WebViewController.h"


@implementation InfoViewController

- (void)viewDidLoad {
  [super viewDidLoad];
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
