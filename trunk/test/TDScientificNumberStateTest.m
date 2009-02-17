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
    t = [[TDTokenizer alloc] init];
    r = [[TDReader alloc] init];
    numberState = [[TDScientificNumberState alloc] init];
    t.numberState = numberState;
    [t setTokenizerState:numberState from:'0' to:'9'];
    [t setTokenizerState:numberState from:'.' to:'.'];
    [t setTokenizerState:numberState from:'-' to:'-'];
}


- (void)tearDown {
    [numberState release];
    [r release];
}


- (void)testScientificNumberStringArithmetic {
    t.string = @"1e2 + 1e1 + 1e0 + 1e-1 + 1e-2 + 1e-3";
    TDArithmeticParser *p = [[[TDArithmeticParser alloc] init] autorelease];
    TDAssembly *a = [TDTokenAssembly assemblyWithTokenizer:t];
    TDAssembly *res = [p bestMatchFor:a];
    TDToken *tok = [res pop];
    TDEquals((CGFloat)111.111, tok.floatValue);
}


- (void)testSingleDigit {
    s = @"3";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)3.0, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"3", tok.stringValue);
}


- (void)testDoubleDigit {
    s = @"47";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)47.0, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"47", tok.stringValue);
}


- (void)testTripleDigit {
    s = @"654";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)654.0, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"654", tok.stringValue);
}


- (void)testSingleDigitPositive {
    s = @"+3";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)3.0, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"+3", tok.stringValue);
}


- (void)testDoubleDigitPositive {
    s = @"+22";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)22.0, tok.floatValue);
    TDTrue(tok.isNumber);
}


- (void)testDoubleDigitPositiveSpace {
    s = @"+22 ";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)22.0, tok.floatValue);
    TDTrue(tok.isNumber);
}


- (void)testMultipleDots {
    s = @"1.1.1";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)1.1, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"1.1", tok.stringValue);
    
    tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)0.1, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@".1", tok.stringValue);
}


- (void)testOneDot {
    s = @"1.";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)1.0, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"1", tok.stringValue);
}


- (void)testCustomOneDot {
    s = @"1.";
    t.string = s;
    r.string = s;
    numberState.allowsTrailingDot = YES;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)1.0, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"1.", tok.stringValue);    
}


- (void)testOneDotZero {
    s = @"1.0";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)1.0, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"1.0", tok.stringValue);
}


- (void)testPositiveOneDot {
    s = @"+1.";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)1.0, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"+1", tok.stringValue);
}


- (void)testPositiveOneDotCustom {
    s = @"+1.";
    t.string = s;
    r.string = s;
    numberState.allowsTrailingDot = YES;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)1.0, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"+1.", tok.stringValue);
}


- (void)testPositiveOneDotZero {
    s = @"+1.0";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)1.0, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"+1.0", tok.stringValue);
}


- (void)testPositiveOneDotZeroSpace {
    s = @"+1.0 ";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)1.0, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"+1.0", tok.stringValue);
}


- (void)testNegativeOneDot {
    s = @"-1.";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)-1.0, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"-1", tok.stringValue);
}


- (void)testNegativeOneDotCustom {
    s = @"-1.";
    t.string = s;
    r.string = s;
    numberState.allowsTrailingDot = YES;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)-1.0, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"-1.", tok.stringValue);
}


- (void)testNegativeOneDotSpace {
    s = @"-1. ";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)-1.0, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"-1", tok.stringValue);
}


- (void)testNegativeOneDotZero {
    s = @"-1.0";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)-1.0, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"-1.0", tok.stringValue);
}


- (void)testNegativeOneDotZeroSpace {
    s = @"-1.0 ";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)-1.0, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"-1.0", tok.stringValue);
}


- (void)testOneDotOne {
    s = @"1.1";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)1.1, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"1.1", tok.stringValue);
}


- (void)testZeroDotOne {
    s = @"0.1";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)0.1, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"0.1", tok.stringValue);
}


- (void)testDotOne {
    s = @".1";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)0.1, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@".1", tok.stringValue);
}


