//
//  songCell.m
//  topsongs
//
//  Created by Jorge Yagüe París on 22/10/12.
//
//

#import "songCell.h"
#import "Cancion.h"

@implementation songCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCancion:(Cancion *)cancion
{
    self.textLabel.text = cancion.titulo;
}

@end
