//
//  DFSGame.m
//  Math with Nerds
//
//  Created by Chris Bougher on 10/13/13.
//  Copyright (c) 2013 Chris Bougher. All rights reserved.
//

#import "DFSGame.h"
#import "DFSTile.h"
#import "DFSEquation.h"

/* constants */
#define ROWS 15
#define COLUMNS 15
#define TILES 10
#define EMPTY_SPACE 0
#define FILLED_SPACE 1

/* private interface */
@interface DFSGame ()

@property (assign, nonatomic) int nonScoringPlayCount;

@end

@implementation DFSGame

/* 
 * restore from serialized data 
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	if(self = [super init])
    {
        // decode
		_player1 = [aDecoder decodeObjectForKey:@"_player1"];
		_player2 = [aDecoder decodeObjectForKey:@"_player2"];
		_currentPlayer = [aDecoder decodeObjectForKey:@"_currentPlayer"];
        _resignedPlayer = [aDecoder decodeObjectForKey:@"_resignedPlayer"];
		_tilePool = [[aDecoder decodeObjectForKey:@"_tilePool"] mutableCopy];
		_gameBoard = [aDecoder decodeObjectForKey:@"_gameBoard"];
		_gameIsOver = [aDecoder decodeBoolForKey:@"_gameIsOver"];
		_nonScoringPlayCount = [aDecoder decodeIntForKey:@"_nonScoringPlayCount"];
		_lastUpdate = [aDecoder decodeObjectForKey:@"_lastUpdate"];
		_lastActionPlayer = [aDecoder decodeObjectForKey:@"_lastActionPlayer"];
        _lastAction = [aDecoder decodeIntForKey:@"_lastAction"];
    }
	
    return self;
}

/*
 * serialize this game
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:_player1 forKey:@"_player1"];
	[aCoder encodeObject:_player2 forKey:@"_player2"];
	[aCoder encodeObject:_currentPlayer forKey:@"_currentPlayer"];
    [aCoder encodeObject:_resignedPlayer forKey:@"_resignedPlayer"];
	[aCoder encodeObject:_tilePool forKey:@"_tilePool"];
	[aCoder encodeObject:_gameBoard forKey:@"_gameBoard"];
	[aCoder encodeBool:_gameIsOver forKey:@"_gameIsOver"];
	[aCoder encodeInt:_nonScoringPlayCount forKey:@"_nonScoringPlayCount"];
	[aCoder encodeObject:_lastUpdate forKey:@"_lastUpdate"];
    [aCoder encodeObject:_lastActionPlayer forKey:@"_lastActionPlayer"];
	[aCoder encodeInt:_lastAction forKey:@"_lastAction"];
}

/*
 * save the last action
 */
- (void)saveAction:(GAME_ACTION)action forPlayer:(DFSPlayer *)player
{
	self.lastUpdate = [NSDate date];
    self.lastAction = action;
	self.lastActionPlayer = player;
}

/*
 * initialize a new game
 */
- (instancetype)initNewGameWithPayer1:(DFSPlayer *)player1 andPlayer2:(DFSPlayer *)player2
{
	if(self = [super init]){
		
		// game just started
		_gameIsOver = NO;
		
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
			[_tilePool addObject:[[DFSTile alloc] initWithFaceValue:@"-" andPointValue:2]];
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
		NSMutableArray *player1Tiles = [[NSMutableArray alloc] initWithCapacity:TILES];
		for (int i=0; i<TILES; i++) {
			int index = arc4random_uniform(_tilePool.count);
			[player1Tiles addObject:[_tilePool objectAtIndex:index]];
			[_tilePool removeObjectAtIndex:index];
		}
		NSMutableArray *player2Tiles = [[NSMutableArray alloc] initWithCapacity:TILES];
		for (int i=0; i<TILES; i++) {
			int index = arc4random_uniform(_tilePool.count);
			[player2Tiles addObject:[_tilePool objectAtIndex:index]];
			[_tilePool removeObjectAtIndex:index];
		}
		
		// assign the players
		_player1.tileSet = player1Tiles;
		_player2.tileSet = player2Tiles;
		
		// init first player
		_currentPlayer = player1;
		
		// set last update and action
        [self saveAction:DFS_CHALLENGE forPlayer:_currentPlayer];
		//[self saveAction:[NSString stringWithFormat:@"%@ challenged %@ to a new game", _player1, _player2]];
		
	}
	return self;
}

/*
 * this games description
 */