- (void)testDotZero {
    s = @".0";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)0.0, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@".0", tok.stringValue);
}


- (void)testNegativeDotZero {
    s = @"-.0";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)-0.0, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"-.0", tok.stringValue);
}


- (void)testPositiveDotZero {
    s = @"+.0";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)0.0, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"+.0", tok.stringValue);
}


- (void)testPositiveDotOne {
    s = @"+.1";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)0.1, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"+.1", tok.stringValue);
}


- (void)testNegativeDotOne {
    s = @"-.1";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)-0.1, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"-.1", tok.stringValue);
}


- (void)testNegativeDotOneOne {
    s = @"-.11";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)-0.11, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"-.11", tok.stringValue);
}


- (void)testNegativeDotOneOneOne {
    s = @"-.111";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)-0.111, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"-.111", tok.stringValue);
}


- (void)testNegativeDotOneOneOneZero {
    s = @"-.1110";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)-0.111, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"-.1110", tok.stringValue);
}


- (void)testNegativeDotOneOneOneZeroZero {
    s = @"-.11100";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)-0.111, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"-.11100", tok.stringValue);
}


- (void)testNegativeDotOneOneOneZeroSpace {
    s = @"-.1110 ";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)-0.111, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"-.1110", tok.stringValue);
}


- (void)testZeroDotThreeSixtyFive {
    s = @"0.365";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)0.365, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"0.365", tok.stringValue);
}


- (void)testNegativeZeroDotThreeSixtyFive {
    s = @"-0.365";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)-0.365, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"-0.365", tok.stringValue);
}


- (void)testNegativeTwentyFourDotThreeSixtyFive {
    s = @"-24.365";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)-24.365, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"-24.365", tok.stringValue);
}


- (void)testTwentyFourDotThreeSixtyFive {
    s = @"24.365";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)24.365, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"24.365", tok.stringValue);
}


- (void)testZero {
    s = @"0";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)0.0, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"0", tok.stringValue);
}


- (void)testNegativeOne {
    s = @"-1";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)-1.0, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"-1", tok.stringValue);
}


- (void)testOne {
    s = @"1";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)1.0, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"1", tok.stringValue);
}


- (void)testPositiveOne {
    s = @"+1";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)1.0, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"+1", tok.stringValue);
}


- (void)testPositiveZero {
    s = @"+0";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)0.0, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"+0", tok.stringValue);
}


- (void)testPositiveZeroSpace {
    s = @"+0 ";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)0.0, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"+0", tok.stringValue);
}


- (void)testNegativeZero {
    s = @"-0";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)-0.0, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"-0", tok.stringValue);
}


- (void)testNull {
    s = @"NULL";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)0.0, tok.floatValue);
    TDFalse(tok.isNumber);
}


- (void)testNil {
    s = @"nil";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)0.0, tok.floatValue);
    TDFalse(tok.isNumber);
}


- (void)testEmptyString {
    s = @"";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)0.0, tok.floatValue);
    TDFalse(tok.isNumber);
}


- (void)testDot {
    s = @".";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)0.0, tok.floatValue);
    TDFalse(tok.isNumber);
}


- (void)testDotSpace {
    s = @". ";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)0.0, tok.floatValue);
    TDFalse(tok.isNumber);
}


- (void)testDotSpaceOne {
    s = @". 1";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)0.0, tok.floatValue);
    TDFalse(tok.isNumber);
}


- (void)testPlus {
    s = @"+";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)0.0, tok.floatValue);
    TDFalse(tok.isNumber);
}


- (void)testPlusSpace {
    s = @"+ ";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)0.0, tok.floatValue);
    TDFalse(tok.isNumber);
}


- (void)testPlusSpaceOne {
    s = @"+ 1";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)0.0, tok.floatValue);
    TDFalse(tok.isNumber);
}


- (void)testMinus {
    s = @"-";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)0.0, tok.floatValue);
    TDFalse(tok.isNumber);
}


- (void)testMinusSpace {
    s = @"- ";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)0.0, tok.floatValue);
    TDFalse(tok.isNumber);
}


