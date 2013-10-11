//
//  InfixCalculator.m
//  InfixCalculator
//
//  Created by Chris Bougher on 10/4/13.
//  Copyright (c) 2013 Chris Bougher. All rights reserved.
//

#import "InfixCalculator.h"
#import "NSMutableArray+stack.h"

NSString *const k_OPERANDS         = @"^*+-/()";
NSString *const k_DIGITS           = @"-1234567890.";
int const k_PRECEDENCE_PLUS        = 1;
int const k_PRECEDENCE_MINUS       = 1;
int const k_PRECEDENCE_MULTIPLY    = 2;
int const k_PRECEDENCE_DIVIDE      = 2;
int const k_PRECEDENCE_EXPONENT    = 3;
int const k_PRECEDENCE_PARANTHESIS = 4;

@interface InfixCalculator ()

+ (int)operatorToPrecendence:(NSString *)operator;
+ (BOOL)isOperand:(NSString *)string
	  allowParens:(BOOL)allowParens;
+ (BOOL)isNumber:(NSString *)string;
+ (double)performOperation:(NSString *)operation
					 using:(double)number1
					   and:(double)number2;
+ (double)evaluatePostfixEquation:(NSString *)equation;
+ (NSArray *)convertInfixToPostfix:(NSString *)infixEquation;

@end

@implementation InfixCalculator

+ (double)calculate:(NSString *)equation{
	NSArray *pf = [self convertInfixToPostfix:equation];
	
	NSString *pf_string = [pf componentsJoinedByString:@" "];
	
	double result = [self evaluatePostfixEquation:pf_string];
	
	return result;
}

+ (int)operatorToPrecendence:(NSString *)operator{
	
	if([operator isEqualToString:@"+"])
		return k_PRECEDENCE_PLUS;
	else if([operator isEqualToString:@"-"])
		return k_PRECEDENCE_MINUS;
	else if([operator isEqualToString:@"*"])
		return k_PRECEDENCE_MULTIPLY;
	else if([operator isEqualToString:@"^"])
		return k_PRECEDENCE_EXPONENT;
	else if([operator isEqualToString:@"/"]){
		return k_PRECEDENCE_DIVIDE;
	}
	
	return k_PRECEDENCE_PARANTHESIS;
}

/**
 * Is this string an operator?
 */
+ (BOOL)isOperand:(NSString *)string allowParens:(BOOL)allowParens{
	// string should be length == 1
	if (string.length != 1)
		return false;
	// operator found in list
	if([k_OPERANDS rangeOfString:string].location != NSNotFound)
		return true;
	// nothing found so it ain't an operator
	return false;
}

/**
 * Is this string a number?
 */
+ (BOOL)isNumber:(NSString *)string{
	
	// character set of digit characters
	NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:k_DIGITS];
	
	// character set of non-digit characters
	NSCharacterSet *notNumbers = [numbers invertedSet];
	
	// if the string does not contain a character from the
	// non-digit set then this is a number
	if([string rangeOfCharacterFromSet:notNumbers].location == NSNotFound)
		return true;
	
	// default the string is not a number
	return false;
}

+ (double)performOperation:(NSString *)operation
					 using:(double)number1
					   and:(double)number2{
	
	if([operation isEqualToString:@"+"])
		return number1 + number2;
	else if([operation isEqualToString:@"-"])
		return number1 - number2;
	else if([operation isEqualToString:@"*"])
		return number1 * number2;
	else if([operation isEqualToString:@"^"])
		return pow(number1, number2);
	else if([operation isEqualToString:@"/"]){
		if(number2 == 0)
			[NSException raise:@"Arithmatic Exception" format:@"Division by zero!"];
		return number1 / number2;
	} else {
		[NSException raise:@"Arithmatic Exception" format:@"%@ is not a valid operation", operation];
	}
	return 0;
}

+ (double)evaluatePostfixEquation:(NSString *)equation{
	NSArray *tokens = [equation componentsSeparatedByString:@" "];
	NSMutableArray *numberStack = [[NSMutableArray alloc] init];
	BOOL allowParens = false;
	
	for (NSString *token in tokens) {
		if(![token isEqualToString:@"-"] && [self isNumber:token]){
			double d = [token doubleValue];
			[numberStack push:[NSNumber numberWithDouble:d]];
		} else if([self isOperand:token allowParens:allowParens]){
			if(numberStack.count < 2)
				[NSException raise:@"Invalid Syntax Exception" format:@"Operator %@ must be preceded by at least two operands", token];
			double num1 = ((NSNumber *)[numberStack pop]).doubleValue;
			double num2 = ((NSNumber *)[numberStack pop]).doubleValue;
			double result = [self performOperation:token using:num2 and:num1];
			[numberStack push:[NSNumber numberWithDouble:result]];
		} else if([token stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0){
			[NSException raise:@"Invalid Syntax Exception" format:@"Token %@ is invalid, only use numbers and operators", token];
		}
	}
	return ((NSNumber *)[numberStack pop]).doubleValue;
}

+ (NSArray *)convertInfixToPostfix:(NSString *)infixEquation{
	NSMutableArray *output = [[NSMutableArray alloc] init];
	NSMutableArray *operandStack = [[NSMutableArray alloc] init];
	
	NSArray *words = [infixEquation componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceCharacterSet]];
	infixEquation = [words componentsJoinedByString:@""];
	
	for(int i=0; i<infixEquation.length; i++){
		NSString *token = [infixEquation substringWithRange:NSMakeRange(i, 1)];
		
		if([self isOperand:token allowParens:true]){
			if(operandStack.count == 0)
				[operandStack push:token];
			else if(operandStack.count > 0 && [token isEqualToString:@")"]){
				while (operandStack.count > 0 && ![(NSString *)operandStack.peek isEqualToString:@"("]) {
					[output push:operandStack.pop];
				}
				operandStack.pop;
			} else if(operandStack.count > 0){
				if(([token isEqualToString:@"("] && [(NSString *)operandStack.peek isEqualToString:@"("]) || (![token isEqualToString:@"("] && [self operatorToPrecendence:operandStack.peek] >= [self operatorToPrecendence:token])){
					while (operandStack.count > 0 && ![(NSString *)operandStack.peek isEqualToString:@"("]) {
						[output push:operandStack.pop];
					}
					[operandStack push:token];
				} else if([self operatorToPrecendence:operandStack.peek] < [self operatorToPrecendence:token]){
					[operandStack push:token];
				}
			}
		} else if([self isNumber:token]){
			while(i+1 < infixEquation.length){
				NSString *nextLetter = [infixEquation substringWithRange:NSMakeRange(i+1, 1)];
				if([nextLetter isEqualToString:@"-"])
					break;
				if([self isNumber:nextLetter]){
					token = [token stringByAppendingString:nextLetter];
					i++;
				} else {
					break;
				}
				
			}
			[output push:token];
		}
	}
	
	while(operandStack.count > 0){
		[output push:operandStack.pop];
	}
	
	return output;
}

@end
