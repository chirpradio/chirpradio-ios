//
//  WebViewController.h
//  Views
//
//  Created by John M. Carlin on 5/14/10.
//  Copyright 2010 SD2 Interactive, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController <UIWebViewDelegate> {
  UIWebView *_webView;
  UIBarButtonItem *backButton;
  UIBarButtonItem *forwardButton;
}

@property (nonatomic, retain) IBOutlet UIWebView *_webView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *backButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *forwardButton;

- (IBAction)dismissWebView:(id)sender;

@end
