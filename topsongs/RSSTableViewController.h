//
//  RSSTableViewController.h
//  topsongs
//
//  Created by Jorge Yagüe París on 10/10/12.
//  Copyright (c) Jorge Yagüe París. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSSTableViewController : UITableViewController <NSXMLParserDelegate> 
{ 
    BOOL waitingForEntryTitle;
    NSMutableArray *canciones;
    NSMutableData *xmlData; 
    NSURLConnection *conexion;
    NSMutableString *titulo;
}

-(void)cargaCanciones;

@end
