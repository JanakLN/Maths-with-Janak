//
//  DFSMasterViewController.h
//  Math with Nerds
//
//  Created by Chris Bougher on 9/30/13.
//  Copyright (c) 2013 Chris Bougher. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DFSDetailViewController;

#import <CoreData/CoreData.h>

@interface DFSMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) DFSDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
