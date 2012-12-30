//
//  DetailViewController.m
//  Wundertest
//
//  Created by Sergo Beruashvili on 12/30/12.
//  Copyright (c) 2012 Sergo Beruashvili. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"

@interface DetailViewController ()
{
    BOOL star;
    BOOL completed;
}

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // we want to have toolbar in keyboard with Done button
    UIToolbar *keyBoardToolBar = [[UIToolbar alloc] init];
    keyBoardToolBar.barStyle = UIBarStyleBlack;
    keyBoardToolBar.tintColor = [UIColor blackColor];
    [keyBoardToolBar setTranslucent:YES];
    [keyBoardToolBar sizeToFit];
    
    // flexible space between buttons
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hideKeyBoard)];
    
    keyBoardToolBar.items = @[space,done];
    
    self.titleTextField.inputAccessoryView = keyBoardToolBar;
    self.titleTextField.delegate = self;
    
    self.noteTextView.inputAccessoryView = keyBoardToolBar;
    self.noteTextView.delegate = self;
    
}

-(void)hideKeyBoard {
    [self.titleTextField resignFirstResponder];
    [self.noteTextView resignFirstResponder];
    [self.delegate stopEditing];
}
// after setting detailview`s currentItem object , lets update our view
-(void)updateView {
    // set title textfield`s content
    self.titleTextField.text = self.currentItem.title;
    // item`s note
    self.noteTextView.text = self.currentItem.note;
    // create dateformater to get Item`s addDate and completeDate
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    self.addDateLabel.text = [NSString stringWithFormat:@"Added on %@",[df stringFromDate:self.currentItem.addDate]];
    // if Item is starred , we will set button image as starred
    if([[self.currentItem isStarred] boolValue]) {
        [self.starButton setImage:[UIImage imageNamed:@"ItemStarred"] forState:UIControlStateNormal];
        star = YES;
    } else {
        [self.starButton setImage:[UIImage imageNamed:@"ItemUnstarred"] forState:UIControlStateNormal];
        star = NO;
    }
    // if Item is completed we will set button image as completed and set completed label`s text for its completion time
    if([[self.currentItem isCompleted] boolValue]) {
        [self.completeButton setImage:[UIImage imageNamed:@"ItemCheckBoxChecked"] forState:UIControlStateNormal];
        completed = YES;
        self.completeDateLabel.text = [NSString stringWithFormat:@"Completed on %@" ,[df stringFromDate:self.currentItem.completeDate]];
        
    } else {
        [self.completeButton setImage:[UIImage imageNamed:@"ItemCheckBoxUnChecked"] forState:UIControlStateNormal];
        completed = NO;
        self.completeDateLabel.text = @"";
    }
    
}

- (void)viewDidUnload {
    [self setCompleteDateLabel:nil];
    [self setAddDateLabel:nil];
    [self setStarButton:nil];
    [self setCompleteButton:nil];
    [self setTitleTextField:nil];
    [self setNoteTextView:nil];
    [self setContainerView:nil];
    [super viewDidUnload];
}
- (IBAction)completeItem:(id)sender {
    
    if(!completed) {
        [self.completeButton setImage:[UIImage imageNamed:@"ItemCheckBoxChecked"] forState:UIControlStateNormal];
        completed = YES;
    } else {
        [self.completeButton setImage:[UIImage imageNamed:@"ItemCheckBoxUnChecked"] forState:UIControlStateNormal];
        completed = NO;
    }
    
}

- (IBAction)starItem:(id)sender {
    
    if(!star) {
        [self.starButton setImage:[UIImage imageNamed:@"ItemStarred"] forState:UIControlStateNormal];
        star = YES;
    } else {
        [self.starButton setImage:[UIImage imageNamed:@"ItemUnstarred"] forState:UIControlStateNormal];
        star = NO;
    }
    
}
// after user saves presses Save button , we will update our Item object and tell delegate to persist changes
- (IBAction)saveEditing:(id)sender {
    
    
    self.currentItem.title = self.titleTextField.text;
    self.currentItem.note = self.noteTextView.text;
    // we want to set starred if it is not already starred and user wants to star it ,  or otherwise
    if(star) {
        
        if(![self.currentItem.isStarred boolValue]) {
            self.currentItem.isStarred = [NSNumber numberWithBool:YES];
            self.currentItem.starDate = [NSDate date];
        }
        
    } else {
        
        if([self.currentItem.isStarred boolValue]) {
            self.currentItem.isStarred = [NSNumber numberWithBool:NO];
            self.currentItem.starDate = nil;
        }
        
    }
    // we want to set completed if it is not already completed and user wants to complete it ,  or otherwise also completion Time
    if(completed) {
        
        if(![self.currentItem.isCompleted boolValue]) {
            self.currentItem.isCompleted = [NSNumber numberWithBool:YES];
            self.currentItem.completeDate = [NSDate date];
        }
        
    } else {
        
        if([self.currentItem.isCompleted boolValue]) {
            self.currentItem.isCompleted = [NSNumber numberWithBool:NO];
            self.currentItem.completeDate = nil;
        }
        
    }
    // tell delegate to save item
    [self.delegate saveItem];
    
}

- (IBAction)cancelEditing:(id)sender {
    [self hideKeyBoard];
    [self.delegate cancelSaving];
}


#pragma mark -
#pragma mark TextField & textview delegates
// if device is iPhone we want custom core animation while user is editing its fields
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if(![AppDelegate isIpad]) {
        [self.delegate startEditing];
    }
    return YES;
}


-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if(![AppDelegate isIpad]) {
        [self.delegate startEditing];
    }
    return YES;
}


@end
