//
//  Cancion.m
//  topsongs
//
//  Created by Jorge Yagüe París on 21/10/12.
//
//

#import "Cancion.h"

@implementation Cancion

@synthesize titulo, artista, duracion, precio, copyright, enlace, imageKey;

-(void)dealloc{
    [titulo release];
    [artista release];
    [duracion release];
    [precio release];
    [copyright release];
    [enlace release];
    [imageKey release];
}

@end
