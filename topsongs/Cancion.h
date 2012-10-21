//
//  Cancion.h
//  topsongs
//
//  Created by Jorge Yagüe París on 21/10/12.
//
//

#import <Foundation/Foundation.h>

@interface Cancion : NSObject

@property (nonatomic, retain) NSString *titulo;
@property (nonatomic, retain) NSString *artista;
@property (nonatomic, retain) NSString *duracion;
@property (nonatomic, retain) NSString *precio;
@property (nonatomic, retain) NSString *copyright;
@property (nonatomic, retain) NSString *enlace;

@end
