//
//  WebViewController.m
//  topsongs
//
//  Created by Jorge Yagüe París on 22/10/12.
//
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithURL:(NSURL *)url andTitle:(NSString *)string
{
    if (self = [super init]){
        cancionUrl = url;
        titulo = string;
    }
    return self;
}
-(id)initWithURL:(NSURL *)url
{
    return [self initWithURL:url andTitle:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //preparamos el título que tendrá la navigationBar
    tituloWeb.title = titulo;
    //Preparamos la url en un objeto request
    NSURLRequest *requestObject = [NSURLRequest requestWithURL:cancionUrl];
    //Cargamos la web en el UIWebView
    [webView loadRequest:requestObject];
}

-(IBAction)done:(id)sender
{
    //Esto disparará el método viewWillDisappear:
    [self dismissModalViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //Ponemos el delegado a nil
    webView.delegate = nil;
    //Paramos la carga de la URL por si sigue cargando
    [webView stopLoading];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication
     sharedApplication].networkActivityIndicatorVisible = YES;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication
     sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSString *errorString = [error localizedDescription];
    NSString *errorTitle = [NSString stringWithFormat:@"Error (%d)",
                            error.code];
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:errorTitle message:errorString delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [errorView show];
    [errorView autorelease];
}

-(void)didPresentAlertView:(UIAlertView *)alertView
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
