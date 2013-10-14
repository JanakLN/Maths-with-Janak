//
//  DFSGame.m
//  Math with Nerds
//
//  Created by Chris Bougher on 10/13/13.
//  Copyright (c) 2013 Chris Bougher. All rights reserved.
//

#import "DFSGame.h"
#import "DFSTile.h"
#import "DFSBoardSpace.h"

#define ROWS 15
#define COLUMNS 15

@implementation DFSGame

@synthesize player1 = _player1,
            player2 = _player2,
            currentPlayer = _currentPlayer,
            tilePool = _tilePool,
            gameBoard = _gameBoard;

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if(self = [super init])
    {
        // decode
		_player1 = [aDecoder decodeObjectForKey:@"_player1"];
		_player2 = [aDecoder decodeObjectForKey:@"_player2"];
		_currentPlayer = [aDecoder decodeObjectForKey:@"_currentPlayer"];
		_tilePool = [[aDecoder decodeObjectForKey:@"_tilePool"] mutableCopy];
		_gameBoard = [aDecoder decodeObjectForKey:@"_gameBoard"];
    }
	
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:_player1 forKey:@"_player1"];
	[aCoder encodeObject:_player2 forKey:@"_player2"];
	[aCoder encodeObject:_currentPlayer forKey:@"_currentPlayer"];
	[aCoder encodeObject:_tilePool forKey:@"_tilePool"];
	[aCoder encodeObject:_gameBoard forKey:@"_gameBoard"];
}

- (id)initNewGameWithPayer1:(DFSPlayer *)player1 andPlayer2:(DFSPlayer *)player2
{
	if(self = [super init]){
		
		// save players
		_player1 = player1;
		_player2 = player2;
		
		// create the game board
		_gameBoard = [[DFSMatrix alloc] initWithRows:ROWS andColumns:COLUMNS];
		// assign the spaces
		for (int i=0; i<ROWS; i++) {
			for (int j=0; j<COLUMNS; j++) {
				DFSBoardSpace *space = nil;
				// triple word
				if ((i==0 && j==0) || (i==0 && j==7) || (i==0 && j==14) || (i==7 && j==0) || (i==7 && j==14) || (i==14 && j==0) || (i==14 && j==7) || (i==14 && j==14)) {
					space = [[DFSBoardSpace alloc] initWithMultiplier:3 andApplysToWord:YES];
				}
				// double word
				if ((i==1 && j==1) || (i==1 && j==13) || (i==2 && j==2) || (i==2 && j==12) || (i==3 && j==3) || (i==3 && j==11) || (i==4 && j==4) || (i==4 && j==10) || (i==10 && j==4) || (i==10 && j==10) || (i==11 && j==3) || (i==11 && j==11) || (i==12 && j==2) || (i==12 && j==12) || (i==13 && j==1) || (i==13 && j==13)) {
					space = [[DFSBoardSpace alloc] initWithMultiplier:2 andApplysToWord:YES];
				}
				// triple letter
				if ((i==1 && j==5) || (i==1 && j==9) || (i==5 && j==1) || (i==5 && j==5) || (i==5 && j==9) || (i==5 && j==13) || (i==9 && j==1) || (i==9 && j==5) || (i==9 && j==9) || (i==9 && j==13) || (i==13 && j==5) || (i==13 && j==9)) {
					space = [[DFSBoardSpace alloc] initWithMultiplier:3 andApplysToWord:NO];
				}
				// double letter
				if ((i==0 && j==3) || (i==0 && j==11) || (i==2 && j==6) || (i==2 && j==8) || (i==3 && j==0) || (i==3 && j==7) || (i==3 && j==14) || (i==6 && j==2) || (i==6 && j==6) || (i==6 && j==8) || (i==6 && j==12) || (i==7 && j==3) || (i==7 && j==11) || (i==8 && j==2) || (i==8 && j==6) || (i==8 && j==8) || (i==8 && j==12) || (i==11 && j==0) || (i==11 && j==7) || (i==11 && j==14) || (i==12 && j==6) || (i==12 && j==8) || (i==14 && j==3) || (i==14 && j==11)) {
					space = [[DFSBoardSpace alloc] initWithMultiplier:2 andApplysToWord:NO];
				}
				// default space
				if(!space){
					space = [[DFSBoardSpace alloc] initWithMultiplier:1 andApplysToWord:NO];
				}
				
				[_gameBoard insertObject:space atRow:i andColumn:j];
			}
		}
		
		
		// create the tileset
		// 7 - 0
		_tilePool = [[NSMutableArray alloc] initWithCapacity:100];
		for (int i=0; i<7; i++) {
			[_tilePool addObject:[[DFSTile alloc] initWithFaceValue:@"0" andPointValue:1]];
		}
		// 5 - 1, 2, 3, 4, 5
		for (int j=1; j<6; j++){
			NSString *str = [NSString stringWithFormat:@"%d", j];
			for (int i=0; i<5; i++) {
				[_tilePool addObject:[[DFSTile alloc] initWithFaceValue:str andPointValue:3]];
			}
		}
		// 4 - 6, 7, 8, 9
		for (int j=6; j<10; j++){
			NSString *str = [NSString stringWithFormat:@"%d", j];
			for (int i=0; i<4; i++) {
				[_tilePool addObject:[[DFSTile alloc] initWithFaceValue:str andPointValue:4]];
			}
		}
		// 8 - +
		for (int i=0; i<8; i++) {
			[_tilePool addObject:[[DFSTile alloc] initWithFaceValue:@"+" andPointValue:2]];
		}
		// 8 - -
		for (int i=0; i<8; i++) {
			[_tilePool addObject:[[DFSTile alloc] initWithFaceValue:@"1" andPointValue:2]];
		}
		// 4 - *
		for (int i=0; i<4; i++) {
			[_tilePool addObject:[[DFSTile alloc] initWithFaceValue:@"*" andPointValue:4]];
		}
		// 4 - /
		for (int i=0; i<4; i++) {
			[_tilePool addObject:[[DFSTile alloc] initWithFaceValue:@"/" andPointValue:4]];
		}
		// 28 - =
		for (int i=0; i<28; i++) {
			[_tilePool addObject:[[DFSTile alloc] initWithFaceValue:@"=" andPointValue:1]];
		}
		
		// assign the starting tiles
		NSMutableArray *player1Tiles = [[NSMutableArray alloc] initWithCapacity:7];
		for (int i=0; i<7; i++) {
			int index = arc4random_uniform(_tilePool.count);
			[player1Tiles addObject:[_tilePool objectAtIndex:index]];
			[_tilePool removeObjectAtIndex:index];
		}
		NSMutableArray *player2Tiles = [[NSMutableArray alloc] initWithCapacity:7];
		for (int i=0; i<7; i++) {
			int index = arc4random_uniform(_tilePool.count);
			[player2Tiles addObject:[_tilePool objectAtIndex:index]];
			[_tilePool removeObjectAtIndex:index];
		}
		
		// assign the players
		_player1.tileSet = player1Tiles;
		_player2.tileSet = player2Tiles;
		
		// init first player
		_currentPlayer = player1;
	}
	return self;
}

