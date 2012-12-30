//
//  NewItemCell.h
//  Wundertest
//
//  Created by Sergo Beruashvili on 12/29/12.
//  Copyright (c) 2012 Sergo Beruashvili. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewItemCell : UITableViewCell
// textfield for new items
@property (weak, nonatomic) IBOutlet UITextField *textField;
// custom initialization for cell
-(void)customInit;

@end
