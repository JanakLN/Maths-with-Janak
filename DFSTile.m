//
//  DFSTile.m
//  Math with Nerds
//
//  Created by Chris Bougher on 10/13/13.
//  Copyright (c) 2013 Chris Bougher. All rights reserved.
//

#import "DFSTile.h"

@implementation DFSTile

@synthesize faceValue = _faceValue, pointValue = _pointValue;

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super init]) {
		_faceValue = [aDecoder decodeObjectForKey:@"_faceValue"];
		_pointValue = [aDecoder decodeIntForKey:@"_pointValue"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:_faceValue forKey:@"_faceValue"];
	[aCoder encodeInt:_pointValue forKey:@"_pointValue"];
}

- (id)initWithFaceValue:(NSString *)faceValue andPointValue:(int)pointValue
{
	if(self = [super init]){
		_faceValue = faceValue;
		_pointValue = pointValue;
	}
	return self;
}

- (NSString *)description
{
	return self.faceValue;
}

@end
