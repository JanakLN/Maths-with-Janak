//
//  NSMutableArray+stack.m
//  InfixCalculator
//
//  Created by Chris Bougher on 10/4/13.
//  Copyright (c) 2013 Chris Bougher. All rights reserved.
//

#import "NSMutableArray+stack.h"

@implementation NSMutableArray (Stack)

- (id)pop{
	id object = [self lastObject];
	[self removeLastObject];
	
	return object;
}
- (void)push:(id)object{
	[self addObject:object];
}

- (id)peek{
	return [self lastObject];
}

@end