- (void)testMinusSpaceOne {
    s = @"- 1";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)0.0, tok.floatValue);
    TDFalse(tok.isNumber);
}


- (void)testInitSig {
    s = @"- (id)init {";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEqualObjects(@"-", tok.stringValue);
    TDEquals((CGFloat)0.0, tok.floatValue);
}


#pragma mark -

- (void)test1e1 {
    s = @"1e1";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)10.0, tok.floatValue);
    TDTrue(tok.isNumber);
}


- (void)test1e2 {
    s = @"1e2";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)100.0, tok.floatValue);
    TDTrue(tok.isNumber);
}



- (void)test2dot0e2 {
    s = @"2.0e2";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)200.0, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(s, tok.stringValue);
}



- (void)test2dot0E2 {
    s = @"2.0E2";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)200.0, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(s, tok.stringValue);
}



- (void)test2e2 {
    s = @"2e2";
    t.string = s;
    r.string = s;
    TDToken *tok = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    TDEquals((CGFloat)200.0, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(s, tok.stringValue);
}


- (void)test2eNegative2Tok {
    s = @"2e-2";
    t.string = s;
    r.string = s;
    
    TDToken *tok = [t nextToken];
    TDEquals((CGFloat)0.02, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(s, tok.stringValue);
    
    tok = [t nextToken];
    TDTrue([TDToken EOFToken] == tok);
}



- (void)test2e2Tok {
    s = @"2e2";
    t.string = s;
    r.string = s;
    
    TDToken *tok = [t nextToken];
    TDEquals((CGFloat)200.0, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(s, tok.stringValue);
    
    tok = [t nextToken];
    TDTrue([TDToken EOFToken] == tok);
}



- (void)test2e2fooTok {
    s = @"2e2 foo";
    t.string = s;
    r.string = s;
    
    TDToken *tok = [t nextToken];
    TDEquals((CGFloat)200.0, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"2e2", tok.stringValue);
    
    tok = [t nextToken];
    TDTrue(tok.isWord);
    TDEqualObjects(@"foo", tok.stringValue);
    
    tok = [t nextToken];
    TDTrue([TDToken EOFToken] == tok);
}


- (void)test2eNegative2fooTok {
    s = @"2e-2 foo";
    t.string = s;
    r.string = s;
    
    TDToken *tok = [t nextToken];
    TDEquals((CGFloat)0.02, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"2e-2", tok.stringValue);
    
    tok = [t nextToken];
    TDTrue(tok.isWord);
    TDEqualObjects(@"foo", tok.stringValue);
    
    tok = [t nextToken];
    TDTrue([TDToken EOFToken] == tok);
}


- (void)test2ePositive2fooTok {
    s = @"2e+2 foo";
    t.string = s;
    r.string = s;
    
    TDToken *tok = [t nextToken];
    TDEquals((CGFloat)200.0, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"2e+2", tok.stringValue);
    
    tok = [t nextToken];
    TDTrue(tok.isWord);
    TDEqualObjects(@"foo", tok.stringValue);
    
    tok = [t nextToken];
    TDTrue([TDToken EOFToken] == tok);
}


- (void)test2dot0ePositive2fooTok {
    s = @"2.0e+2 foo";
    t.string = s;
    r.string = s;
    
    TDToken *tok = [t nextToken];
    TDEquals((CGFloat)200.0, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"2.0e+2", tok.stringValue);
    
    tok = [t nextToken];
    TDTrue(tok.isWord);
    TDEqualObjects(@"foo", tok.stringValue);
    
    tok = [t nextToken];
    TDTrue([TDToken EOFToken] == tok);
}


- (void)test2dot0eNegative2fooTok {
    s = @"2.0e-2 foo";
    t.string = s;
    r.string = s;
    
    TDToken *tok = [t nextToken];
    TDEquals((CGFloat)0.02, tok.floatValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"2.0e-2", tok.stringValue);
    
    tok = [t nextToken];
    TDTrue(tok.isWord);
    TDEqualObjects(@"foo", tok.stringValue);
    
    tok = [t nextToken];
    TDTrue([TDToken EOFToken] == tok);
}

@end
