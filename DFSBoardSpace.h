//
//  DFSBoardSpace.h
//  Math with Nerds
//
//  Created by Chris Bougher on 10/13/13.
//  Copyright (c) 2013 Chris Bougher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFSTile.h"

@interface DFSBoardSpace : NSObject <NSCoding>

@property (strong, nonatomic) DFSTile *tile;
@property (nonatomic) BOOL locked;
@property (nonatomic) int multiplier;
@property (nonatomic) BOOL appliesToWord;

- (id)initWithMultiplier:(int)multiplier andApplysToWord:(BOOL)appliesToWord;
- (id)init;

@end
