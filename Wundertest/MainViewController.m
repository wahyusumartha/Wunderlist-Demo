//
//  MainViewController.m
//  Wundertest
//
//  Created by Sergo Beruashvili on 12/29/12.
//  Copyright (c) 2012 Sergo Beruashvili. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "Item.h"

@interface MainViewController ()
{
    BOOL star;
}

@end

@implementation MainViewController

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize context = _context;
@synthesize entity = _entity;
@synthesize addItemCell = _addItemCell;
@synthesize starButton = _starButton;
@synthesize menuView = _menuView;
@synthesize detailView = _detailView;

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
    
    // Initially set star status to NO , user will change it if wants
    star = NO;
    
    // set background image for tableview in WunderList style
    UIImage *bgImage = [UIImage imageNamed:@"bg.jpg"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    [bgImageView setFrame:self.tableView.frame];
    [self.tableView setBackgroundView:bgImageView];
    
    
    
    
    
    NSError *error = nil;
    
    /* Create few objects with code
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item"
                                              inManagedObjectContext:self.context];
    
    for(int i = 0;i <= 9;i++) {
    
    Item *it = [[Item alloc] initWithEntity:entity insertIntoManagedObjectContext:self.context];
    
        it.isCompleted = [NSNumber numberWithBool:(i % 2 == 0 )];
        it.isStarred = [NSNumber numberWithBool:(i % 3 == 0 )];
        it.addDate = [NSDate date];
        it.starDate = [NSDate date];
        it.title = [NSString stringWithFormat:@"Cell Row %i",i];
    
        [self.context save:&error];
        
    }
    */
    
    if(![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Error %@",error);
    }
    
}


- (void)viewDidUnload {
    [self setTableView:nil];
    [self setNavigationBar:nil];
    [self setTableNavigationItem:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// set/unset editing table view 
-(IBAction)editButtonAction:(id)sender {
    
    if([self.tableView isEditing]) {
        [self.tableView setEditing:NO animated:YES];
        self.tableNavigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonAction:)];
    } else {
        [self.tableView setEditing:YES animated:YES];
        self.tableNavigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editButtonAction:)];
    }
    
}
// show / hide left menu
- (IBAction)menuAction:(id)sender {
    // if device is ipad , we want to show menu in Popover controller
    if([AppDelegate isIpad]) {
        
        if(self.popover != nil && [self.popover isPopoverVisible]) {
            [self.popover dismissPopoverAnimated:YES];
        } else {
            
            self.popover = [[UIPopoverController alloc] initWithContentViewController:self.menuView];
            [self.popover presentPopoverFromBarButtonItem:(UIBarButtonItem *)sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
        }
        // else use core animation to display menu from left
    } else {
        
        CGRect t2 = self.menuView.view.frame;
        if(t2.origin.x < 0) {
            [self showMenu];
        } else {
            [self hideMenu];
        }
        
    }
    
}

// shows menu
-(void)showMenu {
    // hide detail view while showing left menu
    [self hideDetailView];
    
    CGRect f = self.menuView.view.frame;
    f.origin.x = 0;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.menuView.view.frame = f;
    }];
    
}
// hides menu
-(void)hideMenu {
    
    CGRect f = self.menuView.view.frame;
    f.origin.x = -1000;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.menuView.view.frame = f;
    }];
    
}
// shows detail view for iphone
-(void)showDetailView {
    // hides left menu while showing detail view
    [self hideMenu];
    
    CGRect f = self.detailView.view.frame;
    CGRect f2 = self.view.frame;
    
    f.origin.x = f2.size.width - f.size.width;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.detailView.view.frame = f;
    }];
    
}
// hides detail view , if device is ipad hides popover , else hides view with core animation
-(void)hideDetailView {
    
    if([AppDelegate isIpad]) {
        if(self.popover != nil && [self.popover isPopoverVisible]) {
            [self.popover dismissPopoverAnimated:YES];
        }
        return;
    }
    
    CGRect f = self.detailView.view.frame;
    f.origin.x = 2000;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.detailView.view.frame = f;
    }];
    
}

#pragma mark - Table view data source

