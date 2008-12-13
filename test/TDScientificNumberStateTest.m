//
//  TDScientificNumberStateTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/25/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDScientificNumberStateTest.h"
#import "TDArithmeticParser.h"

@implementation TDScientificNumberStateTest

- (void)setUp {
    numberState = [[TDScientificNumberState alloc] init];
}


- (void)tearDown {
    [numberState release];
    [r release];
}


- (void)testScientificNumberStringArithmetic {
    TDScientificNumberState *sns = [[[TDScientificNumberState alloc] init] autorelease];
    TDTokenizer *t = [[[TDTokenizer alloc] init] autorelease];
    [t setTokenizerState:sns from:'0' to:'9'];
    [t setTokenizerState:sns from:'.' to:'.'];
    [t setTokenizerState:sns from:'-' to:'-'];
    t.string = @"1e2 + 1e1 + 1e0 + 1e-1 + 1e-2 + 1e-3";
    TDArithmeticParser *p = [[[TDArithmeticParser alloc] init] autorelease];
    TDAssembly *a = [TDTokenAssembly assemblyWithTokenizer:t];
    TDAssembly *res = [p bestMatchFor:a];
    TDAssertEquals(111.111f, [[res pop] floatValue]);
}


- (void)testSingleDigit {
    s = @"3";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(3.0f, t.floatValue);    
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@"3", t.stringValue);    
}


- (void)testDoubleDigit {
    s = @"47";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(47.0f, t.floatValue);    
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@"47", t.stringValue);    
}


- (void)testTripleDigit {
    s = @"654";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(654.0f, t.floatValue);    
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@"654", t.stringValue);    
}


- (void)testSingleDigitPositive {
    s = @"+3";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(3.0f, t.floatValue);    
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@"+3", t.stringValue);    
}


- (void)testDoubleDigitPositive {
    s = @"+22";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(22.0f, t.floatValue);    
    TDAssertTrue(t.isNumber);    
}


- (void)testDoubleDigitPositiveSpace {
    s = @"+22 ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(22.0f, t.floatValue);    
    TDAssertTrue(t.isNumber);    
}


- (void)testMultipleDots {
    s = @"1.1.1";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(1.1f, t.floatValue);
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@"1.1", t.stringValue);    
    
    t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(0.1f, t.floatValue);
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@".1", t.stringValue);    
}


- (void)testOneDot {
    s = @"1.";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(1.0f, t.floatValue);
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@"1", t.stringValue);    
}


- (void)testCustomOneDot {
    s = @"1.";
    r = [[TDReader alloc] initWithString:s];
    numberState.allowsTrailingDot = YES;
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(1.0f, t.floatValue);
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@"1.", t.stringValue);        
}


- (void)testOneDotZero {
    s = @"1.0";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(1.0f, t.floatValue);
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@"1.0", t.stringValue);
}


- (void)testPositiveOneDot {
    s = @"+1.";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(1.0f, t.floatValue);
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@"+1", t.stringValue);
}


- (void)testPositiveOneDotCustom {
    s = @"+1.";
    r = [[TDReader alloc] initWithString:s];
    numberState.allowsTrailingDot = YES;
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(1.0f, t.floatValue);
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@"+1.", t.stringValue);
}


- (void)testPositiveOneDotZero {
    s = @"+1.0";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(1.0f, t.floatValue);
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@"+1.0", t.stringValue);    
}


- (void)testPositiveOneDotZeroSpace {
    s = @"+1.0 ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(1.0f, t.floatValue);
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@"+1.0", t.stringValue);    
}


- (void)testNegativeOneDot {
    s = @"-1.";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(-1.0f, t.floatValue);
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@"-1", t.stringValue);
}


- (void)testNegativeOneDotCustom {
    s = @"-1.";
    r = [[TDReader alloc] initWithString:s];
    numberState.allowsTrailingDot = YES;
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(-1.0f, t.floatValue);
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@"-1.", t.stringValue);    
}


- (void)testNegativeOneDotSpace {
    s = @"-1. ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(-1.0f, t.floatValue);
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@"-1", t.stringValue);    
}


- (void)testNegativeOneDotZero {
    s = @"-1.0";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(-1.0f, t.floatValue);
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@"-1.0", t.stringValue);    
}


- (void)testNegativeOneDotZeroSpace {
    s = @"-1.0 ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(-1.0f, t.floatValue);
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@"-1.0", t.stringValue);    
}


- (void)testOneDotOne {
    s = @"1.1";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(1.1f, t.floatValue);
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@"1.1", t.stringValue);    
}


