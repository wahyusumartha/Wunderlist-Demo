//
//  DetailViewController.h
//  Wundertest
//
//  Created by Sergo Beruashvili on 12/30/12.
//  Copyright (c) 2012 Sergo Beruashvili. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

// methods for saving item , cancel editing and hide detail view
@protocol DetailViewControllerDelegate

-(void)saveItem;
-(void)cancelSaving;
-(void)startEditing;
-(void)stopEditing;

@end

@interface DetailViewController : UIViewController <UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic,strong) id<DetailViewControllerDelegate> delegate;
@property (nonatomic,strong) Item *currentItem;

@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (weak, nonatomic) IBOutlet UIButton *starButton;

@property (weak, nonatomic) IBOutlet UILabel *addDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *completeDateLabel;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;

@property (weak, nonatomic) IBOutlet UIView *containerView;

// after setting Item object for detail view , we will update detail view according its content
-(void)updateView;

- (IBAction)completeItem:(id)sender;
- (IBAction)starItem:(id)sender;

- (IBAction)saveEditing:(id)sender;
- (IBAction)cancelEditing:(id)sender;


@end
