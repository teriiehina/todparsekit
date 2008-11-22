//
//  TDScientificNumberStateTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/25/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDScientificNumberStateTest.h"


@implementation TDScientificNumberStateTest

- (void)setUp {
    numberState = [[TDScientificNumberState alloc] init];
}


- (void)tearDown {
    [numberState release];
    [r release];
}


- (void)testSingleDigit {
    s = @"3";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(3.0f, t.floatValue, @"");    
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@"3", t.stringValue, @"");    
}



- (void)testDoubleDigit {
    s = @"47";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(47.0f, t.floatValue, @"");    
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@"47", t.stringValue, @"");    
}


- (void)testTripleDigit {
    s = @"654";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(654.0f, t.floatValue, @"");    
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@"654", t.stringValue, @"");    
}


- (void)testSingleDigitPositive {
    s = @"+3";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(3.0f, t.floatValue, @"");    
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@"+3", t.stringValue, @"");    
}


- (void)testDoubleDigitPositive {
    s = @"+22";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(22.0f, t.floatValue, @"");    
    STAssertTrue(t.isNumber, @"");    
}


- (void)testDoubleDigitPositiveSpace {
    s = @"+22 ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(22.0f, t.floatValue, @"");    
    STAssertTrue(t.isNumber, @"");    
}


- (void)testMultipleDots {
    s = @"1.1.1";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(1.1f, t.floatValue, @"");
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@"1.1", t.stringValue, @"");    
    
    t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(0.1f, t.floatValue, @"");
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@".1", t.stringValue, @"");    
}


- (void)testOneDot {
    s = @"1.";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(1.0f, t.floatValue, @"");
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@"1", t.stringValue, @"");    
}


- (void)testCustomOneDot {
    s = @"1.";
    r = [[TDReader alloc] initWithString:s];
    numberState.allowsTrailingDot = YES;
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(1.0f, t.floatValue, @"");
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@"1.", t.stringValue, @"");        
}


- (void)testOneDotZero {
    s = @"1.0";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(1.0f, t.floatValue, @"");
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@"1.0", t.stringValue, @"");
}


- (void)testPositiveOneDot {
    s = @"+1.";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(1.0f, t.floatValue, @"");
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@"+1", t.stringValue, @"");
}


- (void)testPositiveOneDotCustom {
    s = @"+1.";
    r = [[TDReader alloc] initWithString:s];
    numberState.allowsTrailingDot = YES;
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(1.0f, t.floatValue, @"");
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@"+1.", t.stringValue, @"");
}


- (void)testPositiveOneDotZero {
    s = @"+1.0";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(1.0f, t.floatValue, @"");
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@"+1.0", t.stringValue, @"");    
}


- (void)testPositiveOneDotZeroSpace {
    s = @"+1.0 ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(1.0f, t.floatValue, @"");
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@"+1.0", t.stringValue, @"");    
}


- (void)testNegativeOneDot {
    s = @"-1.";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(-1.0f, t.floatValue, @"");
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@"-1", t.stringValue, @"");
}


- (void)testNegativeOneDotCustom {
    s = @"-1.";
    r = [[TDReader alloc] initWithString:s];
    numberState.allowsTrailingDot = YES;
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(-1.0f, t.floatValue, @"");
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@"-1.", t.stringValue, @"");    
}


- (void)testNegativeOneDotSpace {
    s = @"-1. ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(-1.0f, t.floatValue, @"");
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@"-1", t.stringValue, @"");    
}


- (void)testNegativeOneDotZero {
    s = @"-1.0";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(-1.0f, t.floatValue, @"");
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@"-1.0", t.stringValue, @"");    
}


- (void)testNegativeOneDotZeroSpace {
    s = @"-1.0 ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(-1.0f, t.floatValue, @"");
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@"-1.0", t.stringValue, @"");    
}


- (void)testOneDotOne {
    s = @"1.1";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(1.1f, t.floatValue, @"");
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@"1.1", t.stringValue, @"");    
}


- (void)testZeroDotOne {
    s = @"0.1";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(0.1f, t.floatValue, @"");
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@"0.1", t.stringValue, @"");    
}


- (void)testDotOne {
    s = @".1";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(0.1f, t.floatValue, @"");
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@".1", t.stringValue, @"");    
}


