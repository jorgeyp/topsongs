//
//  WebViewController.h
//  topsongs
//
//  Created by Jorge Yagüe París on 22/10/12.
//
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate, UIAlertViewDelegate>
{
    NSURL *cancionUrl;
    NSString *titulo;
    IBOutlet UIWebView *webView;
    IBOutlet UINavigationItem *tituloWeb;
}
- (id)initWithURL:(NSURL *)url;
- (id)initWithURL:(NSURL *)url andTitle:(NSString *)string;
- (IBAction)done:(id)sender;

@end