- (NSString *)description
{
    NSString *description;
    switch (self.lastAction) {
        case DFS_CHALLENGE:
            description = [NSString stringWithFormat:@"%@ challenged %@ to a new game!", self.player1, self.player2 ];
            break;
            
        case DFS_GAME_OVER_PASS:
            description = [NSString stringWithFormat:@"Game Over! %@ wins", self.player1.score > self.player2.score ? self.player1 : self.player2];
            break;
            
        case DFS_GAME_OVER_PLAY:
            description = [NSString stringWithFormat:@"Game Over! %@ wins", self.player1.score > self.player2.score ? self.player1 : self.player2];
            break;
            
        case DFS_GAME_OVER_RESIGN:
            description = [NSString stringWithFormat:@"Game Over! %@ resigned, %@ wins!", self.resignedPlayer, self.resignedPlayer == self.player1 ? self.player2 : self.player1];
            break;
            
        case DFS_PASS:
            description = [NSString stringWithFormat:@"%@ passed", self.lastActionPlayer];
            break;
            
        case DFS_PLAYED:
            description = [NSString stringWithFormat:@"%@ played", self.lastActionPlayer];
            break;
            
        case DFS_TILE_SWAP:
            description = [NSString stringWithFormat:@"%@ swapped their tiles", self.lastActionPlayer];
            break;
            
        default:
            description = @"";
            break;
    }
    
	return description;
}

/*
 * check for game ending condition
 */
- (void)checkForGameEnd
{
    // game ended because a player resigned
    if (self.resignedPlayer) {
        self.gameIsOver = YES;
        [self saveAction:DFS_GAME_OVER_RESIGN forPlayer:self.currentPlayer];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"Game Ended" object:self userInfo:[NSDictionary dictionaryWithObject:@"PlayerResigned" forKey:@"Cause"]];
        return;
    }
    
	// game ended due to non scoring play count (allow 4)
	if (self.nonScoringPlayCount > 4) {
		self.gameIsOver = YES;
        [self saveAction:DFS_GAME_OVER_PASS forPlayer:self.currentPlayer];

		[[NSNotificationCenter defaultCenter] postNotificationName:@"Game Ended" object:self userInfo:[NSDictionary dictionaryWithObject:@"NonScoringPlayCount" forKey:@"Cause"]];
        return;
	}
		
	// game ended due to tile pool exhaustion
	if (self.currentPlayer.tileSet.count == 0) {
		self.gameIsOver = YES;
        [self saveAction:DFS_GAME_OVER_PLAY forPlayer:self.currentPlayer];

		[[NSNotificationCenter defaultCenter] postNotificationName:@"Game Ended" object:self userInfo:[NSDictionary dictionaryWithObject:@"LastTilePlayed" forKey:@"Cause"]];
        return;
	}
	
}

/*
 * switch turn
 */
- (void)switchPlayers
{
	// swap current player
	if (self.currentPlayer == self.player1) {
		self.currentPlayer = self.player2;
	} else {
		self.currentPlayer = self.player1;
	}
	
	// notify listeners
	[[NSNotificationCenter defaultCenter] postNotificationName:@"Current Player Changed" object:self];
}

/*
 * place a tile on the board for the player 
 */
- (BOOL)player:(DFSPlayer *)player placeTile:(DFSTile *)tile onSpace:(DFSBoardSpace *)space
{
    // make sure the space is not already occupied
	if(!space.tile){
		space.tile = tile;
		[player.tileSet removeObject:tile];
		return YES;
	}
    
	return NO;
}

/*
 * recall all placed tiles back into the players tray
 */
- (BOOL)recallTilesForPlayer:(DFSPlayer *)player returnError:(NSString **)errorString
{
	// get all placed tiles, check row and column
	NSMutableArray *usedSpaces = [[NSMutableArray alloc] init];
	for (int row=0; row<ROWS; row++) {
		for (int col=0; col<COLUMNS; col++) {
			id object = [self.gameBoard objectAtRow:row andColumn:col];
			if([object isKindOfClass:[DFSBoardSpace class]] && !((DFSBoardSpace *)object).locked && ((DFSBoardSpace *)object).tile){
				[usedSpaces addObject:object];
			}
		}
	}
	
    // move the tiles from the board to the player
    // add to player first or the tiles memory will get reclaimed
	for (DFSBoardSpace *space in usedSpaces) {
		[player.tileSet addObject:space.tile];
		space.tile = nil;
	}
	
	return YES;
}

/*
 * recall a single tile from the board back to the players tray
 */