- (void)testDotZero {
    s = @".0";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(0.0f, t.floatValue, @"");
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@".0", t.stringValue, @"");    
}


- (void)testNegativeDotZero {
    s = @"-.0";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(-0.0f, t.floatValue, @"");
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@"-.0", t.stringValue, @"");    
}


- (void)testPositiveDotZero {
    s = @"+.0";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(0.0f, t.floatValue, @"");
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@"+.0", t.stringValue, @"");    
}


- (void)testPositiveDotOne {
    s = @"+.1";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(0.1f, t.floatValue, @"");
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@"+.1", t.stringValue, @"");    
}


- (void)testNegativeDotOne {
    s = @"-.1";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(-0.1f, t.floatValue, @"");
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@"-.1", t.stringValue, @"");    
}


- (void)testNegativeDotOneOne {
    s = @"-.11";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(-0.11f, t.floatValue, @"");
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@"-.11", t.stringValue, @"");    
}


- (void)testNegativeDotOneOneOne {
    s = @"-.111";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(-0.111f, t.floatValue, @"");
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@"-.111", t.stringValue, @"");    
}


- (void)testNegativeDotOneOneOneZero {
    s = @"-.1110";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(-0.111f, t.floatValue, @"");
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@"-.1110", t.stringValue, @"");    
}


- (void)testNegativeDotOneOneOneZeroZero {
    s = @"-.11100";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(-0.111f, t.floatValue, @"");
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@"-.11100", t.stringValue, @"");    
}


- (void)testNegativeDotOneOneOneZeroSpace {
    s = @"-.1110 ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(-0.111f, t.floatValue, @"");
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@"-.1110", t.stringValue, @"");    
}


- (void)testZeroDotThreeSixtyFive {
    s = @"0.365";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(0.365f, t.floatValue, @"");
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@"0.365", t.stringValue, @"");    
}


- (void)testNegativeZeroDotThreeSixtyFive {
    s = @"-0.365";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(-0.365f, t.floatValue, @"");
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@"-0.365", t.stringValue, @"");    
}


- (void)testNegativeTwentyFourDotThreeSixtyFive {
    s = @"-24.365";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(-24.365f, t.floatValue, @"");
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@"-24.365", t.stringValue, @"");    
}


- (void)testTwentyFourDotThreeSixtyFive {
    s = @"24.365";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(24.365f, t.floatValue, @"");
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@"24.365", t.stringValue, @"");    
}


- (void)testZero {
    s = @"0";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(0.0f, t.floatValue, @"");    
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@"0", t.stringValue, @"");    
}


- (void)testNegativeOne {
    s = @"-1";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(-1.0f, t.floatValue, @"");    
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@"-1", t.stringValue, @"");    
}


- (void)testOne {
    s = @"1";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(1.0f, t.floatValue, @"");    
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@"1", t.stringValue, @"");    
}


- (void)testPositiveOne {
    s = @"+1";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(1.0f, t.floatValue, @"");    
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@"+1", t.stringValue, @"");    
}


- (void)testPositiveZero {
    s = @"+0";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(0.0f, t.floatValue, @"");    
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@"+0", t.stringValue, @"");    
}


- (void)testPositiveZeroSpace {
    s = @"+0 ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(0.0f, t.floatValue, @"");    
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@"+0", t.stringValue, @"");    
}


- (void)testNegativeZero {
    s = @"-0";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(-0.0f, t.floatValue, @"");
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(@"-0", t.stringValue, @"");    
}


- (void)testNull {
    s = @"NULL";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(0.0f, t.floatValue, @"");    
    STAssertFalse(t.isNumber, @"");    
}


- (void)testNil {
    s = @"nil";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(0.0f, t.floatValue, @"");    
    STAssertFalse(t.isNumber, @"");    
}


- (void)testEmptyString {
    s = @"";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(0.0f, t.floatValue, @"");    
    STAssertFalse(t.isNumber, @"");    
}


- (void)testDot {
    s = @".";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(0.0f, t.floatValue, @"");    
    STAssertFalse(t.isNumber, @"");    
}


- (void)testDotSpace {
    s = @". ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(0.0f, t.floatValue, @"");    
    STAssertFalse(t.isNumber, @"");    
}


