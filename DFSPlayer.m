//
//  DFSPlayer.m
//  Math with Nerds
//
//  Created by Chris Bougher on 10/13/13.
//  Copyright (c) 2013 Chris Bougher. All rights reserved.
//

#import "DFSPlayer.h"

@implementation DFSPlayer

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
	if(self = [super init]){
		_score = [aDecoder decodeIntForKey:@"_score"];
		_tileSet = [aDecoder decodeObjectForKey:@"_tileSet"];
		_gameCenterID = [aDecoder decodeObjectForKey:@"_gameCenterID"];
        _name = [aDecoder decodeObjectForKey:@"_name"];
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeInt:_score forKey:@"_score"];
	[aCoder encodeObject:_tileSet forKey:@"_tileSet"];
    [aCoder encodeObject:_gameCenterID forKey:@"_gameCenterID"];
	[aCoder encodeObject:_name forKey:@"_name"];
}

- (instancetype)initWithGameCenterID:(NSString *)gameCenterID andScore:(int)score andTileSet:(NSMutableArray *)tileSet
{
	if(self= [super init]){
		_score = score;
		_tileSet = tileSet;
		_gameCenterID = gameCenterID;
	}
	return self;
}

- (instancetype)init
{
	return [self initWithGameCenterID:@"???" andScore:0 andTileSet:nil];
}

- (NSString *)description
{
    NSString *description = self.gameCenterID ? self.name : @"Auto matched player";
	return description;
}

@end
