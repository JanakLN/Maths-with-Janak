//
//  InfixCalculator.h
//  InfixCalculator
//
//  Created by Chris Bougher on 10/4/13.
//  Copyright (c) 2013 Chris Bougher. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const k_OPERANDS;
FOUNDATION_EXPORT NSString *const k_DIGITS;
FOUNDATION_EXPORT int const k_PRECEDENCE_PLUS;
FOUNDATION_EXPORT int const k_PRECEDENCE_MINUS;
FOUNDATION_EXPORT int const k_PRECEDENCE_MULTIPLY;
FOUNDATION_EXPORT int const k_PRECEDENCE_DIVIDE;
FOUNDATION_EXPORT int const k_PRECEDENCE_EXPONENT;
FOUNDATION_EXPORT int const k_PRECEDENCE_PARANTHESIS;

@interface InfixCalculator : NSObject

+ (double)calculate:(NSString *)equation;

@end