- (void)testDotSpaceOne {
    s = @". 1";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(0.0f, t.floatValue, @"");    
    STAssertFalse(t.isNumber, @"");    
}


- (void)testPlus {
    s = @"+";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(0.0f, t.floatValue, @"");    
    STAssertFalse(t.isNumber, @"");    
}


- (void)testPlusSpace {
    s = @"+ ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(0.0f, t.floatValue, @"");    
    STAssertFalse(t.isNumber, @"");    
}


- (void)testPlusSpaceOne {
    s = @"+ 1";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(0.0f, t.floatValue, @"");    
    STAssertFalse(t.isNumber, @"");    
}


- (void)testMinus {
    s = @"-";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(0.0f, t.floatValue, @"");    
    STAssertFalse(t.isNumber, @"");    
}


- (void)testMinusSpace {
    s = @"- ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(0.0f, t.floatValue, @"");    
    STAssertFalse(t.isNumber, @"");    
}


- (void)testMinusSpaceOne {
    s = @"- 1";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(0.0f, t.floatValue, @"");    
    STAssertFalse(t.isNumber, @"");    
}


- (void)testInitSig {
    s = @"- (id)init {";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertNil(t.stringValue, @"");    
    STAssertEquals(0.0f, t.floatValue, @"");
}


#pragma mark -

- (void)test1e1 {
    s = @"1e1";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(10.0f, t.floatValue, @"");    
    STAssertTrue(t.isNumber, @"");    
}


- (void)test1e2 {
    s = @"1e2";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(100.0f, t.floatValue, @"");    
    STAssertTrue(t.isNumber, @"");    
}



- (void)test2dot0e2 {
    s = @"2.0e2";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(200.0f, t.floatValue, @"");    
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(s, t.stringValue, @"");    
}



- (void)test2dot0E2 {
    s = @"2.0E2";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(200.0f, t.floatValue, @"");    
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(s, t.stringValue, @"");    
}



- (void)test2e2 {
    s = @"2e2";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertEquals(200.0f, t.floatValue, @"");    
    STAssertTrue(t.isNumber, @"");    
    STAssertEqualObjects(s, t.stringValue, @"");    
}


- (void)test2eNegative2Tok {
    s = @"2e-2";
    TDTokenizer *t = [TDTokenizer tokenizer];
    TDScientificNumberState *sns = [[[TDScientificNumberState alloc] init] autorelease];
    t.numberState = sns;
    [t setTokenizerState:sns from:'0' to:'9'];
    [t setTokenizerState:sns from:'-' to:'-'];
    t.string = s;
    
    TDToken *tok = [t nextToken];
    STAssertEquals(-200.0f, tok.floatValue, @"");    
    STAssertTrue(tok.isNumber, @"");    
    STAssertEqualObjects(s, tok.stringValue, @"");    
    
    tok = [t nextToken];
    STAssertTrue([TDToken EOFToken] == tok, @"");    
}



- (void)test2e2Tok {
    s = @"2e2";
    TDTokenizer *t = [TDTokenizer tokenizer];
    TDScientificNumberState *sns = [[[TDScientificNumberState alloc] init] autorelease];
    t.numberState = sns;
    [t setTokenizerState:sns from:'0' to:'9'];
    [t setTokenizerState:sns from:'-' to:'-'];
    t.string = s;
    
    TDToken *tok = [t nextToken];
    STAssertEquals(200.0f, tok.floatValue, @"");    
    STAssertTrue(tok.isNumber, @"");    
    STAssertEqualObjects(s, tok.stringValue, @"");    
    
    tok = [t nextToken];
    STAssertTrue([TDToken EOFToken] == tok, @"");    
}



- (void)test2e2fooTok {
    s = @"2e2 foo";
    TDTokenizer *t = [TDTokenizer tokenizer];
    TDScientificNumberState *sns = [[[TDScientificNumberState alloc] init] autorelease];
    t.numberState = sns;
    [t setTokenizerState:sns from:'0' to:'9'];
    [t setTokenizerState:sns from:'-' to:'-'];
    t.string = s;
    
    TDToken *tok = [t nextToken];
    STAssertEquals(200.0f, tok.floatValue, @"");    
    STAssertTrue(tok.isNumber, @"");    
    STAssertEqualObjects(@"2e2", tok.stringValue, @"");    
    
    tok = [t nextToken];
    STAssertTrue(tok.isWord, @"");    
    STAssertEqualObjects(@"foo", tok.stringValue, @"");    
    
    tok = [t nextToken];
    STAssertTrue([TDToken EOFToken] == tok, @"");    
}


