//
//  DFSDetailViewController.m
//  Math with Nerds
//
//  Created by Chris Bougher on 9/30/13.
//  Copyright (c) 2013 Chris Bougher. All rights reserved.
//

#import "DFSDetailViewController.h"
#import "DFSGame.h"

/* private interface */
@interface DFSDetailViewController ()
- (void)configureView;
@end

@implementation DFSDetailViewController

@synthesize game = _game;

#pragma alertview delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // go back to list
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(NSManagedObject *)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

/* set up the view to reflect the current model state */
- (void)configureView
{
    self.game =  (DFSGame *)[NSKeyedUnarchiver unarchiveObjectWithData:[self.detailItem valueForKey:@"data"]];
    // Update the user interface for the detail item.

	if (self.game) {
        self.navLabel.text = self.game.description;
        self.passOrPlayButton.title = @"Pass";
		self.gameView.game = self.game;
		self.tileView1.tile = self.game.currentPlayer.tileSet[0];
		self.tileView2.tile = self.game.currentPlayer.tileSet[1];
		self.tileView3.tile = self.game.currentPlayer.tileSet[2];
		self.tileView4.tile = self.game.currentPlayer.tileSet[3];
		self.tileView5.tile = self.game.currentPlayer.tileSet[4];
		self.tileView6.tile = self.game.currentPlayer.tileSet[5];
		self.tileView7.tile = self.game.currentPlayer.tileSet[6];
		self.tileView8.tile = self.game.currentPlayer.tileSet[7];
		self.tileView9.tile = self.game.currentPlayer.tileSet[8];
		self.tileView10.tile = self.game.currentPlayer.tileSet[9];
		self.tileView1.originalFrame = self.tileView1.frame;
		self.tileView2.originalFrame = self.tileView2.frame;
		self.tileView3.originalFrame = self.tileView3.frame;
		self.tileView4.originalFrame = self.tileView4.frame;
		self.tileView5.originalFrame = self.tileView5.frame;
		self.tileView6.originalFrame = self.tileView6.frame;
		self.tileView7.originalFrame = self.tileView7.frame;
		self.tileView8.originalFrame = self.tileView8.frame;
		self.tileView9.originalFrame = self.tileView9.frame;
		self.tileView10.originalFrame = self.tileView10.frame;
		self.player1Label.text = self.game.player1.description;
		self.player2Label.text = self.game.player2.description;
		self.player1ScoreLabel.text = [NSString stringWithFormat:@"%d", self.game.player1.score];
		self.player2ScoreLabel.text = [NSString stringWithFormat:@"%d", self.game.player2.score];
		if (self.game.currentPlayer == self.game.player1) {
			self.player1Label.font = [UIFont boldSystemFontOfSize:self.player1Label.font.pointSize];
			self.player2Label.font = [UIFont systemFontOfSize:self.player1Label.font.pointSize];
		} else {
			self.player2Label.font = [UIFont boldSystemFontOfSize:self.player2Label.font.pointSize];
			self.player1Label.font = [UIFont systemFontOfSize:self.player1Label.font.pointSize];
		}
		
	}
    
    // scroll view TODO
//    self.boardScrollView.delegate = self;
//    self.boardScrollView.maximumZoomScale = 2.0;
//    self.boardScrollView.minimumZoomScale = 1.0;
//    self.boardScrollView.contentSize = self.gameView.frame.size;
}