- (void)testZeroDotOne {
    s = @"0.1";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(0.1f, t.floatValue);
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@"0.1", t.stringValue);    
}


- (void)testDotOne {
    s = @".1";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(0.1f, t.floatValue);
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@".1", t.stringValue);    
}


- (void)testDotZero {
    s = @".0";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(0.0f, t.floatValue);
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@".0", t.stringValue);    
}


- (void)testNegativeDotZero {
    s = @"-.0";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(-0.0f, t.floatValue);
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@"-.0", t.stringValue);    
}


- (void)testPositiveDotZero {
    s = @"+.0";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(0.0f, t.floatValue);
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@"+.0", t.stringValue);    
}


- (void)testPositiveDotOne {
    s = @"+.1";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(0.1f, t.floatValue);
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@"+.1", t.stringValue);    
}


- (void)testNegativeDotOne {
    s = @"-.1";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(-0.1f, t.floatValue);
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@"-.1", t.stringValue);    
}


- (void)testNegativeDotOneOne {
    s = @"-.11";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(-0.11f, t.floatValue);
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@"-.11", t.stringValue);    
}


- (void)testNegativeDotOneOneOne {
    s = @"-.111";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(-0.111f, t.floatValue);
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@"-.111", t.stringValue);    
}


- (void)testNegativeDotOneOneOneZero {
    s = @"-.1110";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(-0.111f, t.floatValue);
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@"-.1110", t.stringValue);    
}


- (void)testNegativeDotOneOneOneZeroZero {
    s = @"-.11100";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(-0.111f, t.floatValue);
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@"-.11100", t.stringValue);    
}


- (void)testNegativeDotOneOneOneZeroSpace {
    s = @"-.1110 ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(-0.111f, t.floatValue);
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@"-.1110", t.stringValue);    
}


- (void)testZeroDotThreeSixtyFive {
    s = @"0.365";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(0.365f, t.floatValue);
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@"0.365", t.stringValue);    
}


- (void)testNegativeZeroDotThreeSixtyFive {
    s = @"-0.365";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(-0.365f, t.floatValue);
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@"-0.365", t.stringValue);    
}


- (void)testNegativeTwentyFourDotThreeSixtyFive {
    s = @"-24.365";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(-24.365f, t.floatValue);
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@"-24.365", t.stringValue);    
}


- (void)testTwentyFourDotThreeSixtyFive {
    s = @"24.365";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(24.365f, t.floatValue);
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@"24.365", t.stringValue);    
}


- (void)testZero {
    s = @"0";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(0.0f, t.floatValue);    
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@"0", t.stringValue);    
}


- (void)testNegativeOne {
    s = @"-1";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(-1.0f, t.floatValue);    
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@"-1", t.stringValue);    
}


- (void)testOne {
    s = @"1";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(1.0f, t.floatValue);    
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@"1", t.stringValue);    
}


- (void)testPositiveOne {
    s = @"+1";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(1.0f, t.floatValue);    
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@"+1", t.stringValue);    
}


- (void)testPositiveZero {
    s = @"+0";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(0.0f, t.floatValue);    
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@"+0", t.stringValue);    
}


- (void)testPositiveZeroSpace {
    s = @"+0 ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(0.0f, t.floatValue);    
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@"+0", t.stringValue);    
}


- (void)testNegativeZero {
    s = @"-0";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(-0.0f, t.floatValue);
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(@"-0", t.stringValue);    
}


- (void)testNull {
    s = @"NULL";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(0.0f, t.floatValue);    
    TDAssertFalse(t.isNumber);    
}


- (void)testNil {
    s = @"nil";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(0.0f, t.floatValue);    
    TDAssertFalse(t.isNumber);    
}


- (void)testEmptyString {
    s = @"";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(0.0f, t.floatValue);    
    TDAssertFalse(t.isNumber);    
}


- (void)testDot {
    s = @".";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(0.0f, t.floatValue);    
    TDAssertFalse(t.isNumber);    
}


- (void)testDotSpace {
    s = @". ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(0.0f, t.floatValue);    
    TDAssertFalse(t.isNumber);    
}


- (void)testDotSpaceOne {
    s = @". 1";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(0.0f, t.floatValue);    
    TDAssertFalse(t.isNumber);    
}


- (void)testPlus {
    s = @"+";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(0.0f, t.floatValue);    
    TDAssertFalse(t.isNumber);    
}


