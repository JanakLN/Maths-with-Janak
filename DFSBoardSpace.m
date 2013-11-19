//
//  DFSBoardSpace.m
//  Math with Nerds
//
//  Created by Chris Bougher on 10/13/13.
//  Copyright (c) 2013 Chris Bougher. All rights reserved.
//

#import "DFSBoardSpace.h"

@implementation DFSBoardSpace

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super init]) {
		_tile = [aDecoder decodeObjectForKey:@"_tile"];
		_locked	= [aDecoder decodeBoolForKey:@"_locked"];
		_multiplier = [aDecoder decodeIntForKey:@"_multiplier"];
		_appliesToWord = [aDecoder decodeBoolForKey:@"_appliesToWord"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:_tile forKey:@"_tile"];
	[aCoder encodeBool:_locked forKey:@"_locked"];
	[aCoder encodeInt:_multiplier forKey:@"_multiplier"];
	[aCoder encodeBool:_appliesToWord forKey:@"_appliesToWord"];
}

/**
 * designated initializer;
 */
- (instancetype)initWithMultiplier:(int)multiplier andApplysToWord:(BOOL)appliesToWord
{
	if(self = [super init]){
		_multiplier = multiplier;
		_appliesToWord = appliesToWord;
	}
	return self;
}

/**
 * creates a default space
 */
- (instancetype)init
{
	return [self initWithMultiplier:1 andApplysToWord:NO];
}

@end
