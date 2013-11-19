//
//  DFSSplashViewController.h
//  Math with Nerds
//
//  Created by Chris Bougher on 11/9/13.
//  Copyright (c) 2013 Chris Bougher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFSGameCenterManager.h"

@interface DFSSplashViewController : UIViewController <DFSGameCenterManagerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
