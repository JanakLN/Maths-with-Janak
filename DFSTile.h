//
//  DFSTile.h
//  Math with Nerds
//
//  Created by Chris Bougher on 10/13/13.
//  Copyright (c) 2013 Chris Bougher. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFSTile : NSObject <NSCoding>

@property (nonatomic) NSString *faceValue;
@property (nonatomic) int pointValue;

- (instancetype)initWithFaceValue:(NSString *)faceValue andPointValue:(int)pointValue;

@end
