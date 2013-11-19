//
//  DFSEquation.m
//  Math with Nerds
//
//  Created by Chris Bougher on 10/14/13.
//  Copyright (c) 2013 Chris Bougher. All rights reserved.
//

#import "DFSEquation.h"
#import "DFSBoardSpace.h"
#import "InfixCalculator.h"

@interface DFSEquation ()

@property NSArray *boardSpaces;

@end

@implementation DFSEquation

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super init]) {
		_boardSpaces = [aDecoder decodeObjectForKey:@"_boardSpaces"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:_boardSpaces forKey:@"_boardSpaces"];
}

- (instancetype)initWithBoardSpaces:(NSArray *)boardSpaces
{
	if (self = [super init]) {
		_boardSpaces = boardSpaces;
	}
	return self;
}

- (instancetype)init
{
	return [self initWithBoardSpaces:nil];
}

- (NSArray *)spaces
{
	return self.boardSpaces;
}

- (void)addSpace:(id)newSpace
{
	NSMutableArray *spaces;
	if (self.boardSpaces) {
		spaces = [self.boardSpaces mutableCopy];
		[spaces addObject:newSpace];
	} else {
		spaces = [NSMutableArray arrayWithObject:newSpace];
	}
	
	self.boardSpaces = spaces;
}

/*
 * convert the tile set to a string
 */
- (NSString *)equationAsString
{
	NSMutableString *string = [[NSMutableString alloc] init];
	
	for (DFSBoardSpace *space in self.boardSpaces) {
		[string appendString:space.tile.faceValue];
	}
	
	return [string copy];
}

/*
 * what is the score for this equation?
 */
- (int)score
{
	int score= 0;
	
	// no score if it's not a valid equation
	if (!self.isValid) {
		return 0;
	}
	
	// get base score
	for (DFSBoardSpace *space in self.boardSpaces) {
		if (space.appliesToWord) {
			score += pow(space.tile.pointValue, space.multiplier);
		} else {
			score += space.tile.pointValue * space.multiplier;
		}
	}
	
	// look for word multiplier
//	for (DFSBoardSpace *space in self.boardSpaces) {
//		if (space.appliesToWord) {
//			score *= space.multiplier;
//		}
//	}
	
	return score;
}

/*
 * is this a valid equation?
 */
- (BOOL)isValid
{
	NSString *eq = self.equationAsString;
	
	// find the equals sign
	NSRange equals = [eq rangeOfString:@"="];
	
	// equation must have an = sign
	if (equals.location == NSNotFound) {
		return NO;
	}
	
    double leftValue;
    double rightValue;
	// equation left side must equal equation right side
	NSString *left = [eq substringToIndex:equals.location];
	NSString *right = [eq substringFromIndex:equals.location+1];
    @try {
        leftValue = [InfixCalculator calculate:left];
        rightValue = [InfixCalculator calculate:right];
    }
    @catch (NSException *exception) {
        return NO;
    }
	
	if (leftValue != rightValue) {
		return NO;
	}
	
	// valid if we get this far
	return YES;
}

- (NSString *)description
{
	return [self equationAsString];
}

@end
