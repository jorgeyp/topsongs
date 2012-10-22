//
//  RSSTableViewController.m
//  topsongs
//
//  Created by Jorge Yagüe París on 10/10/12.
//  Copyright (c) Jorge Yagüe París. All rights reserved.
//

#import "RSSTableViewController.h"
#import "SongDetailViewController.h"
#import "Cancion.h"

@implementation RSSTableViewController
@synthesize cancionActual;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithStyle:(UITableViewStyle)style 
{ 
    if (self = [super initWithStyle:style]){ 
        canciones = [[NSMutableArray alloc] init];
    }
    
    [[self navigationItem] setTitle:@"Top canciones en iTunes"];
    
    return self; 
} 

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Hace falta crear una instancia de ItemDetailViewController
    if (!detailViewController){
        detailViewController = [[SongDetailViewController alloc] init];
        
    }
    
    [detailViewController setCancionActual:[canciones objectAtIndex:[indexPath row]]];
    //Hacemos push a la pila del UINavigationController
    [[self navigationController] pushViewController:detailViewController animated:YES];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated 
{ 
    [super viewWillAppear:animated]; 
    [self cargaCanciones]; 
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section 
{ 
    return [canciones count];
} 
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{ 
    UITableViewCell *cell= [tableView
                            dequeueReusableCellWithIdentifier:@"UITableViewCell"]; 
    if (cell==nil){ 
        cell=[[[UITableViewCell alloc] 
               initWithStyle:UITableViewCellStyleDefault
               reuseIdentifier:@"UITableViewCell"] autorelease]; 
    }
    
    
    [[cell textLabel] setText:[[canciones objectAtIndex:[indexPath row]] titulo]];
    
    return cell; 
}

-(void)cargaCanciones
{ 
    //Por si utilizamos esta clase en varias vistas borramos el listado de canciones 
    [canciones removeAllObjects];
    [[self tableView] reloadData]; 
    //Construimos la URL 
    NSURL *url = [NSURL URLWithString:@"http://ax.itunes.apple.com/" 
                  @"WebObjects/MZStoreServices.woa/ws/RSS/topsongs/" 
                  @"limit=10/xml"]; 
    //Creamos el objeto request
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30]; 
    //Limpiamos la conexión por si existe 
    if (conexion){ 
        [conexion cancel]; 
        [conexion release]; 
    } 
    //Instanciamos el objeto para los datos  
    [xmlData release]; 
    xmlData = [[NSMutableData alloc]init]; 
    //Creamos e instanciamos la conexión
    conexion = [[NSURLConnection alloc] initWithRequest:request delegate:self
                                       startImmediately:YES]; 
}

//Este método se llamara varias veces cada vez que se reciben datos 
-(void)connection:(NSURLConnection *)connection didReceiveData:
(NSData *)data 
{ 
    [xmlData appendData:data]; 
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    NSString *xmlCheck = [[[NSString alloc] initWithData:xmlData
                                                encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"xml= %@", xmlCheck);
    
    //Creamos el parser
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData]; 
    //Le ponemos un delegado 
    [parser setDelegate:self]; 
    //Lanzamos el parseo
    [parser parse]; 
    //Esta bloqueado hasta que termina y luego lo liberamos 
    [parser release]; 
    [[self tableView] reloadData];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
    [conexion release]; 
    conexion = nil; 
    [xmlData release];
    xmlData = nil;
    NSString *errorString = [NSString stringWithFormat:@"Error al obtener los datos: %@", [error localizedDescription]];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:errorString delegate:nil cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:nil];
    [actionSheet showInView:[[self view] window]]; 
    [actionSheet autorelease];
}



- (void)elementoActualAlloc
{
    elementoActual = [[NSMutableString alloc] init];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:
(NSDictionary *)attributeDict
{ 
    if ([elementName isEqual:@"entry"]){ 
        waitingForEntryTitle = YES;
        cancionActual = [[Cancion alloc] init];
    }
    if ([elementName isEqual:@"title"] && waitingForEntryTitle){ 
        [self elementoActualAlloc];
        cancionActual.titulo = elementoActual;
    }
    if ([elementName isEqual:@"im:artist"] && waitingForEntryTitle){
        [self elementoActualAlloc];
        cancionActual.artista = elementoActual;
    }
    if ([elementName isEqual:@"im:duration"] && waitingForEntryTitle){
        [self elementoActualAlloc];
        cancionActual.duracion = elementoActual;
    }
    if ([elementName isEqual:@"im:price"] && waitingForEntryTitle){
        [self elementoActualAlloc];
        cancionActual.precio = elementoActual;
    }
    if ([elementName isEqual:@"rights"] && waitingForEntryTitle){
        [self elementoActualAlloc];
        cancionActual.copyright = elementoActual;
    }
    if ([elementName isEqual:@"link"] && waitingForEntryTitle){
        [self elementoActualAlloc];
        cancionActual.enlace = [attributeDict objectForKey:@"href"];
    }
} 
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string 
{ 
    [elementoActual appendString:string];
    
}

- (void)elementoActualDealloc
{
    [elementoActual release];
    elementoActual = nil;
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{ 
    if ([elementName isEqualToString:@"title"] && waitingForEntryTitle){
        [self elementoActualDealloc];
    }
    if ([elementName isEqualToString:@"im:artist"] && waitingForEntryTitle){
        [self elementoActualDealloc];
    }
    if ([elementName isEqualToString:@"im:duration"] && waitingForEntryTitle){
        [self elementoActualDealloc];
    }
    if ([elementName isEqualToString:@"im:price"] && waitingForEntryTitle){
        [self elementoActualDealloc];
    }
    if ([elementName isEqualToString:@"rights"] && waitingForEntryTitle){
        [self elementoActualDealloc];
    }
    if ([elementName isEqualToString:@"link"] && waitingForEntryTitle){
        [self elementoActualDealloc];
    }
    if ([elementName isEqual:@"entry"]){ 
        waitingForEntryTitle = NO;
        [canciones addObject:cancionActual];
        [cancionActual release];
        cancionActual = nil;
    }
}

- (void)dealloc {
    [super dealloc];
}

@end
