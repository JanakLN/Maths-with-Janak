//
//  DFSTileView.h
//  Math with Nerds
//
//  Created by Chris Bougher on 10/27/13.
//  Copyright (c) 2013 Chris Bougher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFSTile.h"

@interface DFSTileView : UIView

@property (strong, nonatomic) DFSTile *tile;
@property (nonatomic) CGRect originalFrame;

- (void)moveBackToTray;

@end
