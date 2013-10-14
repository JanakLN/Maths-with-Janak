//
//  DFSPlayer.m
//  Math with Nerds
//
//  Created by Chris Bougher on 10/13/13.
//  Copyright (c) 2013 Chris Bougher. All rights reserved.
//

#import "DFSPlayer.h"

@implementation DFSPlayer

@synthesize score = _score, tileSet = _tileSet;

-(id)initWithCoder:(NSCoder *)aDecoder
{
	if(self = [super init]){
		_score = [aDecoder decodeIntForKey:@"_score"];
		_tileSet = [aDecoder decodeObjectForKey:@"_tileSet"];
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeInt:_score forKey:@"_score"];
	[aCoder encodeObject:_tileSet forKey:@"_tileSet"];
}

- (id)initWithScore:(int)score andTileSet:(NSMutableArray *)tileSet
{
	if(self= [super init]){
		_score = score;
		_tileSet = tileSet;
	}
	return self;
}

- (id)init
{
	return [self initWithScore:0 andTileSet:nil];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"Player with score %d and tiles %@", self.score, self.tileSet];
}

@end
