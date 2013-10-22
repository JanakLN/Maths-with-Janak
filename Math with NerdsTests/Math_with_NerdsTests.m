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
#import "DFSBoardSpace.h"
#import "DFSEquation.h"

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
	id newGame = [NSKeyedUnarchiver unarchiveObjectWithData:archive];
	
	XCTAssertTrue([newGame isKindOfClass:[DFSGame class]], @"The game was not unarchived. got %@", [newGame class]);
}

- (void)testAnInvalidEquation
{
	DFSTile *t1 = [[DFSTile alloc] initWithFaceValue:@"2" andPointValue:2];
	DFSTile *t2 = [[DFSTile alloc] initWithFaceValue:@"5" andPointValue:3];
	DFSTile *t3 = [[DFSTile alloc] initWithFaceValue:@"-" andPointValue:1];
	DFSTile *t4 = [[DFSTile alloc] initWithFaceValue:@"2" andPointValue:2];
	DFSTile *t5 = [[DFSTile alloc] initWithFaceValue:@"*" andPointValue:3];
	DFSTile *t6 = [[DFSTile alloc] initWithFaceValue:@"1" andPointValue:2];
	DFSTile *t7 = [[DFSTile alloc] initWithFaceValue:@"0" andPointValue:1];
	DFSTile *t8 = [[DFSTile alloc] initWithFaceValue:@"+" andPointValue:2];
	DFSTile *t9 = [[DFSTile alloc] initWithFaceValue:@"5" andPointValue:3];
	
	DFSBoardSpace *sp1 = [[DFSBoardSpace alloc] initWithMultiplier:1 andApplysToWord:NO];
	sp1.tile = t1;
	DFSBoardSpace *sp2 = [[DFSBoardSpace alloc] initWithMultiplier:2 andApplysToWord:YES];
	sp2.tile = t2;
	DFSBoardSpace *sp3 = [[DFSBoardSpace alloc] initWithMultiplier:1 andApplysToWord:NO];
	sp3.tile = t3;
	DFSBoardSpace *sp4 = [[DFSBoardSpace alloc] initWithMultiplier:1 andApplysToWord:NO];
	sp4.tile = t4;
	DFSBoardSpace *sp5 = [[DFSBoardSpace alloc] initWithMultiplier:1 andApplysToWord:NO];
	sp5.tile = t5;
	DFSBoardSpace *sp6 = [[DFSBoardSpace alloc] initWithMultiplier:3 andApplysToWord:NO];
	sp6.tile = t6;
	DFSBoardSpace *sp7 = [[DFSBoardSpace alloc] initWithMultiplier:1 andApplysToWord:NO];
	sp7.tile = t7;
	DFSBoardSpace *sp8 = [[DFSBoardSpace alloc] initWithMultiplier:1 andApplysToWord:NO];
	sp8.tile = t8;
	DFSBoardSpace *sp9 = [[DFSBoardSpace alloc] initWithMultiplier:1 andApplysToWord:NO];
	sp9.tile = t9;
	
	NSArray *spaces = [NSArray arrayWithObjects:sp1, sp2, sp3, sp4, sp5, sp6, sp7, sp8, sp9, nil];
	
	DFSEquation *equation = [[DFSEquation alloc] initWithBoardSpaces:spaces];
	int score = 0;
	
	XCTAssertFalse(equation.isValid, @"The equation should be invalid");
	XCTAssertEqual(equation.score, score, @"The equation score should be %d, was %d", score, equation.score);
}

