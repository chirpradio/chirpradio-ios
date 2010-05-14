//
//  RootViewController.m
//  ChirpRadio
//
//  Created by John M. Carlin on 5/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "ChirpRadioViewController.h"

@implementation RootViewController

@synthesize radioViewController;

- (void)viewDidLoad {
  ChirpRadioViewController *radioController = [[ChirpRadioViewController alloc]
                                               initWithNibName:@"ChirpRadioViewController" bundle:nil];
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
