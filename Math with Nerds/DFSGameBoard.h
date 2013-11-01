//
//  DFSGameBoard.h
//  Math with Nerds
//
//  Created by Chris Bougher on 10/27/13.
//  Copyright (c) 2013 Chris Bougher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFSGame.h"
#import "DFSBoardSpace.h"
#import "DFSTileView.h"

@interface DFSGameBoard : UIView

@property (strong, nonatomic) DFSGame *game;

- (BOOL)placeTileView:(DFSTileView *)view atPoint:(CGPoint)point;
- (void)recallTiles;
- (void)removeTileView:(DFSTileView *)view;

@end
