//
//  DFSMatrix.h
//  Math with Nerds
//
//  Created by Chris Bougher on 10/13/13.
//  Copyright (c) 2013 Chris Bougher. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFSMatrix : NSObject <NSCoding>

@property (readonly) int rows;
@property (readonly) int columns;

- (instancetype)initWithRows:(int)rows andColumns:(int)columns;
- (id)objectAtRow:(int)row andColumn:(int)column;
- (void)insertObject:(id)object atRow:(int)row andColumn:(int)column;

@end
