//
//  TDWordStateTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 6/7/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDWordStateTest.h"


@implementation TDWordStateTest

- (void)setUp {
    wordState = [[TDWordState alloc] init];
}


- (void)tearDown {
    [wordState release];
    [r release];
}


- (void)testA {
    s = @"a";
    r = [[PKReader alloc] initWithString:s];
    TDToken *tok = [wordState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEqualObjects(@"a", tok.stringValue);
    TDEqualObjects(@"a", tok.value);
    TDTrue(tok.isWord);
    TDEquals(TDEOF, [r read]);
}


- (void)testASpace {
    s = @"a ";
    r = [[PKReader alloc] initWithString:s];
    TDToken *tok = [wordState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEqualObjects(@"a", tok.stringValue);
    TDEqualObjects(@"a", tok.value);
    TDTrue(tok.isWord);
    TDEquals((TDUniChar)' ', [r read]);
}


- (void)testAb {
    s = @"ab";
    r = [[PKReader alloc] initWithString:s];
    TDToken *tok = [wordState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEqualObjects(s, tok.stringValue);
    TDEqualObjects(s, tok.value);
    TDTrue(tok.isWord);
    TDEquals(TDEOF, [r read]);
}


- (void)testAbc {
    s = @"abc";
    r = [[PKReader alloc] initWithString:s];
    TDToken *tok = [wordState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEqualObjects(s, tok.stringValue);
    TDEqualObjects(s, tok.value);
    TDTrue(tok.isWord);
    TDEquals(TDEOF, [r read]);
}


- (void)testItApostropheS {
    s = @"it's";
    r = [[PKReader alloc] initWithString:s];
    TDToken *tok = [wordState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEqualObjects(s, tok.stringValue);
    TDEqualObjects(s, tok.value);
    TDTrue(tok.isWord);
    TDEquals(TDEOF, [r read]);
}


- (void)testTwentyDashFive {
    s = @"twenty-five";
    r = [[PKReader alloc] initWithString:s];
    TDToken *tok = [wordState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEqualObjects(s, tok.stringValue);
    TDEqualObjects(s, tok.value);
    TDTrue(tok.isWord);
    TDEquals(TDEOF, [r read]);
}


- (void)testTwentyUnderscoreFive {
    s = @"twenty_five";
    r = [[PKReader alloc] initWithString:s];
    TDToken *tok = [wordState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEqualObjects(s, tok.stringValue);
    TDEqualObjects(s, tok.value);
    TDTrue(tok.isWord);
    TDEquals(TDEOF, [r read]);
}


- (void)testNumber1 {
    s = @"number1";
    r = [[PKReader alloc] initWithString:s];
    TDToken *tok = [wordState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEqualObjects(s, tok.stringValue);
    TDEqualObjects(s, tok.value);
    TDTrue(tok.isWord);
    TDEquals(TDEOF, [r read]);
}

@end