/*
 
 We want to have 3 sections in table ,
 1 section = section for adding new items
 2 section = section containing uncompleted items
 3 section = section containing completed items
 
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count] + 1; // + 1 extra section for adding new items
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // if section = 0 then it is for adding new items , we need only 1 row in it
    if(section == 0) {
        return 1;
    }
    
    // get count of items from fetchedresultscontroller
    id<NSFetchedResultsSectionInfo> secInfo = [[self.fetchedResultsController sections] objectAtIndex:section - 1];
    return [secInfo numberOfObjects]; 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // if section is = then we need cell for adding new items , we have a property for this
    if(indexPath.section == 0) {
        return self.addItemCell;
    }
    
    // creating cells for items
    static NSString *CellIdentifier = @"ItemCell";
    ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    // setting Item object for cell
    cell.currentItem = [self.fetchedResultsController objectAtIndexPath:[self subSectionToIndexPath:indexPath]];
    // setting itemDelegate to self , we will update contect after cell controls update Item object
    cell.itemDelegate = self;
    // custom initialization for custom cell , this will set background image and alpha , right and left button images and label
    [cell customInit];
    
    return cell;
}

// Get the title for headers , headers will be Recently added and Recently completed , we dont need header for new item section
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    // get name from fetchedresultscontroller for current section
    NSString *tempName = [[[self.fetchedResultsController sections] objectAtIndex:section - 1] name];

    // because we have bool value in Core Data for this column , we get 0 or 1 , we will return NSString according to it
    
    // 0 Means isCompleted = 0 , so it is not completed , it is Recently added section
    if([tempName isEqualToString:@"0"]) {
        return @"Recently Added";
    } else if([tempName isEqualToString:@"1"]) { // Section for completed
        return @"Recently Completed";
    }
    
    // this method will never return this value , but i needed it for testing purposes
    return @"Add New Item";
}

// we want to have custom view for header , without its background color/image
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    // we do not want any custom view for new item section , just return empty view
    if(section == 0) {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    // we want to have labeled view for another 2 sections
    
    // create new label
    UILabel *temp = [[UILabel alloc] init];
    // assign text to label from nsfetchresultscontroller
    temp.text = [self tableView:tableView titleForHeaderInSection:section];
    // clear background , we do not want any custom background fot this label
    temp.backgroundColor = [UIColor clearColor];
    // align center label`s text
    temp.textAlignment = NSTextAlignmentCenter;
    // make font a little bit more than Items font
    temp.font = [UIFont boldSystemFontOfSize:18];
    // make size to fit view
    [temp sizeToFit];
    return temp;
}



// we do not want our Add New Item row to be Delete-able , so we will return NO for this item
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
     return indexPath.section != 0;
 }
 

// this is called when object is edited , we will listen only for delete right now
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
       // get Item from fetchresult controller wich was deleted from tableview
        Item *it = [self.fetchedResultsController objectAtIndexPath:[self subSectionToIndexPath:indexPath]];
        // Delete object from context
        [self.context deleteObject:it];
        // create error holder
        NSError *error = nil;
        // save contect after deleting an object
        [self.context save:&error];
        // if error is not null , it means something went wrong and we will see it in log
        if(error) {
            NSLog(@"error deleting object %@",error);
        }
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // we do not want anything if add new cell was selected
    if(indexPath.section == 0) {
        return;
    }
    
    // add current Item to detail view , and update it`s view
    self.detailView.currentItem = [self.fetchedResultsController objectAtIndexPath:[self subSectionToIndexPath:indexPath]];
    [self.detailView updateView];
    // if a device is ipad , we want to show detail in popover , otherwise we will display it with core animation
    if([AppDelegate isIpad]) {
        // if another popover is already visible , hide it
        if(self.popover != nil && [self.popover isPopoverVisible]) {
            [self.popover dismissPopoverAnimated:NO];
        }
        // create new popover and set its frame
        self.popover = [[UIPopoverController alloc] initWithContentViewController:self.detailView];
        [self.popover setPopoverContentSize:self.detailView.containerView.frame.size];
        // get selected cell , we want its frame to display popover from there
        UITableViewCell *tempCell = [tableView cellForRowAtIndexPath:indexPath];
        
        // display popover from tempcell`s location
        [self.popover presentPopoverFromRect:tempCell.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    } else {
        // shows detailview with core animation for iphone
        [self showDetailView];
        
    }

}

// while TextField is focused and user scrolls tableview , we want to hide keyboard
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self hideKeyBoard];
}

#pragma mark -
#pragma mark Fetched Results Controller
// Initialize fetchresultController
-(NSFetchedResultsController *)fetchedResultsController {
    
    // if we already have fetchresultscontroller just return it
    if(_fetchedResultsController == nil) {
        // create new request
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // add Item entity
        [fetchRequest setEntity:self.entity];
        // order by isCompleted descending
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"isCompleted" ascending:YES];
        // order by isStarred ascending , so starred items will apear first
        NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"isStarred" ascending:NO];
        // order by starDate , we want to maintain order in starred items by its date of marking as starred
        NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"starDate" ascending:NO];
        // if object is completed , we want it to be sorted by completeDate
        NSSortDescriptor *sortDescriptor3 = [[NSSortDescriptor alloc] initWithKey:@"completeDate"
                                                                       ascending:YES];
        // and final sort descriptor is Item create date
        NSSortDescriptor *sortDescriptor4 = [[NSSortDescriptor alloc] initWithKey:@"addDate" ascending:NO];
        // create array for containing our sort descriptors
        NSArray *sortDescriptors = @[sortDescriptor,sortDescriptor1,sortDescriptor2,sortDescriptor3,sortDescriptor4];
        // set sort descriptors to fetchrequest
        [fetchRequest setSortDescriptors:sortDescriptors];
        // initialize our fetchrequestcontroller with fetchrequest and sectionname ( AKA group by ) isCompleted, so we will have two sections , onw for completed items and second for uncompleted items , also we could use caching here but lets move on for now
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:@"isCompleted" cacheName:nil];
        
        _fetchedResultsController.delegate = self;
        
    }
    
    return _fetchedResultsController;
}
// fetched results controller has some changes , we will update our table view  , so prepare tableview for it
-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}
// fetched results controller changed object , we updated our tableview
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

// this method gets called while nsfetchresultscontroller changes objects , we will perform our actions according changetype
-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    

    
    switch (type) {
            // fetchedresultscontroller has a new item  , so lets add it to our tableview
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[[self addSectionToIndexPath:newIndexPath]] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            // fetchedresultscontroller removed an item , so lets remove from tableview also
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[[self addSectionToIndexPath:indexPath]] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
            //fetchedresultscontroller changed an object , we want to update cell for that row
        case NSFetchedResultsChangeUpdate: {
            ItemCell *cell = (ItemCell *)[self.tableView cellForRowAtIndexPath:[self addSectionToIndexPath:indexPath]];
            [cell updateCell];
        }
            break;
            // fetchedresutsctonroller moved object , also move it in our tableview
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[[self addSectionToIndexPath:indexPath]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView insertRowsAtIndexPaths:@[[self addSectionToIndexPath:newIndexPath]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }

    
}

// this method gets called when WHOLE section is changed , if there is no rows in sections it is deleted from our tableview
-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex + 1] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex + 1] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
    
}


#pragma mark -
#pragma mark ItemCell Delegate
// ItemCell Delegate method , after changing an object , we want to persist it and update our tableview
-(void)cellItemDidUpdate {
    
    NSError *error = nil;
    
    [self.context save:&error];
    
    if(error) {
        NSLog(@"Error completting item %@",error);
    }
}

#pragma mark -
#pragma mark Menu & Detail view delegate
//when user swipes , we will hide menu
-(void)viewControllerDidSwipeToClose {
    [self hideMenu];
}
// user has made changes , lets persist it and nsfetchedresultscontroller will be updated
-(void)saveItem {
    
    NSError *error = nil;
    
    [self.context save:&error];
    
    if(error) {
        NSLog(@"Error saving item %@",error);
    }
    // hide detail view after saving an object
    [self hideDetailView];
}
// user canceled saving , just hide detail view
-(void)cancelSaving {
    [self hideDetailView];
}
// if device is iPhone , detail view does not fit so well so , while user is editing , we will use core animation , we will put detail view a little bit higher so user can see textfield and textview good enough
-(void)startEditing {
    
    CGRect f = self.detailView.view.frame;
    
    if( f.origin.y != 44 ) {
        return;
    }
    
    f.origin.y -= self.detailView.titleTextField.frame.origin.y + self.detailView.containerView.frame.origin.y ;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.detailView.view.frame = f;
    }];
    
}
// if device is iphone , put detailview on its place
-(void)stopEditing {
    
    CGRect f = self.detailView.view.frame;
    f.origin.y = 44;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.detailView.view.frame = f;
    }];
    
}

#pragma mark -
#pragma mark Lazy Inits

/*
 
 These are some basic lazy initializations
 
 */

