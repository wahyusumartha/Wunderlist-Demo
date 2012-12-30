//
//  ItemCell.m
//  Wundertest
//
//  Created by Sergo Beruashvili on 12/29/12.
//  Copyright (c) 2012 Sergo Beruashvili. All rights reserved.
//

#import "ItemCell.h"
#import "AppDelegate.h"

@implementation ItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

// custom initialization

-(void)customInit {
    // set background
    UIImage *bg = nil;
    
    if([AppDelegate isIpad]) {
        bg = [UIImage imageNamed:@"ItemBackground_iPad"];
    } else {
        bg = [UIImage imageNamed:@"ItemBackground"];        
    }
    
    UIImageView *bgView = [[UIImageView alloc] initWithImage:bg];
    self.backgroundView = bgView;
    // update cell according Item object
    [self updateCell];
    
}

// update cell`s views with Item object
-(void)updateCell {
    
    self.label.text = self.currentItem.title;
    
    if([[self.currentItem isStarred] boolValue]) {
        [self.starButton setImage:[UIImage imageNamed:@"ItemStarred"] forState:UIControlStateNormal];
    } else {
        [self.starButton setImage:[UIImage imageNamed:@"ItemUnstarred"] forState:UIControlStateNormal];
    }
    
    if([[self.currentItem isCompleted] boolValue]) {
        [self.completeButton setImage:[UIImage imageNamed:@"ItemCheckBoxChecked"] forState:UIControlStateNormal];
        [self.backgroundView setAlpha:0.6f];
    } else {
        [self.completeButton setImage:[UIImage imageNamed:@"ItemCheckBoxUnChecked"] forState:UIControlStateNormal];
        [self.backgroundView setAlpha:1.0f];
    }
}

// check if Item is starred , change it value , then tell delegate to persist an object
- (IBAction)starItem:(id)sender {
    
    if([[self.currentItem isStarred] boolValue]) {
        self.currentItem.isStarred = [NSNumber numberWithBool:NO];
        self.currentItem.starDate = nil;
    } else {
        self.currentItem.isStarred = [NSNumber numberWithBool:YES];
        self.currentItem.starDate = [NSDate date];
    }
    
    [self.itemDelegate cellItemDidUpdate];
}
// check if Item is completed , change it valie , then tell delegate to persist an object
- (IBAction)completeItem:(id)sender {
    
    if([[self.currentItem isCompleted] boolValue]) {
        self.currentItem.isCompleted = [NSNumber numberWithBool:NO];
        self.currentItem.completeDate = nil;
    } else {
        self.currentItem.isCompleted = [NSNumber numberWithBool:YES];
        self.currentItem.completeDate = [NSDate date];
    }
    
    [self.itemDelegate cellItemDidUpdate];
}

// we want to hide starButton during editing
-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    
    self.starButton.hidden = editing;
    
}

// we do not want selection appearance
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    return;
    [super setSelected:selected animated:animated];

    
}



@end