- (void)testAValidEquation
{
	DFSTile *t1 = [[DFSTile alloc] initWithFaceValue:@"2" andPointValue:2];
	DFSTile *t2 = [[DFSTile alloc] initWithFaceValue:@"5" andPointValue:3];
	DFSTile *t3 = [[DFSTile alloc] initWithFaceValue:@"=" andPointValue:1];
	DFSTile *t4 = [[DFSTile alloc] initWithFaceValue:@"2" andPointValue:2];
	DFSTile *t5 = [[DFSTile alloc] initWithFaceValue:@"*" andPointValue:3];
	DFSTile *t6 = [[DFSTile alloc] initWithFaceValue:@"1" andPointValue:2];
	DFSTile *t7 = [[DFSTile alloc] initWithFaceValue:@"0" andPointValue:1];
	DFSTile *t8 = [[DFSTile alloc] initWithFaceValue:@"+" andPointValue:2];
	DFSTile *t9 = [[DFSTile alloc] initWithFaceValue:@"5" andPointValue:3];
	
	DFSBoardSpace *sp1 = [[DFSBoardSpace alloc] initWithMultiplier:1 andApplysToWord:NO];
	sp1.tile = t1;
	DFSBoardSpace *sp2 = [[DFSBoardSpace alloc] initWithMultiplier:2 andApplysToWord:YES];
	sp2.tile = t2;
	DFSBoardSpace *sp3 = [[DFSBoardSpace alloc] initWithMultiplier:1 andApplysToWord:NO];
	sp3.tile = t3;
	DFSBoardSpace *sp4 = [[DFSBoardSpace alloc] initWithMultiplier:1 andApplysToWord:NO];
	sp4.tile = t4;
	DFSBoardSpace *sp5 = [[DFSBoardSpace alloc] initWithMultiplier:1 andApplysToWord:NO];
	sp5.tile = t5;
	DFSBoardSpace *sp6 = [[DFSBoardSpace alloc] initWithMultiplier:3 andApplysToWord:NO];
	sp6.tile = t6;
	DFSBoardSpace *sp7 = [[DFSBoardSpace alloc] initWithMultiplier:1 andApplysToWord:NO];
	sp7.tile = t7;
	DFSBoardSpace *sp8 = [[DFSBoardSpace alloc] initWithMultiplier:1 andApplysToWord:NO];
	sp8.tile = t8;
	DFSBoardSpace *sp9 = [[DFSBoardSpace alloc] initWithMultiplier:1 andApplysToWord:NO];
	sp9.tile = t9;
	
	NSArray *spaces = [NSArray arrayWithObjects:sp1, sp2, sp3, sp4, sp5, sp6, sp7, sp8, sp9, nil];
	
	DFSEquation *equation = [[DFSEquation alloc] initWithBoardSpaces:spaces];
	int score = 46;
	
	XCTAssertTrue(equation.isValid, @"The equation should be valid");
	XCTAssertEqual(equation.score, score, @"The equation score should be %d, was %d", score, equation.score);
	
}