-(DetailViewController *)detailView {
    if(_detailView == nil) {
        
        _detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
        _detailView.delegate = self;
        
        if(![AppDelegate isIpad]) {
            CGRect tempFrame = _detailView.view.frame;
            tempFrame.origin.y = 44;
            tempFrame.origin.x = 2000;
            tempFrame.size.width = _detailView.containerView.frame.size.width;
            _detailView.view.frame = tempFrame;
            // we want our detailview to be under navigation bar
            [self.view insertSubview:_detailView.view belowSubview:self.navigationBar];
        }
        
        
    }
    
    return _detailView;
}

-(MenuViewController *)menuView {
    
    if(_menuView  == nil) {
        
        _menuView = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
        _menuView.delegate = self;
        
        if(![AppDelegate isIpad]) {
            CGRect tempFrame = _menuView.view.frame;
            tempFrame.origin.y = 44;
            tempFrame.origin.x = -1000;
            tempFrame.size.width = 240;
            _menuView.view.frame = tempFrame;
            [self.view addSubview:_menuView.view];
        }
        
                
    }
    
    return _menuView;
}

-(NSEntityDescription *)entity {
    if(_entity == nil) {
        _entity = [NSEntityDescription entityForName:@"Item"
                              inManagedObjectContext:self.context];

    }
    
    return _entity;
}

