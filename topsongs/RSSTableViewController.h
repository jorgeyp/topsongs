//
//  RSSTableViewController.h
//  topsongs
//
//  Created by Jorge Yagüe París on 10/10/12.
//  Copyright (c) Jorge Yagüe París. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SongDetailViewController, Cancion;
@interface RSSTableViewController : UITableViewController <NSXMLParserDelegate> 
{
    SongDetailViewController *detailViewController;
    BOOL waitingForEntryTitle;
    NSMutableArray *titulosCanciones;
    NSMutableData *xmlData; 
    NSURLConnection *conexion;
    NSMutableString *titulo;
    NSMutableString *artista;
    
    Cancion *cancionActual;
}

@property (nonatomic, retain) Cancion *cancionActual;

-(void)cargaCanciones;

@end
