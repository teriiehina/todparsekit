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
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [wordState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEqualObjects(@"a", t.stringValue);
    TDEqualObjects(@"a", t.value);
    TDTrue(t.isWord);
    TDEquals((NSInteger)-1, [r read]);
}


- (void)testASpace {
    s = @"a ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [wordState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEqualObjects(@"a", t.stringValue);
    TDEqualObjects(@"a", t.value);
    TDTrue(t.isWord);
    TDEquals((NSInteger)' ', [r read]);
}


- (void)testAb {
    s = @"ab";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [wordState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEqualObjects(s, t.stringValue);
    TDEqualObjects(s, t.value);
    TDTrue(t.isWord);
    TDEquals((NSInteger)-1, [r read]);
}


- (void)testAbc {
    s = @"abc";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [wordState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEqualObjects(s, t.stringValue);
    TDEqualObjects(s, t.value);
    TDTrue(t.isWord);
    TDEquals((NSInteger)-1, [r read]);
}


- (void)testItApostropheS {
    s = @"it's";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [wordState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEqualObjects(s, t.stringValue);
    TDEqualObjects(s, t.value);
    TDTrue(t.isWord);
    TDEquals((NSInteger)-1, [r read]);
}


- (void)testTwentyDashFive {
    s = @"twenty-five";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [wordState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEqualObjects(s, t.stringValue);
    TDEqualObjects(s, t.value);
    TDTrue(t.isWord);
    TDEquals((NSInteger)-1, [r read]);
}


- (void)testTwentyUnderscoreFive {
    s = @"twenty_five";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [wordState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEqualObjects(s, t.stringValue);
    TDEqualObjects(s, t.value);
    TDTrue(t.isWord);
    TDEquals((NSInteger)-1, [r read]);
}


- (void)testNumber1 {
    s = @"number1";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [wordState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEqualObjects(s, t.stringValue);
    TDEqualObjects(s, t.value);
    TDTrue(t.isWord);
    TDEquals((NSInteger)-1, [r read]);
}

@end