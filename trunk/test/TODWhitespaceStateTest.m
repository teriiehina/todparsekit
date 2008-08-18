//
//  TODWhitespaceStateTest.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 6/7/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODWhitespaceStateTest.h"


@implementation TODWhitespaceStateTest

- (void)setUp {
	whitespaceState = [[TODWhitespaceState alloc] init];
}


- (void)tearDown {
	[whitespaceState release];
	[r release];
}


- (void)testSpace {
	s = @" ";
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNil(t, @"");
	STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testTwoSpaces {
	s = @"  ";
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNil(t, @"");
	STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testNil {
	s = nil;
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNil(t, @"");
	STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testNull {
	s = NULL;
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNil(t, @"");
	STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testEmptyString {
	s = @"";
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNil(t, @"");
	STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testTab {
	s = @"\t";
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNil(t, @"");
	STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testNewLine {
	s = @"\n";
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNil(t, @"");
	STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testCarriageReturn {
	s = @"\r";
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNil(t, @"");
	STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testSpaceCarriageReturn {
	s = @" \r";
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNil(t, @"");
	STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testSpaceTabNewLineSpace {
	s = @" \t\n ";
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNil(t, @"");
	STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testSpaceA {
	s = @" a";
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNil(t.stringValue, @"");
	STAssertEquals((NSInteger)'a', [r read], @"");
}

- (void)testSpaceASpace {
	s = @" a ";
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNil(t.stringValue, @"");
	STAssertEquals((NSInteger)'a', [r read], @"");
}


- (void)testTabA {
	s = @"\ta";
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNil(t.stringValue, @"");
	STAssertEquals((NSInteger)'a', [r read], @"");
}


- (void)testNewLineA {
	s = @"\na";
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNil(t.stringValue, @"");
	STAssertEquals((NSInteger)'a', [r read], @"");
}


- (void)testCarriageReturnA {
	s = @"\ra";
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNil(t.stringValue, @"");
	STAssertEquals((NSInteger)'a', [r read], @"");
}


- (void)testNewLineSpaceCarriageReturnA {
	s = @"\n \ra";
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertNil(t.stringValue, @"");
	STAssertEquals((NSInteger)'a', [r read], @"");
}


@end
