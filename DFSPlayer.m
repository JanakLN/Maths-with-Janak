//
//  DFSPlayer.m
//  Math with Nerds
//
//  Created by Chris Bougher on 10/13/13.
//  Copyright (c) 2013 Chris Bougher. All rights reserved.
//

#import "DFSPlayer.h"

@implementation DFSPlayer

@synthesize score = _score, tileSet = _tileSet, name = _name;

-(id)initWithCoder:(NSCoder *)aDecoder
{
	if(self = [super init]){
		_score = [aDecoder decodeIntForKey:@"_score"];
		_tileSet = [aDecoder decodeObjectForKey:@"_tileSet"];
		_name = [aDecoder decodeObjectForKey:@"_name"];
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeInt:_score forKey:@"_score"];
	[aCoder encodeObject:_tileSet forKey:@"_tileSet"];
	[aCoder encodeObject:_name forKey:@"_name"];
}

- (id)initWithName:(NSString *)name andScore:(int)score andTileSet:(NSMutableArray *)tileSet
{
	if(self= [super init]){
		_score = score;
		_tileSet = tileSet;
		_name = name;
	}
	return self;
}

- (id)init
{
	return [self initWithName:@"Player" andScore:0 andTileSet:nil];
}

- (NSString *)description
{
	//return [NSString stringWithFormat:@"Player with score %d and tiles %@", self.score, self.tileSet];
	return self.name;
}

@end
