//
//  TDWhitespaceStateTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 6/7/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDWhitespaceStateTest.h"


@implementation TDWhitespaceStateTest

- (void)setUp {
    whitespaceState = [[TDWhitespaceState alloc] init];
}


- (void)tearDown {
    [whitespaceState release];
    [r release];
}


- (void)testSpace {
    s = @" ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertNil(t, @"");
    STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testTwoSpaces {
    s = @"  ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertNil(t, @"");
    STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testNil {
    s = nil;
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertNil(t, @"");
    STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testNull {
    s = NULL;
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertNil(t, @"");
    STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testEmptyString {
    s = @"";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertNil(t, @"");
    STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testTab {
    s = @"\t";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertNil(t, @"");
    STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testNewLine {
    s = @"\n";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertNil(t, @"");
    STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testCarriageReturn {
    s = @"\r";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertNil(t, @"");
    STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testSpaceCarriageReturn {
    s = @" \r";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertNil(t, @"");
    STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testSpaceTabNewLineSpace {
    s = @" \t\n ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertNil(t, @"");
    STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testSpaceA {
    s = @" a";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertNil(t.stringValue, @"");
    STAssertEquals((NSInteger)'a', [r read], @"");
}

- (void)testSpaceASpace {
    s = @" a ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertNil(t.stringValue, @"");
    STAssertEquals((NSInteger)'a', [r read], @"");
}


- (void)testTabA {
    s = @"\ta";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertNil(t.stringValue, @"");
    STAssertEquals((NSInteger)'a', [r read], @"");
}


- (void)testNewLineA {
    s = @"\na";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertNil(t.stringValue, @"");
    STAssertEquals((NSInteger)'a', [r read], @"");
}


- (void)testCarriageReturnA {
    s = @"\ra";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertNil(t.stringValue, @"");
    STAssertEquals((NSInteger)'a', [r read], @"");
}


- (void)testNewLineSpaceCarriageReturnA {
    s = @"\n \ra";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertNil(t.stringValue, @"");
    STAssertEquals((NSInteger)'a', [r read], @"");
}


#pragma mark -
#pragma mark Significant

- (void)testSignificantSpace {
    whitespaceState.whitespaceIsSignificant = YES;
    s = @" ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertNotNil(t, @"");
    STAssertEqualObjects(s, t.stringValue, @"");
    STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testSignificantTwoSpaces {
    whitespaceState.whitespaceIsSignificant = YES;
    s = @"  ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertNotNil(t, @"");
    STAssertEqualObjects(s, t.stringValue, @"");
    STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testSignificantEmptyString {
    whitespaceState.whitespaceIsSignificant = YES;
    s = @"";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertNotNil(t, @"");
    STAssertEqualObjects(s, t.stringValue, @"");
    STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testSignificantTab {
    whitespaceState.whitespaceIsSignificant = YES;
    s = @"\t";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertNotNil(t, @"");
    STAssertEqualObjects(s, t.stringValue, @"");
    STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testSignificantNewLine {
    whitespaceState.whitespaceIsSignificant = YES;
    s = @"\n";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertNotNil(t, @"");
    STAssertEqualObjects(s, t.stringValue, @"");
    STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testSignificantCarriageReturn {
    whitespaceState.whitespaceIsSignificant = YES;
    s = @"\r";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertNotNil(t, @"");
    STAssertEqualObjects(s, t.stringValue, @"");
    STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testSignificantSpaceCarriageReturn {
    whitespaceState.whitespaceIsSignificant = YES;
    s = @" \r";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertNotNil(t, @"");
    STAssertEqualObjects(s, t.stringValue, @"");
    STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testSignificantSpaceTabNewLineSpace {
    whitespaceState.whitespaceIsSignificant = YES;
    s = @" \t\n ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertNotNil(t, @"");
    STAssertEqualObjects(s, t.stringValue, @"");
    STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testSignificantSpaceA {
    whitespaceState.whitespaceIsSignificant = YES;
    s = @" a";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertNotNil(t, @"");
    STAssertEqualObjects(@" ", t.stringValue, @"");
    STAssertEquals((NSInteger)'a', [r read], @"");
}


- (void)testSignificantSpaceASpace {
    whitespaceState.whitespaceIsSignificant = YES;
    s = @" a ";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertNotNil(t, @"");
    STAssertEqualObjects(@" ", t.stringValue, @"");
    STAssertEquals((NSInteger)'a', [r read], @"");
}


- (void)testSignificantTabA {
    whitespaceState.whitespaceIsSignificant = YES;
    s = @"\ta";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertNotNil(t, @"");
    STAssertEqualObjects(@"\t", t.stringValue, @"");
    STAssertEquals((NSInteger)'a', [r read], @"");
}


- (void)testSignificantNewLineA {
    whitespaceState.whitespaceIsSignificant = YES;
    s = @"\na";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertNotNil(t, @"");
    STAssertEqualObjects(@"\n", t.stringValue, @"");
    STAssertEquals((NSInteger)'a', [r read], @"");
}


- (void)testSignificantCarriageReturnA {
    whitespaceState.whitespaceIsSignificant = YES;
    s = @"\ra";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertNotNil(t, @"");
    STAssertEqualObjects(@"\r", t.stringValue, @"");
    STAssertEquals((NSInteger)'a', [r read], @"");
}


- (void)testSignificantNewLineSpaceCarriageReturnA {
    whitespaceState.whitespaceIsSignificant = YES;
    s = @"\n \ra";
    r = [[TDReader alloc] initWithString:s];
    TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    STAssertNotNil(t, @"");
    STAssertEqualObjects(@"\n \r", t.stringValue, @"");
    STAssertEquals((NSInteger)'a', [r read], @"");
}

@end