- (BOOL)recallTile:(DFSTile *)tile forPlayer:(DFSPlayer *)player returnError:(NSString **)errorString
{
	// get all placed tiles, check row and column
	NSMutableArray *usedSpaces = [[NSMutableArray alloc] init];
	for (int row=0; row<ROWS; row++) {
		for (int col=0; col<COLUMNS; col++) {
			id object = [self.gameBoard objectAtRow:row andColumn:col];
			if([object isKindOfClass:[DFSBoardSpace class]] && !((DFSBoardSpace *)object).locked && ((DFSBoardSpace *)object).tile){
				[usedSpaces addObject:object];
			}
		}
	}
	
    // move the tiles from the board to the player
    // add to player first or the tiles memory will get reclaimed
	for (DFSBoardSpace *space in usedSpaces) {
		if (space.tile == tile) {
			[player.tileSet addObject:space.tile];
			space.tile = nil;
			return YES;
		}
	}
	
	*errorString = @"Tile not found on the board";
	
	return NO;
}

/*
 * player passes
 */
- (BOOL)passTurnForPlayer:(DFSPlayer *)player returnError:(NSString **)errorString
{
	if (self.gameIsOver) return NO;
	
	// must be this players turn
	if (player != self.currentPlayer) {
		*errorString = @"It's not your turn!";
		return NO;
	} else {
		[self saveAction:DFS_PASS forPlayer:self.currentPlayer];
		// swap current player
		[self switchPlayers];
	}
	
	// check for game end
	self.nonScoringPlayCount++;
	[self checkForGameEnd];

	return YES;
}

/*
 * swap all of the players tiles for new ones
 */
