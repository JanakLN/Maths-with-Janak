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
@interface DFSDetailViewController () {
    UIAlertView *resignConfirm;
    UIAlertView *gameOver;
    UIAlertView *swapConfirm;
    UIAlertView *passConfirm;
}

- (void)configureView;
@end

@implementation DFSDetailViewController

@synthesize game = _game;

#pragma alertview delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString *error;

    // resign
    if (alertView == resignConfirm) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            [self.game resignGameByPlayer:self.game.currentPlayer returnError:&error];
            if (error) {
                self.navLabel.text = error;
            }
        }
    }
    
    // pass
    if (alertView == passConfirm) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            [self.game passTurnForPlayer:self.game.currentPlayer returnError:&error];
        }
    }
    
    // swap - temporary until I can add a swap tiles dialog allowing selection of tiles to swap
    if (alertView == swapConfirm) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            [self.gameView recallTiles];
            
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
    }
    // go back to list
    if (alertView == gameOver) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    // show error
    if (error) {
        self.navLabel.text = error;
    }
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
        gameOver = [[UIAlertView alloc] initWithTitle:@"Game Over!" message:self.game.description delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [gameOver show];
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

#pragma mark - Shake handler
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [self becomeFirstResponder];
}

// shuffle the tiles on the display
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake)
    {
        NSString *error;
        [self.game shuffleTilesForPlayer:self.game.currentPlayer returnError:&error];
        if (error) {
            self.navLabel.text = error;
        } else {
            [self.gameView recallTiles];
            NSArray *tileFrames = [NSArray arrayWithObjects:
                                  [NSValue valueWithCGRect:self.tileView1.originalFrame],
                                  [NSValue valueWithCGRect:self.tileView2.originalFrame],
                                  [NSValue valueWithCGRect:self.tileView3.originalFrame],
                                  [NSValue valueWithCGRect:self.tileView4.originalFrame],
                                  [NSValue valueWithCGRect:self.tileView5.originalFrame],
                                  [NSValue valueWithCGRect:self.tileView6.originalFrame],
                                  [NSValue valueWithCGRect:self.tileView7.originalFrame],
                                  [NSValue valueWithCGRect:self.tileView8.originalFrame],
                                  [NSValue valueWithCGRect:self.tileView9.originalFrame],
                                  [NSValue valueWithCGRect:self.tileView10.originalFrame],
                                  nil];
            NSArray *tileViews = [NSArray arrayWithObjects:
                                  self.tileView1,
                                  self.tileView2,
                                  self.tileView3,
                                  self.tileView4,
                                  self.tileView5,
                                  self.tileView6,
                                  self.tileView7,
                                  self.tileView8,
                                  self.tileView9,
                                  self.tileView10,
                                  nil];
            // change original frame on each tileview to new location
            for (int i=0; i<10; i++) {
                DFSTileView *view = [tileViews objectAtIndex:i];
                for (int j=0; j<10; j++) {
                    CGRect newRect = [[tileFrames objectAtIndex:j] CGRectValue];
                    if (view.tile == self.game.currentPlayer.tileSet[j]) {
                        view.originalFrame = newRect;
                    }
                }
            }
            // move all the tiles
            [self.gameView recallTiles];
        }
    }
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
        self.recallButton.enabled = YES;
    } else {
        self.passOrPlayButton.title = @"Pass";
        self.recallButton.enabled = NO;
    }

}

#pragma mark - Scroll view delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.gameView;
}

#pragma mark - button actions
- (IBAction)swapTiles:(id)sender {
    // confirm selection
    swapConfirm = [[UIAlertView alloc] initWithTitle:@"Swap?" message:@"Are you sure you want to swap?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [swapConfirm show];
}

- (IBAction)recallTiles:(id)sender {
	[self.gameView recallTiles];
    self.passOrPlayButton.title = @"Pass";
    self.recallButton.enabled = NO;
}

- (IBAction)passOrPlay:(UIBarButtonItem *)sender {
	NSString *error;
    if ([sender.title isEqualToString:@"Pass"]) {
        // confirm selection
        passConfirm = [[UIAlertView alloc] initWithTitle:@"Pass?" message:@"Are you sure you want to pass?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [passConfirm show];
        
    } else {
        [self.game completeTurnForPlayer:self.game.currentPlayer returnError:&error];
    }
    if (error) {
        self.navLabel.text = error;
    }
}

- (IBAction)resign:(id)sender {
    // confirm selection
    resignConfirm = [[UIAlertView alloc] initWithTitle:@"Resign?" message:@"Are you sure you want to resign?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [resignConfirm show];
}

@end
