//
//  DFSPlayer.h
//  Math with Nerds
//
//  Created by Chris Bougher on 10/13/13.
//  Copyright (c) 2013 Chris Bougher. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFSPlayer : NSObject <NSCoding>

@property (nonatomic) int score;
@property (strong, nonatomic) NSMutableArray *tileSet;
@property (strong, nonatomic) NSString *name;

- (id)initWithName:(NSString *)name andScore:(int)score andTileSet:(NSMutableArray *)tileSet;
- (id)init;

@end
