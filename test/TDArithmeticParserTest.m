//
//  TDArithmeticParserTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TDArithmeticParserTest.h"

@implementation TDArithmeticParserTest

- (void)setUp {
	p = [TDArithmeticParser parser];
}


- (void)testOne {
	s = @"1";
	result = [p parse:s];
	STAssertEquals(1.0f, result, @"");
}


- (void)testFortySeven {
	s = @"47";
	result = [p parse:s];
	STAssertEquals(47.0f, result, @"");
}


- (void)testNegativeZero {
	s = @"-0";
	result = [p parse:s];
	STAssertEquals(-0.0f, result, @"");
}


- (void)testNegativeOne {
	s = @"-1";
	result = [p parse:s];
	STAssertEquals(-1.0f, result, @"");
}


- (void)testOnePlusOne {
	s = @"1 + 1";
	result = [p parse:s];
	STAssertEquals(2.0f, result, @"");
}


- (void)testOnePlusNegativeOne {
	s = @"1 + -1";
	result = [p parse:s];
	STAssertEquals(0.0f, result, @"");
}


- (void)testNegativeOnePlusOne {
	s = @"-1 + 1";
	result = [p parse:s];
	STAssertEquals(0.0f, result, @"");
}


- (void)testOneHundredPlusZero {
	s = @"100 + 0";
	result = [p parse:s];
	STAssertEquals(100.0f, result, @"");
}


- (void)testNegativeOnePlusZero {
	s = @"-1 + 0";
	result = [p parse:s];
	STAssertEquals(-1.0f, result, @"");
}


- (void)testNegativeZeroPlusZero {
	s = @"-0 + 0";
	result = [p parse:s];
	STAssertEquals(0.0f, result, @"");
}


- (void)testNegativeZeroPlusNegativeZero {
	s = @"-0 + -0";
	result = [p parse:s];
	STAssertEquals(-0.0f, result, @"");
}


- (void)testOneMinusOne {
	s = @"1 - 1";
	result = [p parse:s];
	STAssertEquals(0.0f, result, @"");
}


- (void)testOneMinusNegativeOne {
	s = @"1 - -1";
	result = [p parse:s];
	STAssertEquals(2.0f, result, @"");
}


- (void)testNegativeOneMinusOne {
	s = @"-1 - 1";
	result = [p parse:s];
	STAssertEquals(-2.0f, result, @"");
}


- (void)testOneHundredMinusZero {
	s = @"100 - 0";
	result = [p parse:s];
	STAssertEquals(100.0f, result, @"");
}


- (void)testNegativeOneMinusZero {
	s = @"-1 - 0";
	result = [p parse:s];
	STAssertEquals(-1.0f, result, @"");
}


- (void)testNegativeZeroMinusZero {
	s = @"-0 - 0";
	result = [p parse:s];
	STAssertEquals(-0.0f, result, @"");
}


- (void)testNegativeZeroMinusNegativeZero {
	s = @"-0 - -0";
	result = [p parse:s];
	STAssertEquals(0.0f, result, @"");
}


- (void)testOneTimesOne {
	s = @"1 * 1";
	result = [p parse:s];
	STAssertEquals(1.0f, result, @"");
}


- (void)testTwoTimesFour {
	s = @"2 * 4";
	result = [p parse:s];
	STAssertEquals(8.0f, result, @"");
}


- (void)testOneTimesNegativeOne {
	s = @"1 * -1";
	result = [p parse:s];
	STAssertEquals(-1.0f, result, @"");
}


- (void)testNegativeOneTimesOne {
	s = @"-1 * 1";
	result = [p parse:s];
	STAssertEquals(-1.0f, result, @"");
}


- (void)testOneHundredTimesZero {
	s = @"100 * 0";
	result = [p parse:s];
	STAssertEquals(0.0f, result, @"");
}


- (void)testNegativeOneTimesZero {
	s = @"-1 * 0";
	result = [p parse:s];
	STAssertEquals(-0.0f, result, @"");
}


- (void)testNegativeZeroTimesZero {
	s = @"-0 * 0";
	result = [p parse:s];
	STAssertEquals(-0.0f, result, @"");
}


- (void)testNegativeZeroTimesNegativeZero {
	s = @"-0 * -0";
	result = [p parse:s];
	STAssertEquals(0.0f, result, @"");
}


- (void)testOneDivOne {
	s = @"1 / 1";
	result = [p parse:s];
	STAssertEquals(1.0f, result, @"");
}


- (void)testTwoDivFour {
	s = @"2 / 4";
	result = [p parse:s];
	STAssertEquals(0.5f, result, @"");
}


- (void)testFourDivTwo {
	s = @"4 / 2";
	result = [p parse:s];
	STAssertEquals(2.0f, result, @"");
}


- (void)testOneDivNegativeOne {
	s = @"1 / -1";
	result = [p parse:s];
	STAssertEquals(-1.0f, result, @"");
}


- (void)testNegativeOneDivOne {
	s = @"-1 / 1";
	result = [p parse:s];
	STAssertEquals(-1.0f, result, @"");
}


- (void)testOneHundredDivZero {
	s = @"100 / 0";
	result = [p parse:s];
	STAssertEquals(INFINITY, result, @"");
}


- (void)testNegativeOneDivZero {
	s = @"-1 / 0";
	result = [p parse:s];
	STAssertEquals(-INFINITY, result, @"");
}


- (void)testNegativeZeroDivZero {
	s = @"-0 / 0";
	result = [p parse:s];
	STAssertEquals(NAN, result, @"");
}


- (void)testNegativeZeroDivNegativeZero {
	s = @"-0 / -0";
	result = [p parse:s];
	STAssertEquals(NAN, result, @"");
}


- (void)test1Exp1 {
	s = @"1 ^ 1";
	result = [p parse:s];
	STAssertEquals(1.0f, result, @"");
}


- (void)test1Exp2 {
	s = @"1 ^ 2";
	result = [p parse:s];
	STAssertEquals(1.0f, result, @"");
}


- (void)test9Exp2 {
	s = @"9 ^ 2";
	result = [p parse:s];
	STAssertEquals(81.0f, result, @"");
}


- (void)test9ExpNegative2 {
	s = @"9 ^ -2";
	result = [p parse:s];
	STAssertEquals(9.0f, result, @"");
}


#pragma mark -
#pragma mark Associativity

- (void)test7minus3minus1 { // minus associativity
	s = @"7 - 3 - 1";
	result = [p parse:s];
	STAssertEquals(3.0f, result, @"");
}


- (void)test9exp2minus81 { // exp associativity
	s = @"9^2 - 81";
	result = [p parse:s];
	STAssertEquals(0.0f, result, @"");
}


- (void)test2exp1exp4 { // exp
	s = @"2 ^ 1 ^ 4";
	result = [p parse:s];
	STAssertEquals(2.0f, result, @"");
}


- (void)test100minus5exp2times3 { // exp
	s = @"100 - 5^2*3";
	result = [p parse:s];
	STAssertEquals(25.0f, result, @"");
}


- (void)test100minus25times3 { // precedence
	s = @"100 - 25*3";
	result = [p parse:s];
	STAssertEquals(25.0f, result, @"");
}


- (void)test100minus25times3Parens { // precedence
	s = @"(100 - 25)*3";
	result = [p parse:s];
	STAssertEquals(225.0f, result, @"");
}


- (void)test100minus5exp2times3Parens { // precedence
	s = @"(100 - 5^2)*3";
	result = [p parse:s];
	STAssertEquals(225.0f, result, @"");
}

@end