- (BOOL)player:(DFSPlayer *)player placeTile:(DFSTile *)tile atRow:(int)row andColumn:(int)column
{
	DFSBoardSpace *targetSpace = [self.gameBoard objectAtRow:row andColumn:column];
	
	if(!targetSpace.tile){
		targetSpace.tile = tile;
		[player.tileSet removeObject:tile];
		return YES;
	}
	return NO;
}

- (BOOL)passTurnForPlayer:(DFSPlayer *)player returnError:(NSString **)errorString
{
	// must be this players turn
	if (player != self.currentPlayer) {
		*errorString = @"You are not the current player";
		return NO;
	} else {
		// swap current player
		if (self.currentPlayer == self.player1) {
			self.currentPlayer = self.player2;
		} else {
			self.currentPlayer = self.player1;
		}
	}
	
	return YES;
}

- (BOOL)swapTiles:(NSArray *)tiles ForPlayer:(DFSPlayer *)player returnError:(NSString **)errorString
{
	// must be this players turn
	if (player != self.currentPlayer) {
		*errorString = @"You are not the current player";
		return NO;
	}
	
	// make sure there are enough to swap
	if (self.tilePool.count < tiles.count) {
		*errorString = [NSString stringWithFormat:@"Not enough available tiles to swap, pick %d or less tiles and try again", self.tilePool.count];
		return NO;
	}
	
	// get some more tiles
	NSMutableArray *newTiles = [[NSMutableArray alloc] initWithCapacity:tiles.count];
	for (int i=0; i<tiles.count; i++) {
		int index = arc4random_uniform(_tilePool.count);
		[newTiles addObject:[_tilePool objectAtIndex:index]];
		[_tilePool removeObjectAtIndex:index];
	}
	
	// move the swapped tiles around
	[player.tileSet removeObjectsInArray:tiles];
	[self.tilePool addObjectsFromArray:tiles];
	[player.tileSet addObjectsFromArray:newTiles];
	
	return YES;
}

