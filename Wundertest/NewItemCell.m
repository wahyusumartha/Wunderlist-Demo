//
//  NewItemCell.m
//  Wundertest
//
//  Created by Sergo Beruashvili on 12/29/12.
//  Copyright (c) 2012 Sergo Beruashvili. All rights reserved.
//

#import "NewItemCell.h"

@implementation NewItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
// set background image for cell
-(void)customInit {
    
    UIImage *bg = [UIImage imageNamed:@"ItemNewInput"];
    UIImageView *bgView = [[UIImageView alloc] initWithImage:bg];
    self.backgroundView = bgView;
    
}

// we do not want this cell to change its appearance 
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    return;
    
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