/* respnd to changes in the game model */
- (void)updatePlayerDisplay:(NSNotification *)note
{
    // update labels
	self.player1Label.text = self.game.player1.description;
	self.player2Label.text = self.game.player2.description;
	self.player1ScoreLabel.text = [NSString stringWithFormat:@"%d", self.game.player1.score];
	self.player2ScoreLabel.text = [NSString stringWithFormat:@"%d", self.game.player2.score];
	if (self.game.currentPlayer == self.game.player1) {
		self.player1Label.font = [UIFont boldSystemFontOfSize:self.player1Label.font.pointSize];
		self.player2Label.font = [UIFont systemFontOfSize:self.player1Label.font.pointSize];
	} else {
		self.player2Label.font = [UIFont boldSystemFontOfSize:self.player2Label.font.pointSize];
		self.player1Label.font = [UIFont systemFontOfSize:self.player1Label.font.pointSize];
	}
    
    // save game to db
    NSNumber *status = @0;
    if (self.game.currentPlayer == self.game.player2) {
        status = @1;
    }
    if (self.game.gameIsOver) {
        status = @2;
    }
    [self.detailItem setValue:[NSKeyedArchiver archivedDataWithRootObject:self.game]  forKey:@"data"];
	[self.detailItem setValue:status forKey:@"status"];
    [[self.detailItem managedObjectContext] save:nil];
    
    // game over or changed players?
    if ([note.name isEqualToString:@"Game Ended"]) {
        // show popup with game results
        [[[UIAlertView alloc] initWithTitle:@"Game Over!" message:self.game.description delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    } else {
        // go back to list
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/* view loaded so start observing */
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[self configureView];
	
	// attach notification listeners
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlayerDisplay:) name:@"Current Player Changed" object:self.game];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlayerDisplay:) name:@"Game Ended" object:self.game];
}

/* view about to unload so stop observing */
- (void)viewWillDisappear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Gesture Recognizers
- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {

	DFSTileView *view = (DFSTileView *)recognizer.view;
	CGPoint translation;

    // check the state
	switch (recognizer.state) {
		case UIGestureRecognizerStateEnded:
			if (![self.gameView placeTileView:view atPoint:view.center]) {
				[self.gameView removeTileView:view];
				[view moveBackToTray];
			}
			break;
			
		case UIGestureRecognizerStateCancelled:
			[view moveBackToTray];
			break;
			
		case UIGestureRecognizerStateBegan:
			[self.gameView removeTileView:view];
			break;
			
		default:
			translation = [recognizer translationInView:self.view];
			view.center = CGPointMake(view.center.x + translation.x,
									  view.center.y + translation.y);
			[recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
			break;
	}
    
    // update button text
    if (self.game.hasPlacedTiles) {
        self.passOrPlayButton.title = @"Play";
    } else {
        self.passOrPlayButton.title = @"Pass";
    }

}

#pragma mark - Scroll view delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.gameView;
}

#pragma mark - button actions
- (IBAction)swapTiles:(id)sender {
    [self.gameView recallTiles];
    
	NSString *error;
	[self.game swapTiles:self.game.currentPlayer.tileSet ForPlayer:self.game.currentPlayer returnError:&error];
	
	self.tileView1.tile = self.game.currentPlayer.tileSet[0];
	self.tileView2.tile = self.game.currentPlayer.tileSet[1];
	self.tileView3.tile = self.game.currentPlayer.tileSet[2];
	self.tileView4.tile = self.game.currentPlayer.tileSet[3];
	self.tileView5.tile = self.game.currentPlayer.tileSet[4];
	self.tileView6.tile = self.game.currentPlayer.tileSet[5];
	self.tileView7.tile = self.game.currentPlayer.tileSet[6];
	self.tileView8.tile = self.game.currentPlayer.tileSet[7];
	self.tileView9.tile = self.game.currentPlayer.tileSet[8];
	self.tileView10.tile = self.game.currentPlayer.tileSet[9];

	[self.gameView setNeedsDisplay];
}

- (IBAction)recallTiles:(id)sender {
	[self.gameView recallTiles];
    self.passOrPlayButton.title = @"Pass";
}

- (IBAction)passOrPlay:(UIBarButtonItem *)sender {
	NSString *error;
    if ([sender.title isEqualToString:@"Pass"]) {
        [self.game passTurnForPlayer:self.game.currentPlayer returnError:&error];
    } else {
        [self.game completeTurnForPlayer:self.game.currentPlayer returnError:&error];
    }
    if (error) {
        self.navLabel.text = error;
    }
}

- (IBAction)resign:(id)sender {
    NSString *error;
	[self.game resignGameByPlayer:self.game.currentPlayer returnError:&error];
    if (error) {
        self.navLabel.text = error;
    }
}

@end
