//
//  ImageCache.m
//  topsongs
//
//  Created by Jorge Yagüe París on 24/10/12.
//
//

#import "ImageCache.h"

static ImageCache *sharedImageCache;

@implementation ImageCache

-(id)init
{
    [super init];
    dictionary = [[NSMutableDictionary alloc]init];
    return self;
}
#pragma mark Accediendo a la cache
-(void)setImage:(UIImage *)i forKey:(NSString *)s
{
    [dictionary setObject:i forKey:s];
}
-(UIImage *)imageForKey:(NSString *)s
{
    return [dictionary objectForKey:s];
}
-(void)deleteImageForKey:(NSString *)s
{
    [dictionary removeObjectForKey:s];
}

#pragma mark Singleton
+(ImageCache *)sharedImageCache
{
    if (!sharedImageCache){
        sharedImageCache = [[ImageCache alloc] init];
    }
    return sharedImageCache;
}
+(id)allocWithZone:(NSZone *)zone
{
    if(!sharedImageCache){
        sharedImageCache = [super allocWithZone:zone];
        return sharedImageCache;
    } else{
        return nil;
    } }
-(id)copyWithZone:(NSZone *)zone
{
    return self;
}
-(void)release
{
    //Nada
}

@end
