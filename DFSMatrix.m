//
//  DFSMatrix.m
//  Math with Nerds
//
//  Created by Chris Bougher on 10/13/13.
//  Copyright (c) 2013 Chris Bougher. All rights reserved.
//

#import "DFSMatrix.h"

@interface DFSMatrix () {
	int _rows;
	int _columns;
}

@property (strong, nonatomic) NSMutableArray *matrix;

@end

@implementation DFSMatrix

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super init]) {
		_rows = [aDecoder decodeIntForKey:@"_rows"];
		_columns = [aDecoder decodeIntForKey:@"_columns"];
		_matrix = [aDecoder decodeObjectForKey:@"_matrix"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeInt:_rows forKey:@"_rows"];
	[aCoder encodeInt:_columns forKey:@"_columns"];
	[aCoder encodeObject:_matrix forKey:@"_matrix"];
}

/**
 * get the number of rows in this matrix
 */
- (int)rows
{
	return _rows;
}

/**
 * get the number of columns in this matrix
 */
- (int)columns
{
	return _columns;
}

/**
 * initialize this matrix with number of rows and columns
 */
- (instancetype)initWithRows:(int)rows andColumns:(int)columns
{
	if(self = [super init]){
		_rows = rows;
		_columns = columns;
		self.matrix = [NSMutableArray arrayWithCapacity:_rows];
		for(int i=0; i<_rows; i++){
			self.matrix[i] = [NSMutableArray arrayWithCapacity:_columns];
			for(int j=0; j<_columns; j++){
				self.matrix[i][j] = [NSNull null];
			}
		}
	}
	return self;
}

/**
 * get the object at this row, coulmn
 */
- (id)objectAtRow:(int)row andColumn:(int)column
{
	return self.matrix[row][column];
}

/**
 * set the object at this row,column
 */
- (void)insertObject:(id)object atRow:(int)row andColumn:(int)column
{
	self.matrix[row][column] = object;
}

@end
