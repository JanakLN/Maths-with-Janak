//
//  DFSGame.h
//  Math with Nerds
//
//  Created by Chris Bougher on 10/13/13.
//  Copyright (c) 2013 Chris Bougher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFSPlayer.h"
#import "DFSTile.h"
#import "DFSMatrix.h"
#import "DFSBoardSpace.h"

@interface DFSGame : NSObject <NSCoding>

/* game elements */
@property (strong, nonatomic) DFSPlayer *player1;
@property (strong, nonatomic) DFSPlayer	*player2;
@property (strong, nonatomic) DFSPlayer *currentPlayer;
@property (strong, nonatomic) DFSPlayer *resignedPlayer;
@property (strong, nonatomic) NSMutableArray *tilePool;
@property (strong, nonatomic) DFSMatrix *gameBoard;

/* game state */
@property (nonatomic) BOOL gameIsOver;
@property (strong, nonatomic) NSDate *lastUpdate;
@property (copy, nonatomic) NSString *lastAction;

/* initializers */
- (id)initNewGameWithPayer1:(DFSPlayer *)player1 andPlayer2:(DFSPlayer *)player2;

/* player actions */
- (BOOL)player:(DFSPlayer *)player placeTile:(DFSTile *)tile onSpace:(DFSBoardSpace *)space;
- (BOOL)passTurnForPlayer:(DFSPlayer *)player returnError:(NSString **)errorString;
- (BOOL)swapTiles:(NSArray *)tiles ForPlayer:(DFSPlayer *)player returnError:(NSString **)errorString;
- (BOOL)completeTurnForPlayer:(DFSPlayer *)player returnError:(NSString **)errorString;
- (BOOL)recallTilesForPlayer:(DFSPlayer *)player returnError:(NSString **)errorString;
- (BOOL)recallTile:(DFSTile *)tile forPlayer:(DFSPlayer *)player returnError:(NSString **)errorString;
- (BOOL)resignGameByPlayer:(DFSPlayer *)player returnError:(NSString **)errorString;
- (BOOL)shuffleTilesForPlayer:(DFSPlayer *)player returnError:(NSString **)errorString;

/* game state */
- (BOOL)hasPlacedTiles;
- (NSArray *)getAllEquations;

@end
