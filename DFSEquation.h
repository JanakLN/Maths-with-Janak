//
//  DFSEquation.h
//  Math with Nerds
//
//  Created by Chris Bougher on 10/14/13.
//  Copyright (c) 2013 Chris Bougher. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DFSBoardSpace;

@interface DFSEquation : NSObject <NSCoding>

- (instancetype)initWithBoardSpaces:(NSArray *)boardSpaces;
- (instancetype)init;

- (void)addSpace:(DFSBoardSpace *)newSpace;

- (NSArray *)spaces;
- (NSString *)equationAsString;
- (int)score;
- (BOOL)isValid;

@end
