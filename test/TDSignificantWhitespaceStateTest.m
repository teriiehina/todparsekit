//
//  TDSignificantWhitespaceStateTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDSignificantWhitespaceStateTest.h"


@implementation TDSignificantWhitespaceStateTest

- (void)setUp {
	whitespaceState = [[TDSignificantWhitespaceState alloc] init];
}


- (void)tearDown {
	[whitespaceState release];
	[r release];
}


- (void)testSpace {
	s = @" ";
	r = [[TDReader alloc] initWithString:s];
	TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNotNil(t, @"");
	STAssertEqualObjects(s, t.stringValue, @"");
	STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testTwoSpaces {
	s = @"  ";
	r = [[TDReader alloc] initWithString:s];
	TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNotNil(t, @"");
	STAssertEqualObjects(s, t.stringValue, @"");
	STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testEmptyString {
	s = @"";
	r = [[TDReader alloc] initWithString:s];
	TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNotNil(t, @"");
	STAssertEqualObjects(s, t.stringValue, @"");
	STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testTab {
	s = @"\t";
	r = [[TDReader alloc] initWithString:s];
	TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNotNil(t, @"");
	STAssertEqualObjects(s, t.stringValue, @"");
	STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testNewLine {
	s = @"\n";
	r = [[TDReader alloc] initWithString:s];
	TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNotNil(t, @"");
	STAssertEqualObjects(s, t.stringValue, @"");
	STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testCarriageReturn {
	s = @"\r";
	r = [[TDReader alloc] initWithString:s];
	TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNotNil(t, @"");
	STAssertEqualObjects(s, t.stringValue, @"");
	STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testSpaceCarriageReturn {
	s = @" \r";
	r = [[TDReader alloc] initWithString:s];
	TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNotNil(t, @"");
	STAssertEqualObjects(s, t.stringValue, @"");
	STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testSpaceTabNewLineSpace {
	s = @" \t\n ";
	r = [[TDReader alloc] initWithString:s];
	TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNotNil(t, @"");
	STAssertEqualObjects(s, t.stringValue, @"");
	STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testSpaceA {
	s = @" a";
	r = [[TDReader alloc] initWithString:s];
	TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNotNil(t, @"");
	STAssertEqualObjects(@" ", t.stringValue, @"");
	STAssertEquals((NSInteger)'a', [r read], @"");
}

- (void)testSpaceASpace {
	s = @" a ";
	r = [[TDReader alloc] initWithString:s];
	TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNotNil(t, @"");
	STAssertEqualObjects(@" ", t.stringValue, @"");
	STAssertEquals((NSInteger)'a', [r read], @"");
}


- (void)testTabA {
	s = @"\ta";
	r = [[TDReader alloc] initWithString:s];
	TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNotNil(t, @"");
	STAssertEqualObjects(@"\t", t.stringValue, @"");
	STAssertEquals((NSInteger)'a', [r read], @"");
}


- (void)testNewLineA {
	s = @"\na";
	r = [[TDReader alloc] initWithString:s];
	TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNotNil(t, @"");
	STAssertEqualObjects(@"\n", t.stringValue, @"");
	STAssertEquals((NSInteger)'a', [r read], @"");
}


- (void)testCarriageReturnA {
	s = @"\ra";
	r = [[TDReader alloc] initWithString:s];
	TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNotNil(t, @"");
	STAssertEqualObjects(@"\r", t.stringValue, @"");
	STAssertEquals((NSInteger)'a', [r read], @"");
}


- (void)testNewLineSpaceCarriageReturnA {
	s = @"\n \ra";
	r = [[TDReader alloc] initWithString:s];
	TDToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNotNil(t, @"");
	STAssertEqualObjects(@"\n \r", t.stringValue, @"");
	STAssertEquals((NSInteger)'a', [r read], @"");
}


@end
