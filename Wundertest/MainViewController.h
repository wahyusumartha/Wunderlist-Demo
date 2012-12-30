//
//  MainViewController.h
//  Wundertest
//
//  Created by Sergo Beruashvili on 12/29/12.
//  Copyright (c) 2012 Sergo Beruashvili. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemCell.h"
#import "NewItemCell.h"
#import "MenuViewController.h"
#import "DetailViewController.h"

@interface MainViewController : UIViewController <UITableViewDelegate,UIScrollViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate,ItemCellDelegate,MenuViewControllerDelegate,DetailViewControllerDelegate>

// Main table view controller , containing items
@property (weak, nonatomic) IBOutlet UITableView *tableView;
// Tableview-s Navigationbar
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
// tableviews navigationItem
@property (weak, nonatomic) IBOutlet UINavigationItem *tableNavigationItem;

@property (nonatomic,strong) MenuViewController *menuView;
@property (nonatomic,strong) DetailViewController *detailView;

@property (nonatomic,strong) UIPopoverController *popover;

// set/unset editing to tableview
-(IBAction)editButtonAction:(id)sender;
// show/hide left menu (popover for iPad)
- (IBAction)menuAction:(id)sender;

//Core Data ObjectContext
@property (nonatomic,strong) NSManagedObjectContext *context;
//Item Entity
@property (nonatomic,strong) NSEntityDescription *entity;
//fetched results for Item entities
@property (strong,nonatomic) NSFetchedResultsController *fetchedResultsController;

//first cell , using this cell we can add new items ,
@property (strong,nonatomic) NewItemCell *addItemCell;
//star button , star/unstar new items while adding
@property (strong,nonatomic) UIButton *starButton;


@end