- (void)testPlusSpace {
    s = @"+ ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(0.0f, t.floatValue);    
    TDAssertFalse(t.isNumber);    
}


- (void)testPlusSpaceOne {
    s = @"+ 1";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(0.0f, t.floatValue);    
    TDAssertFalse(t.isNumber);    
}


- (void)testMinus {
    s = @"-";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(0.0f, t.floatValue);    
    TDAssertFalse(t.isNumber);    
}


- (void)testMinusSpace {
    s = @"- ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(0.0f, t.floatValue);    
    TDAssertFalse(t.isNumber);    
}


- (void)testMinusSpaceOne {
    s = @"- 1";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(0.0f, t.floatValue);    
    TDAssertFalse(t.isNumber);    
}


- (void)testInitSig {
    s = @"- (id)init {";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertNil(t.stringValue);    
    TDAssertEquals(0.0f, t.floatValue);
}


#pragma mark -

- (void)test1e1 {
    s = @"1e1";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(10.0f, t.floatValue);    
    TDAssertTrue(t.isNumber);    
}


- (void)test1e2 {
    s = @"1e2";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(100.0f, t.floatValue);    
    TDAssertTrue(t.isNumber);    
}



- (void)test2dot0e2 {
    s = @"2.0e2";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(200.0f, t.floatValue);    
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(s, t.stringValue);    
}



- (void)test2dot0E2 {
    s = @"2.0E2";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(200.0f, t.floatValue);    
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(s, t.stringValue);    
}



- (void)test2e2 {
    s = @"2e2";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDAssertEquals(200.0f, t.floatValue);    
    TDAssertTrue(t.isNumber);    
    TDAssertEqualObjects(s, t.stringValue);    
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
    TDAssertEquals(0.02f, tok.floatValue);    
    TDAssertTrue(tok.isNumber);    
    TDAssertEqualObjects(s, tok.stringValue);    
    
    tok = [t nextToken];
    TDAssertTrue([TDToken EOFToken] == tok);    
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
    TDAssertEquals(200.0f, tok.floatValue);    
    TDAssertTrue(tok.isNumber);    
    TDAssertEqualObjects(s, tok.stringValue);    
    
    tok = [t nextToken];
    TDAssertTrue([TDToken EOFToken] == tok);    
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
    TDAssertEquals(200.0f, tok.floatValue);    
    TDAssertTrue(tok.isNumber);    
    TDAssertEqualObjects(@"2e2", tok.stringValue);    
    
    tok = [t nextToken];
    TDAssertTrue(tok.isWord);    
    TDAssertEqualObjects(@"foo", tok.stringValue);    
    
    tok = [t nextToken];
    TDAssertTrue([TDToken EOFToken] == tok);    
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
    TDAssertEquals(0.02f, tok.floatValue);    
    TDAssertTrue(tok.isNumber);    
    TDAssertEqualObjects(@"2e-2", tok.stringValue);    
    
    tok = [t nextToken];
    TDAssertTrue(tok.isWord);    
    TDAssertEqualObjects(@"foo", tok.stringValue);    
    
    tok = [t nextToken];
    TDAssertTrue([TDToken EOFToken] == tok);    
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
    TDAssertEquals(200.0f, tok.floatValue);    
    TDAssertTrue(tok.isNumber);    
    TDAssertEqualObjects(@"2e+2", tok.stringValue);    
    
    tok = [t nextToken];
    TDAssertTrue(tok.isWord);    
    TDAssertEqualObjects(@"foo", tok.stringValue);    
    
    tok = [t nextToken];
    TDAssertTrue([TDToken EOFToken] == tok);    
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
    TDAssertEquals(200.0f, tok.floatValue);    
    TDAssertTrue(tok.isNumber);    
    TDAssertEqualObjects(@"2.0e+2", tok.stringValue);    
    
    tok = [t nextToken];
    TDAssertTrue(tok.isWord);    
    TDAssertEqualObjects(@"foo", tok.stringValue);    
    
    tok = [t nextToken];
    TDAssertTrue([TDToken EOFToken] == tok);    
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
    TDAssertEquals(0.02f, tok.floatValue);    
    TDAssertTrue(tok.isNumber);    
    TDAssertEqualObjects(@"2.0e-2", tok.stringValue);    
    
    tok = [t nextToken];
    TDAssertTrue(tok.isWord);    
    TDAssertEqualObjects(@"foo", tok.stringValue);    
    
    tok = [t nextToken];
    TDAssertTrue([TDToken EOFToken] == tok);    
}

@end
