//
//  SongDetailViewController.m
//  topsongs
//
//  Created by Jorge Yagüe París on 17/10/12.
//
//

#import "SongDetailViewController.h"
#import "Cancion.h"
#import "WebViewController.h"

@interface SongDetailViewController ()

@end

@implementation SongDetailViewController
@synthesize cancionActual;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)pushedButtonLink:(id)sender
{
    NSURL *url = [NSURL URLWithString:cancionActual.enlace];
    WebViewController *webViewController = [[WebViewController alloc] initWithURL:url andTitle:cancionActual.titulo];
    //Mostramos el WebViewController de forma modal
    [self presentModalViewController:webViewController animated:YES];
    [webViewController release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [labelTitle setText:cancionActual.titulo];
    [labelArtist setText:cancionActual.artista];
    [labelDuration setText:cancionActual.duracion];
    [labelPrice setText:cancionActual.precio];
    [labelCopyright setText:cancionActual.copyright];
    [labelLink setText:cancionActual.enlace];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [labelArtist release];
    labelArtist = nil;
    [labelCopyright release];
    labelCopyright = nil;
    [labelDuration release];
    labelDuration = nil;
    [labelLink release];
    labelLink = nil;
    [labelPrice release];
    labelPrice = nil;
    [labelTitle release];
    labelTitle = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc
{
    [labelArtist release];
    [labelCopyright release];
    [labelDuration release];
    [labelLink release];
    [labelPrice release];
    [labelTitle release];
    [buttonLink release];
    
    [super dealloc];
}

@end