-(NSManagedObjectContext *)context {
    
    if(_context == nil) {
        AppDelegate *del = [[UIApplication sharedApplication] delegate];
        _context = del.managedObjectContext;
    }
    
    return _context;
}


-(UIButton *)starButton {
    
    if(_starButton == nil) {

        _starButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_starButton setImage:[UIImage imageNamed:@"ItemNewInputStarUnselected"] forState:UIControlStateNormal];
        [_starButton addTarget:self action:@selector(starButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [_starButton setFrame:CGRectMake(0 ,0 ,self.addItemCell.textField.frame.size.height/2, self.addItemCell.textField.frame.size.height/2)];
    }
    
    return _starButton;
}

-(NewItemCell *)addItemCell {
    if(_addItemCell == nil) {
        _addItemCell = [self.tableView dequeueReusableCellWithIdentifier:@"newItemCell"];
        
        if(_addItemCell == nil) {
            _addItemCell = [[NewItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newItemCell"];
        }
        [_addItemCell customInit];
        
        // we want to have toolbar in keyboard with Add/Cancel button
        UIToolbar *keyBoardToolBar = [[UIToolbar alloc] init];
        keyBoardToolBar.barStyle = UIBarStyleBlack;
        keyBoardToolBar.tintColor = [UIColor blackColor];
        [keyBoardToolBar setTranslucent:YES];
        [keyBoardToolBar sizeToFit];
        
        // flexible space between buttons
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *addNewItemButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(addNewItem:)];
        UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTouched:)];
        keyBoardToolBar.items = @[cancel,space,addNewItemButton];
        
        _addItemCell.textField.inputAccessoryView = keyBoardToolBar;
        _addItemCell.textField.rightView = self.starButton;
        _addItemCell.textField.rightViewMode = UITextFieldViewModeAlways;
    }
    
    return _addItemCell;
}

#pragma mark -
#pragma mark NSindexPath Add/Substract Section

// we need to recalculate indexPath because of our extra section for adding new items
-(NSIndexPath *)addSectionToIndexPath:(NSIndexPath *)indexPath {
    return [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section + 1];
}

-(NSIndexPath *)subSectionToIndexPath:(NSIndexPath *)indexPath {
    return [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 1];
}

#pragma mark -
#pragma mark TextField & New Item Methods
// hide new item textfield`s keyboard and set its text to empty string
-(void)hideKeyBoard {
    [self.addItemCell.textField setText:@""];
    [self.addItemCell.textField resignFirstResponder];
}
// set starring
-(void)starButtonTouched:(id)sender {
    if(star) {
        star = NO;
        [self.starButton setBackgroundImage:[UIImage imageNamed:@"ItemNewInputStarUnselected"] forState:UIControlStateNormal];
    } else {
        star = YES;
        [self.starButton setBackgroundImage:[UIImage imageNamed:@"ItemNewInputStarSelected"] forState:UIControlStateNormal];
    }
}

// User wants to add new item , lets do it
-(void)addNewItem:(id)sender {
    
    // if there is no text entered , we will just return for now , also we could inform user about this , or we could tell them what is minimum length of Item title
    if([self.addItemCell.textField.text length] < 1) {
        [self hideKeyBoard];
        return;
    }
    
    // if there is something in textfield , we create a new object
    Item *it = [[Item alloc] initWithEntity:self.entity insertIntoManagedObjectContext:self.context];
    // customize it
    it.title = self.addItemCell.textField.text;
    it.isStarred = [NSNumber numberWithBool:star];
    it.addDate = [NSDate date];

    NSError *error = nil;
    // and save 
    [self.context save:&error];
    
    if(error) {
        NSLog(@"error inserting new item => %@ , error => %@ ",it,error);
    }
    
    [self hideKeyBoard];
}
// user canceled adding new item  , just hide keyboard and set its content to empty string
-(void)cancelButtonTouched:(id)sender {
    [self hideKeyBoard];
}

@end
