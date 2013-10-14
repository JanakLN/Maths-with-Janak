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

@interface DFSGame : NSObject <NSCoding>

@property (strong, nonatomic) DFSPlayer *player1;
@property (strong, nonatomic) DFSPlayer	*player2;
@property (strong, nonatomic) DFSPlayer *currentPlayer;

@property (strong, nonatomic) NSMutableArray *tilePool;
@property (strong, nonatomic) DFSMatrix *gameBoard;

//- (NSData *)getMatchData;
//
//+ (DFSGame *)initWithMatchData:(NSData *)matchData;
- (id)initNewGameWithPayer1:(DFSPlayer *)player1 andPlayer2:(DFSPlayer *)player2;

- (BOOL)player:(DFSPlayer *)player placeTile:(DFSTile *)tile atRow:(int)row andColumn:(int)column;

- (BOOL)passTurnForPlayer:(DFSPlayer *)player returnError:(NSString **)errorString;
- (BOOL)swapTiles:(NSArray *)tiles ForPlayer:(DFSPlayer *)player returnError:(NSString **)errorString;
- (BOOL)completeTurnForPlayer:(DFSPlayer *)player returnError:(NSString **)errorString;

@end
