//
//  NSMutableArray+stack.h
//  InfixCalculator
//
//  Created by Chris Bougher on 10/4/13.
//  Copyright (c) 2013 Chris Bougher. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Stack)

- (id)pop;
- (void)push:(id)object;
- (id)peek;

@end