- (void)testGettingAllEquations
{
	
//	0	1	2	3	4	5	6	7	8	9	10	11	12	13	14
//	0		1	+	5	=	6
//	1				*
//	2				1
//	3				0			1
//	4			4	=	3	+	1
//	5				5			+
//	6				0			4
//	7							=
//	8							1
//	9							5	5	/	5	=	1	1
//	10
//	11
//	12
//	13
//	14
	
	DFSTile *t01 = [[DFSTile alloc] initWithFaceValue:@"1" andPointValue:2];
	DFSTile *t02 = [[DFSTile alloc] initWithFaceValue:@"+" andPointValue:3];
	DFSTile *t03 = [[DFSTile alloc] initWithFaceValue:@"5" andPointValue:1];
	DFSTile *t04 = [[DFSTile alloc] initWithFaceValue:@"=" andPointValue:2];
	DFSTile *t05 = [[DFSTile alloc] initWithFaceValue:@"6" andPointValue:3];
	DFSTile *t06 = [[DFSTile alloc] initWithFaceValue:@"*" andPointValue:2];
	DFSTile *t07 = [[DFSTile alloc] initWithFaceValue:@"1" andPointValue:1];
	DFSTile *t08 = [[DFSTile alloc] initWithFaceValue:@"0" andPointValue:2];
	DFSTile *t09 = [[DFSTile alloc] initWithFaceValue:@"1" andPointValue:3];
	DFSTile *t10 = [[DFSTile alloc] initWithFaceValue:@"4" andPointValue:2];
	DFSTile *t12 = [[DFSTile alloc] initWithFaceValue:@"=" andPointValue:3];
	DFSTile *t13 = [[DFSTile alloc] initWithFaceValue:@"3" andPointValue:1];
	DFSTile *t14 = [[DFSTile alloc] initWithFaceValue:@"+" andPointValue:2];
	DFSTile *t15 = [[DFSTile alloc] initWithFaceValue:@"1" andPointValue:3];
	DFSTile *t16 = [[DFSTile alloc] initWithFaceValue:@"5" andPointValue:2];
	DFSTile *t17 = [[DFSTile alloc] initWithFaceValue:@"+" andPointValue:1];
	DFSTile *t18 = [[DFSTile alloc] initWithFaceValue:@"0" andPointValue:2];
	DFSTile *t19 = [[DFSTile alloc] initWithFaceValue:@"4" andPointValue:3];
	DFSTile *t20 = [[DFSTile alloc] initWithFaceValue:@"=" andPointValue:2];
	DFSTile *t22 = [[DFSTile alloc] initWithFaceValue:@"1" andPointValue:3];
	DFSTile *t23 = [[DFSTile alloc] initWithFaceValue:@"5" andPointValue:1];
	DFSTile *t24 = [[DFSTile alloc] initWithFaceValue:@"5" andPointValue:2];
	DFSTile *t25 = [[DFSTile alloc] initWithFaceValue:@"/" andPointValue:3];
	DFSTile *t26 = [[DFSTile alloc] initWithFaceValue:@"5" andPointValue:2];
	DFSTile *t27 = [[DFSTile alloc] initWithFaceValue:@"=" andPointValue:1];
	DFSTile *t28 = [[DFSTile alloc] initWithFaceValue:@"1" andPointValue:2];
	DFSTile *t29 = [[DFSTile alloc] initWithFaceValue:@"1" andPointValue:3];
	
	[game player:player1 placeTile:t01 atRow:0 andColumn:1];
	[game player:player1 placeTile:t02 atRow:0 andColumn:2];
	[game player:player1 placeTile:t03 atRow:0 andColumn:3];
	[game player:player1 placeTile:t04 atRow:0 andColumn:4];
	[game player:player1 placeTile:t05 atRow:0 andColumn:5];
	[game player:player1 placeTile:t06 atRow:1 andColumn:3];
	[game player:player1 placeTile:t07 atRow:2 andColumn:3];
	[game player:player1 placeTile:t08 atRow:3 andColumn:3];
	[game player:player1 placeTile:t09 atRow:3 andColumn:6];
	[game player:player1 placeTile:t10 atRow:4 andColumn:2];
	[game player:player1 placeTile:t12 atRow:4 andColumn:3];
	[game player:player1 placeTile:t13 atRow:4 andColumn:4];
	[game player:player1 placeTile:t14 atRow:4 andColumn:5];
	[game player:player1 placeTile:t15 atRow:4 andColumn:6];
	[game player:player1 placeTile:t16 atRow:5 andColumn:3];
	[game player:player1 placeTile:t17 atRow:5 andColumn:6];
	[game player:player1 placeTile:t18 atRow:6 andColumn:3];
	[game player:player1 placeTile:t19 atRow:6 andColumn:6];
	[game player:player1 placeTile:t20 atRow:7 andColumn:6];
	[game player:player1 placeTile:t22 atRow:8 andColumn:6];
	[game player:player1 placeTile:t23 atRow:9 andColumn:6];
	[game player:player1 placeTile:t24 atRow:9 andColumn:7];
	[game player:player1 placeTile:t25 atRow:9 andColumn:8];
	[game player:player1 placeTile:t26 atRow:9 andColumn:9];
	[game player:player1 placeTile:t27 atRow:9 andColumn:10];
	[game player:player1 placeTile:t28 atRow:9 andColumn:11];
	[game player:player1 placeTile:t29 atRow:9 andColumn:12];


	NSArray *equations = [game getAllEquations];
	
	XCTAssertTrue(equations.count == 5, @"The equation could should be 5, was %d instead", equations.count);
	
}

@end