- (void)test2eNegative2fooTok {
    s = @"2e-2 foo";
    TDTokenizer *t = [TDTokenizer tokenizer];
    TDScientificNumberState *sns = [[[TDScientificNumberState alloc] init] autorelease];
    t.numberState = sns;
    [t setTokenizerState:sns from:'0' to:'9'];
    [t setTokenizerState:sns from:'-' to:'-'];
    t.string = s;
    
    TDToken *tok = [t nextToken];
    STAssertEquals(-200.0f, tok.floatValue, @"");    
    STAssertTrue(tok.isNumber, @"");    
    STAssertEqualObjects(@"2e-2", tok.stringValue, @"");    
    
    tok = [t nextToken];
    STAssertTrue(tok.isWord, @"");    
    STAssertEqualObjects(@"foo", tok.stringValue, @"");    
    
    tok = [t nextToken];
    STAssertTrue([TDToken EOFToken] == tok, @"");    
}


- (void)test2ePositive2fooTok {
    s = @"2e+2 foo";
    TDTokenizer *t = [TDTokenizer tokenizer];
    TDScientificNumberState *sns = [[[TDScientificNumberState alloc] init] autorelease];
    t.numberState = sns;
    [t setTokenizerState:sns from:'0' to:'9'];
    [t setTokenizerState:sns from:'-' to:'-'];
    t.string = s;
    
    TDToken *tok = [t nextToken];
    STAssertEquals(200.0f, tok.floatValue, @"");    
    STAssertTrue(tok.isNumber, @"");    
    STAssertEqualObjects(@"2e+2", tok.stringValue, @"");    
    
    tok = [t nextToken];
    STAssertTrue(tok.isWord, @"");    
    STAssertEqualObjects(@"foo", tok.stringValue, @"");    
    
    tok = [t nextToken];
    STAssertTrue([TDToken EOFToken] == tok, @"");    
}


- (void)test2dot0ePositive2fooTok {
    s = @"2.0e+2 foo";
    TDTokenizer *t = [TDTokenizer tokenizer];
    TDScientificNumberState *sns = [[[TDScientificNumberState alloc] init] autorelease];
    t.numberState = sns;
    [t setTokenizerState:sns from:'0' to:'9'];
    [t setTokenizerState:sns from:'-' to:'-'];
    t.string = s;
    
    TDToken *tok = [t nextToken];
    STAssertEquals(200.0f, tok.floatValue, @"");    
    STAssertTrue(tok.isNumber, @"");    
    STAssertEqualObjects(@"2.0e+2", tok.stringValue, @"");    
    
    tok = [t nextToken];
    STAssertTrue(tok.isWord, @"");    
    STAssertEqualObjects(@"foo", tok.stringValue, @"");    
    
    tok = [t nextToken];
    STAssertTrue([TDToken EOFToken] == tok, @"");    
}


- (void)test2dot0eNegative2fooTok {
    s = @"2.0e-2 foo";
    TDTokenizer *t = [TDTokenizer tokenizer];
    TDScientificNumberState *sns = [[[TDScientificNumberState alloc] init] autorelease];
    t.numberState = sns;
    [t setTokenizerState:sns from:'0' to:'9'];
    [t setTokenizerState:sns from:'-' to:'-'];
    t.string = s;
    
    TDToken *tok = [t nextToken];
    STAssertEquals(-200.0f, tok.floatValue, @"");    
    STAssertTrue(tok.isNumber, @"");    
    STAssertEqualObjects(@"2.0e-2", tok.stringValue, @"");    
    
    tok = [t nextToken];
    STAssertTrue(tok.isWord, @"");    
    STAssertEqualObjects(@"foo", tok.stringValue, @"");    
    
    tok = [t nextToken];
    STAssertTrue([TDToken EOFToken] == tok, @"");    
}

@end
