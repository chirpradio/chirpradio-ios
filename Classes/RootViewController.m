//
//  RootViewController.m
//  ChirpRadio
//
//  Created by John M. Carlin on 5/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "ChirpRadioViewController.h"
#import "InfoViewController.h"

@implementation RootViewController

@synthesize radioViewController;
@synthesize infoViewController;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (void)viewDidLoad {
  ChirpRadioViewController *radioController = [[ChirpRadioViewController alloc]
                                                   initWithNibName:@"ChirpRadioViewController" bundle:nil];
  self.radioViewController = radioController;
  [self.view insertSubview:radioController.view atIndex:0];
  [radioController release];
  [super viewDidLoad];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  
  if (self.radioViewController.view.superview == nil)
  {
    self.radioViewController = nil;
  }
  else
  {
    self.infoViewController = nil;
  }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
  [radioViewController release];
  [infoViewController release];
  [super dealloc];
}

-(IBAction)switchViews:(id)sender
{
  [UIView beginAnimations:@"View Flip" context:nil];
  [UIView setAnimationDuration:0.5];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
  
  if (self.infoViewController.view.superview == nil)
  {
    if (self.infoViewController == nil)
    {
      InfoViewController *infoController = [[InfoViewController alloc]
                                            initWithNibName:@"InfoViewController" bundle:nil];
      self.infoViewController = infoController;
      [infoController release];
    }
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    [infoViewController viewWillAppear:YES];
    [radioViewController viewWillDisappear:YES];
    
    [radioViewController.view removeFromSuperview];
    [self.view insertSubview:infoViewController.view atIndex:0];
    
    [infoViewController viewDidAppear:YES];
    [radioViewController viewDidDisappear:YES];
  }
  else 
  {
    if (self.radioViewController == nil)
    {
      ChirpRadioViewController *radioController = [[ChirpRadioViewController alloc]
                                              initWithNibName:@"ChirpRadioViewController" bundle:nil];
      self.radioViewController = radioController;
      [radioController release];
    }
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    [radioViewController viewWillAppear:YES];
    [infoViewController viewWillDisappear:YES];
    
    [infoViewController.view removeFromSuperview];
    [self.view insertSubview:radioViewController.view atIndex:0];
    
    [radioViewController viewDidAppear:YES];
    [infoViewController viewDidDisappear:YES];
  }
  [UIView commitAnimations];
}


@end
