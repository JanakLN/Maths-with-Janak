//
//  Math_with_NerdsTests.m
//  Math with NerdsTests
//
//  Created by Chris Bougher on 9/30/13.
//  Copyright (c) 2013 Chris Bougher. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DFSGame.h"
#import "DFSPlayer.h"

@interface Math_with_NerdsTests : XCTestCase {
	DFSPlayer *player1;
	DFSPlayer *player2;
	DFSGame *game;
	NSData *archive;
}

@end

@implementation Math_with_NerdsTests

- (void)setUp
{
    [super setUp];
    
	// create a game
	player1 = [[DFSPlayer alloc] init];
	player2 = [[DFSPlayer alloc] init];
	game = [[DFSGame alloc] initNewGameWithPayer1:player1 andPlayer2:player2];
	archive = [NSKeyedArchiver archivedDataWithRootObject:game];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPlayer1isValid
{
	XCTAssertTrue(player1.tileSet != nil, @"Player 1 nas no tileset");
	
	XCTAssertTrue(player1.tileSet.count == 7, @"Player 1 only has %d tiles, should be 7", player1.tileSet.count);
	
	XCTAssertTrue(player1.score == 0, @"Player 1 should have no score, has %d", player1.score);
}

- (void)testPlayer2isValid
{
	XCTAssertTrue(player2.tileSet != nil, @"Player 2 nas no tileset");
	
	XCTAssertTrue(player2.tileSet.count == 7, @"Player 2 only has %d tiles, should be 7", player2.tileSet.count);
	
	XCTAssertTrue(player2.score == 0, @"Player 2 should have no score, has %d", player2.score);
}

- (void)testStatingCurrentPlayer
{
	XCTAssertTrue(game.currentPlayer == player1, @"Current player shoudd be play 1, is %@ instead", game.currentPlayer);
}

- (void)testSwappingTiles
{
	NSString *errorString;
	
	NSString *oldDescription = [player1 description];
	int oldTilecount = game.tilePool.count;
	
	[game swapTiles:[player1.tileSet copy] ForPlayer:player1 returnError:&errorString];
	
	NSString *newDescription = [player1 description];
	int newTilecount = game.tilePool.count;
	
	XCTAssertTrue(![oldDescription isEqualToString:newDescription] , @"Tiles were not swapped, %@ == %@", oldDescription, newDescription);
	XCTAssertTrue(oldTilecount == newTilecount, @"Tile pool changed was %d, now is %d", oldTilecount, newTilecount);
}

- (void)testArchivingGame
{
	archive = nil;
	archive = [NSKeyedArchiver archivedDataWithRootObject:game];
	
	XCTAssertTrue(archive, @"No data was archived");
}

- (void)testUnarchivingGame
{
	DFSGame *newGame = [NSKeyedUnarchiver unarchiveObjectWithData:archive];
	
	XCTAssertTrue([newGame isKindOfClass:[DFSGame class]], @"The game was not unarchived");
}

@end
