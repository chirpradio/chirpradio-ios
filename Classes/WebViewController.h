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
