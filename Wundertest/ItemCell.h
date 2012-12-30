//
//  ItemCell.h
//  Wundertest
//
//  Created by Sergo Beruashvili on 12/29/12.
//  Copyright (c) 2012 Sergo Beruashvili. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

// we will use this delegate method to persist data after changing it
@protocol ItemCellDelegate
-(void)cellItemDidUpdate;
@end

@interface ItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *starButton;

@property (weak,nonatomic) id<ItemCellDelegate> itemDelegate;

@property(strong,nonatomic) Item *currentItem;

-(void)customInit;
-(void)updateCell;

- (IBAction)starItem:(id)sender;
- (IBAction)completeItem:(id)sender;


@end
