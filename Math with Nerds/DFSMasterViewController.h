//
//  DFSMasterViewController.h
//  Math with Nerds
//
//  Created by Chris Bougher on 9/30/13.
//  Copyright (c) 2013 Chris Bougher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFSGameCenterManager.h"

@class DFSDetailViewController;

@interface DFSMasterViewController : UITableViewController <GKTurnBasedMatchmakerViewControllerDelegate, DFSGameCenterManagerDelegate>

@property (strong, nonatomic) DFSGameCenterManager *gameCenterManager;
@property (strong, nonatomic) NSArray *matches;

@end
