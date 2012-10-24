//
//  SongDetailViewController.h
//  topsongs
//
//  Created by Jorge Yagüe París on 17/10/12.
//
//

#import <UIKit/UIKit.h>

@class Cancion;

@interface SongDetailViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    IBOutlet UILabel *labelTitle;
    IBOutlet UILabel *labelArtist;
    IBOutlet UILabel *labelDuration;
    IBOutlet UILabel *labelPrice;
    IBOutlet UILabel *labelCopyright;
    IBOutlet UILabel *labelLink;
    IBOutlet UIButton *buttonLink;
    IBOutlet UIImageView *imageView;
    Cancion *cancionActual;
}

@property (nonatomic, assign) Cancion *cancionActual;

-(IBAction)pushedButtonLink:(id)sender;

@end
