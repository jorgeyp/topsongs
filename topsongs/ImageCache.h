//
//  ImageCache.h
//  topsongs
//
//  Created by Jorge Yagüe París on 24/10/12.
//
//

#import <Foundation/Foundation.h>

@interface ImageCache : NSObject
{
    NSMutableDictionary *dictionary;
}
+(ImageCache *)sharedImageCache;
-(void)setImage:(UIImage *)i forKey:(NSString *)s;
-(UIImage *)imageForKey:(NSString *)s;
-(void)deleteImageForKey:(NSString *)s;

@end
