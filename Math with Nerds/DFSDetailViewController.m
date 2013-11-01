//
//  DFSDetailViewController.m
//  Math with Nerds
//
//  Created by Chris Bougher on 9/30/13.
//  Copyright (c) 2013 Chris Bougher. All rights reserved.
//

#import "DFSDetailViewController.h"
#import "DFSGame.h"

@interface DFSDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DFSDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(DFSGame *)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

	if (self.detailItem) {
		self.gameView.game = self.detailItem;
		self.tileView1.tile = self.detailItem.currentPlayer.tileSet[0];
		self.tileView2.tile = self.detailItem.currentPlayer.tileSet[1];
		self.tileView3.tile = self.detailItem.currentPlayer.tileSet[2];
		self.tileView4.tile = self.detailItem.currentPlayer.tileSet[3];
		self.tileView5.tile = self.detailItem.currentPlayer.tileSet[4];
		self.tileView6.tile = self.detailItem.currentPlayer.tileSet[5];
		self.tileView7.tile = self.detailItem.currentPlayer.tileSet[6];
		self.tileView8.tile = self.detailItem.currentPlayer.tileSet[7];
		self.tileView9.tile = self.detailItem.currentPlayer.tileSet[8];
		self.tileView10.tile = self.detailItem.currentPlayer.tileSet[9];
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
		self.player1Label.text = self.detailItem.player1.description;
		self.player2Label.text = self.detailItem.player2.description;
		self.player1ScoreLabel.text = [NSString stringWithFormat:@"%d", self.detailItem.player1.score];
		self.player2ScoreLabel.text = [NSString stringWithFormat:@"%d", self.detailItem.player2.score];
		if (self.detailItem.currentPlayer == self.detailItem.player1) {
			self.player1Label.font = [UIFont boldSystemFontOfSize:self.player1Label.font.pointSize];
			self.player2Label.font = [UIFont systemFontOfSize:self.player1Label.font.pointSize];
		} else {
			self.player2Label.font = [UIFont boldSystemFontOfSize:self.player2Label.font.pointSize];
			self.player1Label.font = [UIFont systemFontOfSize:self.player1Label.font.pointSize];
		}
		
	}
}

- (void)updatePlayerDisplay
{
	self.player1Label.text = self.detailItem.player1.description;
	self.player2Label.text = self.detailItem.player2.description;
	self.player1ScoreLabel.text = [NSString stringWithFormat:@"%d", self.detailItem.player1.score];
	self.player2ScoreLabel.text = [NSString stringWithFormat:@"%d", self.detailItem.player2.score];
	if (self.detailItem.currentPlayer == self.detailItem.player1) {
		self.player1Label.font = [UIFont boldSystemFontOfSize:self.player1Label.font.pointSize];
		self.player2Label.font = [UIFont systemFontOfSize:self.player1Label.font.pointSize];
	} else {
		self.player2Label.font = [UIFont boldSystemFontOfSize:self.player2Label.font.pointSize];
		self.player1Label.font = [UIFont systemFontOfSize:self.player1Label.font.pointSize];
	}
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[self configureView];
	
	// attach notification listeners
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlayerDisplay) name:@"Current Player Changed" object:self.detailItem];
}

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

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma mark - Gesture Recognizers
- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {

	DFSTileView *view = (DFSTileView *)recognizer.view;
	CGPoint translation;

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

}

#pragma mark - button actions
- (IBAction)swapTiles:(id)sender {
	NSString *error;
	[self.detailItem swapTiles:self.detailItem.currentPlayer.tileSet ForPlayer:self.detailItem.currentPlayer returnError:&error];
	
	self.tileView1.tile = self.detailItem.currentPlayer.tileSet[0];
	self.tileView2.tile = self.detailItem.currentPlayer.tileSet[1];
	self.tileView3.tile = self.detailItem.currentPlayer.tileSet[2];
	self.tileView4.tile = self.detailItem.currentPlayer.tileSet[3];
	self.tileView5.tile = self.detailItem.currentPlayer.tileSet[4];
	self.tileView6.tile = self.detailItem.currentPlayer.tileSet[5];
	self.tileView7.tile = self.detailItem.currentPlayer.tileSet[6];
	self.tileView8.tile = self.detailItem.currentPlayer.tileSet[7];
	self.tileView9.tile = self.detailItem.currentPlayer.tileSet[8];
	self.tileView10.tile = self.detailItem.currentPlayer.tileSet[9];

	[self.gameView setNeedsDisplay];
}

- (IBAction)recallTiles:(id)sender {
	[self.gameView recallTiles];
}

- (IBAction)pass:(id)sender {
	NSString *error;
	[self.detailItem passTurnForPlayer:self.detailItem.currentPlayer returnError:&error];
}

- (IBAction)play:(id)sender {
	NSString *error;
	[self.detailItem completeTurnForPlayer:self.detailItem.currentPlayer returnError:&error];
}

@end