- (BOOL)swapTiles:(NSArray *)tiles ForPlayer:(DFSPlayer *)player returnError:(NSString **)errorString
{
	if (self.gameIsOver) return NO;

	// must be this players turn
	if (player != self.currentPlayer) {
		*errorString = @"It's not your turn!";
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
	[self.tilePool addObjectsFromArray:tiles];
	[player.tileSet removeObjectsInArray:tiles];
	[player.tileSet addObjectsFromArray:newTiles];
	
	[self saveAction:DFS_TILE_SWAP forPlayer:self.currentPlayer];
	// swap current player
	[self switchPlayers];
	
	// check for game end
	self.nonScoringPlayCount++;
	[self checkForGameEnd];

	return YES;
}

/*
 * determine all the new equations formed from the current
 * tile placement
 */
- (NSArray *)getAllEquations
{
	NSMutableArray *equations = [[NSMutableArray alloc] init];
	int lastSpace = EMPTY_SPACE;
	DFSEquation *eq = nil;
	
	// get the rows
	for (int i=0; i<ROWS; i++) {
		for (int j=0; j<COLUMNS; j++) {
			DFSBoardSpace *space = (DFSBoardSpace *)[self.gameBoard objectAtRow:i andColumn:j];
			if (space.tile) {
				// found a new equation
				if (lastSpace == EMPTY_SPACE) {
					eq = [[DFSEquation alloc] initWithBoardSpaces:[NSArray arrayWithObject:space]];
					lastSpace = FILLED_SPACE;
				// add to current equation
				} else {
					[eq addSpace:space];
				}
			} else {
				if (lastSpace == FILLED_SPACE) {
					lastSpace = EMPTY_SPACE;
					if (eq.spaces.count > 1) [equations addObject:eq];
					eq = nil;
				}
			}
		}
		// get the last equation on this row
		if (lastSpace == FILLED_SPACE) {
			lastSpace = EMPTY_SPACE;
			if (eq.spaces.count > 1) [equations addObject:eq];
			eq = nil;
		}
	}
	
	// get the columns
	for (int i=0; i<COLUMNS; i++) {
		for (int j=0; j<ROWS; j++) {
			DFSBoardSpace *space = (DFSBoardSpace *)[self.gameBoard objectAtRow:j andColumn:i];
			if (space.tile) {
				// found a new equation
				if (lastSpace == EMPTY_SPACE) {
					eq = [[DFSEquation alloc] initWithBoardSpaces:[NSArray arrayWithObject:space]];
					lastSpace = FILLED_SPACE;
					// add to current equation
				} else {
					[eq addSpace:space];
				}
			} else {
				if (lastSpace == FILLED_SPACE) {
					lastSpace = EMPTY_SPACE;
					if (eq.spaces.count > 1) [equations addObject:eq];
					eq = nil;
				}
			}
		}
		// get the last equation on this row
		if (lastSpace == FILLED_SPACE) {
			lastSpace = EMPTY_SPACE;
			if (eq.spaces.count > 1) [equations addObject:eq];
			eq = nil;
		}
	}
	
	// all equations
	return [equations copy];
}

/*
 * play the equations made
 */
- (BOOL)completeTurnForPlayer:(DFSPlayer *)player returnError:(NSString **)errorString
{
	if (self.gameIsOver) return NO;

	// must be this players turn
	if (player != self.currentPlayer) {
		*errorString = @"It's not your turn!";
		return NO;
	}
	
	// validate tile placement
	// center space used
    DFSBoardSpace *centerSpace = [self.gameBoard objectAtRow:7 andColumn:7];
	if (!centerSpace.tile) {
		*errorString = @"You must use the center space on the first turn";
		//return NO;
	}
	// get all placed tiles, check row and column
	NSMutableArray *usedSpaces = [[NSMutableArray alloc] init];
	NSMutableArray *rows = [[NSMutableArray alloc] init];
	NSMutableArray *cols = [[NSMutableArray alloc] init];
	for (int row=0; row<ROWS; row++) {
		for (int col=0; col<COLUMNS; col++) {
			id object = [self.gameBoard objectAtRow:row andColumn:col];
			if([object isKindOfClass:[DFSBoardSpace class]] && !((DFSBoardSpace *)object).locked && ((DFSBoardSpace *)object).tile){
				[usedSpaces addObject:object];
				[rows addObject:[NSNumber numberWithInt:row]];
				[cols addObject:[NSNumber numberWithInt:col]];
			}
		}
	}
	// at least one tile placed
	if (usedSpaces.count < 1) {
		*errorString = @"You must place at least one tile";
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
		lastRow = [number integerValue];
	}
	for (NSNumber *number in cols) {
		if (lastCol != -1 && lastCol != [number integerValue]) {
			oneCol = NO;
			break;
		}
		lastCol = [number integerValue];
	}
	if ((!oneRow && !oneCol) || (oneRow && oneCol)) {
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
	NSMutableSet *addedEquations = [[NSMutableSet alloc] init];
	NSArray *equations = [self getAllEquations];
	NSMutableSet *badEquations = [[NSMutableSet alloc] init];
	for (DFSEquation *equation in equations) {
		for (DFSBoardSpace *space in usedSpaces) {
			if ([equation.spaces containsObject:space]) {
				[addedEquations addObject:equation];
				if (!equation.isValid) {
					[badEquations addObject:equation];
					break;
				}
			}
		}
	}
    // found an invalid equation, just report the first one as the error
	if(badEquations.count > 0){
		*errorString = [[[badEquations anyObject] description] stringByAppendingString:@" is invalid!"];
		return NO;
	}
	
	// all valid so compute score and lock tiles
	int turn_score = 0;
	NSString *eqString;
	int high_score = 0;
	for (DFSEquation *eq in addedEquations) {
		int score = eq.score;
		self.currentPlayer.score += score;
		turn_score += score;
		if (score > high_score) {
			eqString = eq.description;
			high_score = score;
		}
	}
	for (DFSBoardSpace *space in usedSpaces) {
		space.locked = YES;
	}
	
	// replenish the current user's tileset
	for (int i=self.currentPlayer.tileSet.count; i < TILES; i++) {
		if (self.tilePool.count > 0) {
			int index = arc4random_uniform(self.tilePool.count);
			[self.currentPlayer.tileSet addObject:[self.tilePool objectAtIndex:index]];
			[self.tilePool removeObjectAtIndex:index];
		} else {
			break;
		}
	}
	
	// check for game end
	self.nonScoringPlayCount = 0;
	[self checkForGameEnd];
	
	// swap current player
	[self saveAction:DFS_PLAYED forPlayer:self.currentPlayer];
	[self switchPlayers];
	
	return YES;
}

/*
 * check to see if the player has placed any tiles
 */
- (BOOL)hasPlacedTiles
{
    for (int row=0; row<ROWS; row++) {
		for (int col=0; col<COLUMNS; col++) {
			id object = [self.gameBoard objectAtRow:row andColumn:col];
			if([object isKindOfClass:[DFSBoardSpace class]] && !((DFSBoardSpace *)object).locked && ((DFSBoardSpace *)object).tile){
				return YES;
			}
		}
	}
    return NO;
}

/*
 * player gives up
 */
- (BOOL)resignGameByPlayer:(DFSPlayer *)player returnError:(NSString **)errorString
{
    if (self.gameIsOver) return NO;
    
    // must be this players turn
	if (player != self.currentPlayer) {
		*errorString = @"You are not the current player";
		return NO;
	}
    
    self.resignedPlayer = player;
    [self checkForGameEnd];
    
    return YES;
}

/*
 * shuffle the players tiles
 */
- (BOOL)shuffleTilesForPlayer:(DFSPlayer *)player returnError:(NSString **)errorString
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:player.tileSet.count];
    
    NSMutableArray *copy = [player.tileSet mutableCopy];
    while ([copy count] > 0)
    {
        int index = arc4random() % [copy count];
        id objectToMove = [copy objectAtIndex:index];
        [array addObject:objectToMove];
        [copy removeObjectAtIndex:index];
    }
    
    player.tileSet = array;
    
    return YES;
}

@end
