//
//  DFSDetailViewController.h
//  Math with Nerds
//
//  Created by Chris Bougher on 9/30/13.
//  Copyright (c) 2013 Chris Bougher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFSGame.h"
#import "DFSGameBoard.h"
#import "DFSTileView.h"

@interface DFSDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) DFSGame *detailItem;
@property (weak, nonatomic) IBOutlet DFSGameBoard *gameView;

@property (weak, nonatomic) IBOutlet DFSTileView *tileView1;
@property (weak, nonatomic) IBOutlet DFSTileView *tileView2;
@property (weak, nonatomic) IBOutlet DFSTileView *tileView3;
@property (weak, nonatomic) IBOutlet DFSTileView *tileView4;
@property (weak, nonatomic) IBOutlet DFSTileView *tileView5;
@property (weak, nonatomic) IBOutlet DFSTileView *tileView6;
@property (weak, nonatomic) IBOutlet DFSTileView *tileView7;
@property (weak, nonatomic) IBOutlet DFSTileView *tileView8;
@property (weak, nonatomic) IBOutlet DFSTileView *tileView9;
@property (weak, nonatomic) IBOutlet DFSTileView *tileView10;
@property (weak, nonatomic) IBOutlet UILabel *player1Label;
@property (weak, nonatomic) IBOutlet UILabel *player2Label;
@property (weak, nonatomic) IBOutlet UILabel *player1ScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *player2ScoreLabel;

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer;

@end