- (BOOL)completeTurnForPlayer:(DFSPlayer *)player returnError:(NSString **)errorString
{
	// must be this players turn
	if (player != self.currentPlayer) {
		*errorString = @"You are not the current player";
		return NO;
	}
	
	// validate tile placement
	// center space used
	if ([self.gameBoard objectAtRow:7 andColumn:7] == [NSNull null]) {
		*errorString = @"You must use the center space on the first turn";
		return NO;
	}
	// get all placed tiles, check row and column
	NSMutableArray *usedSpaces;
	NSMutableArray *rows = [[NSMutableArray alloc] init];
	NSMutableArray *cols = [[NSMutableArray alloc] init];
	for (int row=0; row<ROWS; row++) {
		for (int col=0; col<COLUMNS; col++) {
			id object = [self.gameBoard objectAtRow:row andColumn:col];
			if([object isKindOfClass:[DFSBoardSpace class]] && !((DFSBoardSpace *)object).locked){
				[usedSpaces addObject:object];
				[rows addObject:[NSNumber numberWithInt:row]];
				[cols addObject:[NSNumber numberWithInt:col]];
			}
		}
	}
	// at least one tile placed
	if (usedSpaces.count < 1) {
		*errorString = @"YOu must place at least one tile";
		return NO;
	}
	
	// all tiles in one row or column
	BOOL oneRow = true;
	BOOL oneCol = true;
	int lastRow = -1, lastCol = -1;
	for (NSNumber *number in rows) {
		if (lastRow != -1 && lastRow != [number integerValue]) {
			oneRow = NO;
			break;
		}
	}
	for (NSNumber *number in cols) {
		if (lastCol != -1 && lastCol != [number integerValue]) {
			oneCol = NO;
			break;
		}
	}
	if (!oneRow && !oneCol) {
		*errorString = @"Invalid tile placement";
		return NO;
	}
	
	// no isolated tiles
	if (oneRow) {
		DFSBoardSpace *firstSpace;
		DFSBoardSpace *emptySpace;
		for (int i=0; i<COLUMNS; i++) {
			DFSBoardSpace *currentSpace = [self.gameBoard objectAtRow:lastRow andColumn:i];

			// look for the first tile placed by the user
			if (!firstSpace && [usedSpaces containsObject:currentSpace]) {
				firstSpace = [self.gameBoard objectAtRow:lastRow andColumn:i];
				
			// look for an empty space
			} else if (currentSpace.tile == nil && !emptySpace && firstSpace){
				emptySpace = currentSpace;
			}
			
			// found a tile placed that is not touching the others
			if (firstSpace && emptySpace && [usedSpaces containsObject:currentSpace]) {
				*errorString = @"Invalid tile placement";
				return NO;
			}
			
		}
	}
	if (oneCol) {
		DFSBoardSpace *firstSpace;
		DFSBoardSpace *emptySpace;
		for (int i=0; i<ROWS; i++) {
			DFSBoardSpace *currentSpace = [self.gameBoard objectAtRow:i andColumn:lastCol];
			
			// look for the first tile placed by the user
			if (!firstSpace && [usedSpaces containsObject:currentSpace]) {
				firstSpace = [self.gameBoard objectAtRow:i andColumn:lastCol];
				
				// look for an empty space
			} else if (currentSpace.tile == nil && !emptySpace && firstSpace){
				emptySpace = currentSpace;
			}
			
			// found a tile placed that is not touching the others
			if (firstSpace && emptySpace && [usedSpaces containsObject:currentSpace]) {
				*errorString = @"Invalid tile placement";
				return NO;
			}
			
		}
	}
	
	// all equations valid
	
	
	// all valid so compute score and lock tiles
	for (DFSBoardSpace *space in usedSpaces) {
		space.locked = YES;
	}
	
	// swap current player
	if (self.currentPlayer == self.player1) {
		self.currentPlayer = self.player2;
	} else {
		self.currentPlayer = self.player1;
	}
	
	return YES;
}

@end
