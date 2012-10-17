//
//  RSSTableViewController.m
//  topsongs
//
//  Created by Jorge Yagüe París on 10/10/12.
//  Copyright (c) Jorge Yagüe París. All rights reserved.
//

#import "RSSTableViewController.h"

@implementation RSSTableViewController

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
    return self; 
} 

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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
    [[cell textLabel] setText:[canciones objectAtIndex:[indexPath row]]]; 
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

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:
(NSDictionary *)attributeDict
{ 
    if ([elementName isEqual:@"entry"]){ 
        NSLog(@"Encontrada Entrada de canción!"); 
        waitingForEntryTitle = YES; 
    }
    if ([elementName isEqual:@"title"] && waitingForEntryTitle){ 
        NSLog(@"Encontrado titulo!"); 
        titulo = [[NSMutableString alloc] init]; 
    } 
} 
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string 
{ 
    [titulo appendString:string]; 
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{ 
    if ([elementName isEqualToString:@"title"] && waitingForEntryTitle){ 
        NSLog(@"Finalizado el título: %@", titulo); 
        [canciones addObject:titulo]; 
        //Liberamos y ponemos a nil
        [titulo release]; 
        titulo = nil; 
    } 
    if ([elementName isEqual:@"entry"]){ 
        NSLog(@"Finalizada una entrada de una canción"); 
        waitingForEntryTitle = NO; 
    }
}

@end
