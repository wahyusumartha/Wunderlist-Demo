//
//  MenuViewController.h
//  Wundertest
//
//  Created by Sergo Beruashvili on 12/30/12.
//  Copyright (c) 2012 Sergo Beruashvili. All rights reserved.
//

#import <UIKit/UIKit.h>

// we need to inform our main controller to hide menu view after user swipes
@protocol MenuViewControllerDelegate
-(void)viewControllerDidSwipeToClose;
@end

@interface MenuViewController : UITableViewController

@property (nonatomic,strong) id<MenuViewControllerDelegate> delegate;

- (IBAction)userDidSwipe:(id)sender;

@end
