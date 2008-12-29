//
//  TDNumberStateTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/29/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDNumberStateTest.h"

@implementation TDNumberStateTest

- (void)setUp {
    numberState = [[TDNumberState alloc] init];
}


- (void)tearDown {
    [numberState release];
    [r release];
}


- (void)testSingleDigit {
    s = @"3";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)3.0, t.floatValue);    
    TDTrue(t.isNumber);    
    TDEqualObjects(@"3", t.stringValue);    
}


- (void)testDoubleDigit {
    s = @"47";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)47.0, t.floatValue);    
    TDTrue(t.isNumber);    
    TDEqualObjects(@"47", t.stringValue);    
}


- (void)testTripleDigit {
    s = @"654";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)654.0, t.floatValue);    
    TDTrue(t.isNumber);    
    TDEqualObjects(@"654", t.stringValue);    
}


- (void)testSingleDigitPositive {
    s = @"+3";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)3.0, t.floatValue);    
    TDTrue(t.isNumber);    
    TDEqualObjects(@"+3", t.stringValue);    
}


- (void)testDoubleDigitPositive {
    s = @"+22";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)22.0, t.floatValue);    
    TDTrue(t.isNumber);    
}


- (void)testDoubleDigitPositiveSpace {
    s = @"+22 ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)22.0, t.floatValue);    
    TDTrue(t.isNumber);    
}


- (void)testMultipleDots {
    s = @"1.1.1";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)1.1, t.floatValue);
    TDTrue(t.isNumber);    
    TDEqualObjects(@"1.1", t.stringValue);    

    t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)0.1, t.floatValue);
    TDTrue(t.isNumber);    
    TDEqualObjects(@".1", t.stringValue);    
}


- (void)testOneDot {
    s = @"1.";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)1.0, t.floatValue);
    TDTrue(t.isNumber);    
    TDEqualObjects(@"1", t.stringValue);    
}


- (void)testCustomOneDot {
    s = @"1.";
    r = [[TDReader alloc] initWithString:s];
    numberState.allowsTrailingDot = YES;
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)1.0, t.floatValue);
    TDTrue(t.isNumber);    
    TDEqualObjects(@"1.", t.stringValue);        
}


- (void)testOneDotZero {
    s = @"1.0";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)1.0, t.floatValue);
    TDTrue(t.isNumber);    
    TDEqualObjects(@"1.0", t.stringValue);
}


- (void)testPositiveOneDot {
    s = @"+1.";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)1.0, t.floatValue);
    TDTrue(t.isNumber);    
    TDEqualObjects(@"+1", t.stringValue);
}


- (void)testPositiveOneDotCustom {
    s = @"+1.";
    r = [[TDReader alloc] initWithString:s];
    numberState.allowsTrailingDot = YES;
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)1.0, t.floatValue);
    TDTrue(t.isNumber);    
    TDEqualObjects(@"+1.", t.stringValue);
}


- (void)testPositiveOneDotZero {
    s = @"+1.0";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)1.0, t.floatValue);
    TDTrue(t.isNumber);    
    TDEqualObjects(@"+1.0", t.stringValue);    
}


- (void)testPositiveOneDotZeroSpace {
    s = @"+1.0 ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)1.0, t.floatValue);
    TDTrue(t.isNumber);    
    TDEqualObjects(@"+1.0", t.stringValue);    
}


- (void)testNegativeOneDot {
    s = @"-1.";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)-1.0, t.floatValue);
    TDTrue(t.isNumber);    
    TDEqualObjects(@"-1", t.stringValue);
}


- (void)testNegativeOneDotCustom {
    s = @"-1.";
    r = [[TDReader alloc] initWithString:s];
    numberState.allowsTrailingDot = YES;
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)-1.0, t.floatValue);
    TDTrue(t.isNumber);    
    TDEqualObjects(@"-1.", t.stringValue);    
}


- (void)testNegativeOneDotSpace {
    s = @"-1. ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)-1.0, t.floatValue);
    TDTrue(t.isNumber);    
    TDEqualObjects(@"-1", t.stringValue);    
}


- (void)testNegativeOneDotZero {
    s = @"-1.0";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)-1.0, t.floatValue);
    TDTrue(t.isNumber);    
    TDEqualObjects(@"-1.0", t.stringValue);    
}


- (void)testNegativeOneDotZeroSpace {
    s = @"-1.0 ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)-1.0, t.floatValue);
    TDTrue(t.isNumber);    
    TDEqualObjects(@"-1.0", t.stringValue);    
}


- (void)testOneDotOne {
    s = @"1.1";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)1.1, t.floatValue);
    TDTrue(t.isNumber);    
    TDEqualObjects(@"1.1", t.stringValue);    
}


- (void)testZeroDotOne {
    s = @"0.1";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)0.1, t.floatValue);
    TDTrue(t.isNumber);    
    TDEqualObjects(@"0.1", t.stringValue);    
}


- (void)testDotOne {
    s = @".1";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)0.1, t.floatValue);
    TDTrue(t.isNumber);    
    TDEqualObjects(@".1", t.stringValue);    
}


- (void)testDotZero {
    s = @".0";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)0.0, t.floatValue);
    TDTrue(t.isNumber);    
    TDEqualObjects(@".0", t.stringValue);    
}


- (void)testNegativeDotZero {
    s = @"-.0";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)-0.0, t.floatValue);
    TDTrue(t.isNumber);    
    TDEqualObjects(@"-.0", t.stringValue);    
}


- (void)testPositiveDotZero {
    s = @"+.0";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)0.0, t.floatValue);
    TDTrue(t.isNumber);    
    TDEqualObjects(@"+.0", t.stringValue);    
}


