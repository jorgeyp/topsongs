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
#import "ImageCache.h"

@interface SongDetailViewController ()

@end

@implementation SongDetailViewController
@synthesize cancionActual;

-(id)init{
    [super initWithNibName:@"SongDetailViewController" bundle:nil];
    //Creamos el botón con un icono de camara
    UIBarButtonItem *cameraButtonItem = [[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self
                                         action:@selector(takePicture:)];
    //Lo colocamos en la navigation bar
    [[self navigationItem] setRightBarButtonItem:cameraButtonItem];
    //Ya esta retained por el navigation bar
    [cameraButtonItem release];
    return self;
}

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

-(void)takePicture:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]
                                            init];
    //Si tenemos cámara la usamos, si no de los álbumes
    if ([UIImagePickerController
         isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else{
        [imagePicker
         setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    //Ponemos el delegado
    [imagePicker setDelegate:self];
    //Mostramos el imagePicker
    [self presentModalViewController:imagePicker animated:YES];
    [imagePicker release];
}

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *oldkey = [cancionActual imageKey];
    //Ya tiene una imagen?
    if (oldkey){
        //Borramos la imagen
        [[ImageCache sharedImageCache] deleteImageForKey:oldkey];
    }
    //Obtenemos la imagen que el usuario selecciono
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //Creamos un CFUUID
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    //Creamos una cadena con el identificador
    CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
    //Usamos esa ID como clave en posession
    [cancionActual setImageKey:(NSString *)newUniqueIDString];
    //Hacemos release de los CF
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
    //Guardamos la imagen en la cache
    [[ImageCache sharedImageCache] setImage:image forKey:[cancionActual imageKey]];
    //Ponemos la imagen en el image view
    [imageView setImage:image];
    //Quitamos el UIImagePickerController de la pantalla
    [self dismissModalViewControllerAnimated:YES];
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
    NSString *imageKey = [cancionActual imageKey];
    if (imageKey){
        //Obtenemos la imagen de la cache
        UIImage *imageToDisplay= [[ImageCache sharedImageCache]
                                  imageForKey:imageKey];
        //Ponemos esa imagen en el imageView
        [imageView setImage:imageToDisplay];
    } else{
        //Limpiamos el imageView
        [imageView setImage:nil];
    }
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
    [imageView release];
    imageView=nil;
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
    [imageView release];
    [super dealloc];
}

@end
