//
//  SongDetailViewController.m
//  topsongs
//
//  Created by Jorge Yagüe París on 17/10/12.
//
//

#import "SongDetailViewController.h"

@interface SongDetailViewController ()

@end

@implementation SongDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
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
    
    [super dealloc];
}

@end