- (void)testPositiveDotOne {
    s = @"+.1";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)0.1, t.floatValue);
    TDTrue(t.isNumber);    
    TDEqualObjects(@"+.1", t.stringValue);    
}


- (void)testNegativeDotOne {
    s = @"-.1";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)-0.1, t.floatValue);
    TDTrue(t.isNumber);    
    TDEqualObjects(@"-.1", t.stringValue);    
}


- (void)testNegativeDotOneOne {
    s = @"-.11";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)-0.11, t.floatValue);
    TDTrue(t.isNumber);    
    TDEqualObjects(@"-.11", t.stringValue);    
}


- (void)testNegativeDotOneOneOne {
    s = @"-.111";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)-0.111, t.floatValue);
    TDTrue(t.isNumber);    
    TDEqualObjects(@"-.111", t.stringValue);    
}


- (void)testNegativeDotOneOneOneZero {
    s = @"-.1110";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)-0.111, t.floatValue);
    TDTrue(t.isNumber);    
    TDEqualObjects(@"-.1110", t.stringValue);    
}


- (void)testNegativeDotOneOneOneZeroZero {
    s = @"-.11100";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)-0.111, t.floatValue);
    TDTrue(t.isNumber);    
    TDEqualObjects(@"-.11100", t.stringValue);    
}


- (void)testNegativeDotOneOneOneZeroSpace {
    s = @"-.1110 ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)-0.111, t.floatValue);
    TDTrue(t.isNumber);    
    TDEqualObjects(@"-.1110", t.stringValue);    
}


- (void)testZeroDotThreeSixtyFive {
    s = @"0.365";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)0.365, t.floatValue);
    TDTrue(t.isNumber);    
    TDEqualObjects(@"0.365", t.stringValue);    
}


- (void)testNegativeZeroDotThreeSixtyFive {
    s = @"-0.365";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)-0.365, t.floatValue);
    TDTrue(t.isNumber);    
    TDEqualObjects(@"-0.365", t.stringValue);    
}


- (void)testNegativeTwentyFourDotThreeSixtyFive {
    s = @"-24.365";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)-24.365, t.floatValue);
    TDTrue(t.isNumber);    
    TDEqualObjects(@"-24.365", t.stringValue);    
}


- (void)testTwentyFourDotThreeSixtyFive {
    s = @"24.365";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)24.365, t.floatValue);
    TDTrue(t.isNumber);    
    TDEqualObjects(@"24.365", t.stringValue);    
}


- (void)testZero {
    s = @"0";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)0.0, t.floatValue);    
    TDTrue(t.isNumber);    
    TDEqualObjects(@"0", t.stringValue);    
}


- (void)testNegativeOne {
    s = @"-1";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)-1.0, t.floatValue);    
    TDTrue(t.isNumber);    
    TDEqualObjects(@"-1", t.stringValue);    
}


- (void)testOne {
    s = @"1";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)1.0, t.floatValue);    
    TDTrue(t.isNumber);    
    TDEqualObjects(@"1", t.stringValue);    
}


- (void)testPositiveOne {
    s = @"+1";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)1.0, t.floatValue);    
    TDTrue(t.isNumber);    
    TDEqualObjects(@"+1", t.stringValue);    
}


- (void)testPositiveZero {
    s = @"+0";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)0.0, t.floatValue);    
    TDTrue(t.isNumber);    
    TDEqualObjects(@"+0", t.stringValue);    
}


- (void)testPositiveZeroSpace {
    s = @"+0 ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)0.0, t.floatValue);    
    TDTrue(t.isNumber);    
    TDEqualObjects(@"+0", t.stringValue);    
}


- (void)testNegativeZero {
    s = @"-0";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)-0.0, t.floatValue);
    TDTrue(t.isNumber);    
    TDEqualObjects(@"-0", t.stringValue);    
}


- (void)testNull {
    s = @"NULL";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)0.0, t.floatValue);    
    TDFalse(t.isNumber);    
}


- (void)testNil {
    s = @"nil";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)0.0, t.floatValue);    
    TDFalse(t.isNumber);    
}


- (void)testEmptyString {
    s = @"";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)0.0, t.floatValue);    
    TDFalse(t.isNumber);    
}


- (void)testDot {
    s = @".";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)0.0, t.floatValue);    
    TDFalse(t.isNumber);    
}


- (void)testDotSpace {
    s = @". ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)0.0, t.floatValue);    
    TDFalse(t.isNumber);    
}


- (void)testDotSpaceOne {
    s = @". 1";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)0.0, t.floatValue);    
    TDFalse(t.isNumber);    
}


- (void)testPlus {
    s = @"+";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)0.0, t.floatValue);    
    TDFalse(t.isNumber);    
}


- (void)testPlusSpace {
    s = @"+ ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)0.0, t.floatValue);    
    TDFalse(t.isNumber);    
}


- (void)testPlusSpaceOne {
    s = @"+ 1";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)0.0, t.floatValue);    
    TDFalse(t.isNumber);    
}


- (void)testMinus {
    s = @"-";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)0.0, t.floatValue);    
    TDFalse(t.isNumber);    
}


- (void)testMinusSpace {
    s = @"- ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)0.0, t.floatValue);    
    TDFalse(t.isNumber);    
}


- (void)testMinusSpaceOne {
    s = @"- 1";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEquals((CGFloat)0.0, t.floatValue);    
    TDFalse(t.isNumber);    
}


- (void)testInitSig {
    s = @"- (id)init {";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNil(t.stringValue);    
    TDEquals((CGFloat)0.0, t.floatValue);
}



@end
