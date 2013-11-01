//
//  InfixCalculatorTests.m
//  InfixCalculatorTests
//
//  Created by Chris Bougher on 10/4/13.
//  Copyright (c) 2013 Chris Bougher. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "InfixCalculator.h"

@interface InfixCalculatorTests : XCTestCase

@end

@implementation InfixCalculatorTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAddition
{
	double answer = [InfixCalculator calculate:@"1+1"];
	double two = 2;
	
	XCTAssertEqual(two, answer, @"ADD: Answer should be %g but was %g",  two, answer);
}

- (void)testSubtraction
{
	double answer = [InfixCalculator calculate:@"10-8"];
	double two = 2;
	
	XCTAssertEqual(two, answer, @"SUBTRACT: Answer should be %g but was %g",  two, answer);
}

- (void)testMultiplication
{
	double answer = [InfixCalculator calculate:@"5*4"];
	double twenty = 20;
	
	XCTAssertEqual(twenty, answer, @"MULTIPLY: Answer should be %g but was %g",  twenty, answer);
}

- (void)testDivision
{
	double answer = [InfixCalculator calculate:@"75/3"];
	double twenty_five = 25;
	
	XCTAssertEqual(twenty_five, answer, @"DIVIDE: Answer should be %g but was %g",  twenty_five, answer);
}

- (void)testComplex
{
	double answer = [InfixCalculator calculate:@"4*5/2+6"];
	double sixteen = 16;
	
	XCTAssertEqual(sixteen, answer, @"COMPLEX: Answer should be %g but was %g",  sixteen, answer);
}
@end
